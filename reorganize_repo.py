#!/usr/bin/env python3
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parent
MATLAB = ROOT / "matlab"
SIMULINK = ROOT / "simulink"
DOCS = ROOT / "docs"
FIGURES = ROOT / "assets" / "figures"
VIDEOS = ROOT / "assets" / "videos"

for d in (MATLAB, SIMULINK, DOCS, FIGURES, VIDEOS):
    d.mkdir(parents=True, exist_ok=True)

# Adapter automatiquement l'application AVANT son déplacement.
app_file = ROOT / "app_tp_arborescence.m"
if app_file.exists():
    app = app_file.read_text(encoding="utf-8", errors="replace")

    old_header = """appDir = fileparts(mfilename('fullpath'));
cd(appDir);
addpath(appDir);"""
    new_header = """appDir = fileparts(mfilename('fullpath'));
repoDir = fileparts(appDir);
matlabDir = fullfile(repoDir,'matlab');
simulinkDir = fullfile(repoDir,'simulink');

cd(repoDir);
addpath(genpath(matlabDir));
addpath(simulinkDir);"""
    app = app.replace(old_header, new_header)

    # Evite le bug de concaténation lorsque plusieurs scripts sont associés
    # à une même étape (notamment Partie 5).
    old_item = """function s = item(group,label,question,script,test,slx,interp)
s = struct('group',group,'label',label,'question',question, ...
    'script',script,'test',test,'slx',slx,'interp',interp);
end"""
    new_item = """function s = item(group,label,question,script,test,slx,interp)
s.group = group;
s.label = label;
s.question = question;
s.script = script;
s.test = test;
s.slx = slx;
s.interp = interp;
end"""
    app = app.replace(old_item, new_item)

    app_file.write_text(app, encoding="utf-8")
    print("Application adaptée à la nouvelle arborescence.")

def git_mv(src: Path, dst: Path):
    if not src.exists():
        return
    dst.parent.mkdir(parents=True, exist_ok=True)

    # git mv si le fichier est suivi, sinon déplacement normal.
    tracked = subprocess.run(
        ["git", "ls-files", "--error-unmatch", str(src.relative_to(ROOT))],
        cwd=ROOT, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    ).returncode == 0

    if tracked:
        subprocess.run(
            ["git", "mv", str(src.relative_to(ROOT)), str(dst.relative_to(ROOT))],
            cwd=ROOT, check=True
        )
    else:
        shutil.move(str(src), str(dst))
    print(f"{src.name} -> {dst.relative_to(ROOT)}")

# 1. Tous les fichiers MATLAB dans matlab/
for p in list(ROOT.glob("*.m")):
    git_mv(p, MATLAB / p.name)

# 2. Tous les modèles Simulink dans simulink/
for p in list(ROOT.glob("*.slx")):
    git_mv(p, SIMULINK / p.name)

# 3. Documentation
for name in ("GUIDE_UTILISATION.md", "DECLARATION_IA.md"):
    git_mv(ROOT / name, DOCS / name)

# Le sujet du TP reste comme documentation.
for p in list(ROOT.glob("TP_*.pdf")):
    git_mv(p, DOCS / p.name)

# Si un rapport final existe déjà.
for name in ("rapport.pdf", "Rapport.pdf", "rapport_final.pdf", "Rapport_final.pdf"):
    if (ROOT / name).exists():
        git_mv(ROOT / name, DOCS / "rapport.pdf")
        break

# 4. Médias
for ext in ("*.png", "*.jpg", "*.jpeg", "*.svg"):
    for p in list(ROOT.glob(ext)):
        git_mv(p, FIGURES / p.name)

for ext in ("*.mp4", "*.mov", "*.avi", "*.webm", "*.gif"):
    for p in list(ROOT.glob(ext)):
        git_mv(p, VIDEOS / p.name)

# 5. Nettoyage des caches MATLAB/Simulink
for pattern in ("*.slxc", "*.autosave", "*.asv", "*.m~", "*.bak"):
    for p in ROOT.rglob(pattern):
        if ".git" not in p.parts and p.is_file():
            p.unlink()
            print("Supprimé :", p.relative_to(ROOT))

for name in ("slprj", "codegen"):
    for p in ROOT.rglob(name):
        if ".git" not in p.parts and p.is_dir():
            shutil.rmtree(p)
            print("Supprimé :", p.relative_to(ROOT))

# 6. Garder les dossiers assets dans Git même s'ils sont vides
for d in (FIGURES, VIDEOS):
    keep = d / ".gitkeep"
    if not any(x for x in d.iterdir() if x.name != ".gitkeep"):
        keep.touch()

# 7. Vérification minimale des dépendances attendues
required_m = [
    "app_tp_arborescence.m",
    "parametres_perso.m",
    "partie2_source.m",
    "partie3_cbs.m",
    "partie3_detecteur_optimal.m",
    "partie4_hamming_performances.m",
    "run_partie5_simulations.m",
    "run_partie6_simulations.m",
]
required_slx = [
    "Codage_source.slx",
    "Partie3_CBS.slx",
    "Partie3_Detecteur.slx",
    "Partie4_Hamming.slx",
    "Partie4_Registre.slx",
    "Partie5_QPSK.slx",
    "Partie5_QPSK_naturel.slx",
    "Partie5_QPSK_Hamming.slx",
    "Partie6_RRC.slx",
]

missing = [f"matlab/{x}" for x in required_m if not (MATLAB/x).exists()]
missing += [f"simulink/{x}" for x in required_slx if not (SIMULINK/x).exists()]

if missing:
    print("\nATTENTION - fichiers attendus absents :")
    for x in missing:
        print(" -", x)
    sys.exit(1)

print("\nStructure vérifiée : OK")

# 8. Commit Git
subprocess.run(["git", "add", "-A"], cwd=ROOT, check=True)
status = subprocess.run(
    ["git", "diff", "--cached", "--quiet"], cwd=ROOT
).returncode

if status == 0:
    print("Aucun changement à committer.")
else:
    subprocess.run(
        ["git", "commit", "-m", "chore: reorganise MATLAB Simulink project structure"],
        cwd=ROOT, check=True
    )
    print("\nCommit de réorganisation créé.")

print("\nEnsuite : git push origin main")
