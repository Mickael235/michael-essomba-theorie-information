from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parent
ASSETS = ROOT / "assets"
FIG = ASSETS / "figures"
VID = ASSETS / "videos"
DOCS = ROOT / "docs"

for d in (FIG, VID, DOCS):
    d.mkdir(parents=True, exist_ok=True)

# Fichiers temporaires / caches MATLAB-Simulink
for pattern in ("*.slxc", "*.autosave", "*.asv", "*.m~", "*.bak"):
    for p in ROOT.glob(pattern):
        if p.is_file():
            p.unlink()
            print("Supprimé :", p.name)

for name in ("slprj", "codegen"):
    p = ROOT / name
    if p.is_dir():
        shutil.rmtree(p)
        print("Supprimé :", name)

# Anciennes versions de l'application
for name in (
    "app_tp_simple.m",
    "app_tp_extension.m",
    "app_tp_arborescence_v2.m",
    "app_tp_arborescence_corrige.m",
):
    p = ROOT / name
    if p.exists():
        p.unlink()
        print("Supprimé :", name)

# Fichiers générés localement
for name in (
    "arborescence.txt",
    "texte_5000.txt",
    "texte_5000.txt.gz",
    "Projet_guttenberg_Le Fantôme de lOpéra.txt.gz",
):
    p = ROOT / name
    if p.exists():
        p.unlink()
        print("Supprimé :", name)

# Ranger les médias déposés à la racine
for ext in ("*.png", "*.jpg", "*.jpeg", "*.svg"):
    for p in ROOT.glob(ext):
        dest = FIG / p.name
        if not dest.exists():
            shutil.move(str(p), str(dest))
            print("Figure déplacée :", p.name)

for ext in ("*.mp4", "*.mov", "*.avi", "*.webm", "*.gif"):
    for p in ROOT.glob(ext):
        dest = VID / p.name
        if not dest.exists():
            shutil.move(str(p), str(dest))
            print("Vidéo déplacée :", p.name)

print("\nNettoyage terminé.")
print("Les fichiers .m et .slx restent à la racine pour préserver les appels relatifs.")
print("Structure prête pour Git.")
