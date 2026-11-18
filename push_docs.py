from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parent

files = [
    "README.md",
    "docs/DECLARATION_IA.md",
    "docs/BIBLIOGRAPHIE.md",
    "docs/GUIDE_UTILISATION.md",
    "matlab/lancer_mini_application.m",
]

missing = [f for f in files if not (ROOT / f).exists()]
if missing:
    print("Fichiers manquants :")
    for f in missing:
        print(" -", f)
    raise SystemExit(1)

subprocess.run(["git", "add", *files], cwd=ROOT, check=True)

changed = subprocess.run(
    ["git", "diff", "--cached", "--quiet"],
    cwd=ROOT
).returncode != 0

if not changed:
    print("Aucun changement à committer.")
    raise SystemExit(0)

subprocess.run(
    ["git", "commit", "-m", "docs: complete usage guide bibliography and AI declaration"],
    cwd=ROOT,
    check=True
)

subprocess.run(["git", "push", "origin", "main"], cwd=ROOT, check=True)
print("Documentation poussée sur origin/main.")
