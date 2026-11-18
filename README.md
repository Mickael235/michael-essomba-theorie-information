# Théorie de l'information et du codage — Michael Essomba

Projet MATLAB/Simulink réalisé à l'ENSIM autour de la **modélisation et simulation d'une chaîne de transmission numérique en bande de base**.

Le travail progresse du codage de source jusqu'à la modulation QPSK et au filtrage de mise en forme, avec validation théorique et simulation du taux d'erreur binaire (TEB).

## Structure du dépôt

```text
.
├── matlab/                  # Scripts, fonctions, tests et application MATLAB
│   ├── app_tp_arborescence.m
│   ├── parametres_perso.m
│   ├── partie2_*.m
│   ├── partie3_*.m
│   ├── partie4_*.m
│   ├── partie5_*.m
│   ├── partie6_*.m
│   ├── run_*.m
│   └── test_*.m
│
├── simulink/                # Modèles Simulink
│   ├── Codage_source.slx
│   ├── Partie3_CBS.slx
│   ├── Partie3_Detecteur.slx
│   ├── Partie4_Hamming.slx
│   ├── Partie4_Registre.slx
│   ├── Partie5_QPSK.slx
│   ├── Partie5_QPSK_naturel.slx
│   ├── Partie5_QPSK_Hamming.slx
│   └── Partie6_RRC.slx
│
├── docs/                    # Rapport, sujet, guide et déclaration IA
├── assets/
│   ├── figures/             # Figures utilisées dans le README / rapport
│   └── videos/              # Démonstration vidéo
│
├── Projet_guttenberg_Le Fantôme de lOpéra.txt
├── texte_fr.txt
├── resultats_partie6.mat
├── README.md
├── .gitignore
└── reorganize_repo.py
```

## Parties traitées

| Partie | Contenu |
|---|---|
| 2 | Codage de source : entropie, Huffman, mémoire, LZ78 |
| 3 | Chaîne de base : CBS, bruit uniforme, bruit gaussien, détecteur optimal |
| 4 | Codage canal : Hamming C(7,4), syndrome, registre, performances |
| 5 | Modulation QPSK : Gray, mapping naturel, QPSK + Hamming |
| 6 | Mise en forme : porte, RRC, Nyquist, DSP, œil et sensibilité temporelle |
| 7 | Complément : canal à deux trajets |

## Application interactive

L'application permet de parcourir les différentes parties du TP, d'exécuter les scripts associés, d'afficher les figures, de consulter une interprétation, de lancer les tests demandés et d'ouvrir les modèles Simulink.

Depuis la racine du dépôt :

```matlab
addpath(genpath('matlab'));
app_tp_arborescence
```

L'application ajoute automatiquement les dossiers `matlab/` et `simulink/` au chemin MATLAB et conserve la racine du dépôt comme dossier de travail pour les fichiers de données.

## Paramètres personnels

Les simulations utilisent les paramètres personnels définis dans :

```text
matlab/parametres_perso.m
```

Les tirages aléatoires utilisent une graine fixe afin de conserver des résultats reproductibles.

## Résultats

Quelques résultats principaux obtenus :

- validation sans bruit des chaînes Simulink ;
- comparaison théorie / simulation du TEB ;
- correction d'une erreur simple avec Hamming C(7,4) ;
- comparaison QPSK Gray / naturel ;
- analyse du filtre RRC et du critère de Nyquist.

### Exemple — performances Hamming

Lorsque l'image est ajoutée :

```markdown
![Performances Hamming](assets/figures/p4_hamming_performances.png)
```

Une fois l'image exportée dans `assets/figures/`, ajouter :

```markdown
![Performances Hamming](assets/figures/p4_hamming_performances.png)
```

### Exemple — QPSK

```markdown
![Performances QPSK](assets/figures/p5_qpsk_performances.png)
```

## Vidéo de présentation

La vidéo de démonstration peut être déposée dans :

```text
assets/videos/
```

Puis référencée ici :

```markdown
[Voir la démonstration](assets/videos/demo_tp.mp4)
```

## Documentation

- [Guide d'utilisation](docs/GUIDE_UTILISATION.md)
- [Déclaration d'utilisation de l'IA](docs/DECLARATION_IA.md)
- Sujet du TP : `docs/TP_2026-2027_Simulink-2.pdf`
- Rapport final : `docs/rapport.pdf` une fois ajouté

## Réorganisation du dépôt

Le script :

```bash
python reorganize_repo.py
```

crée les dossiers, déplace les fichiers avec `git mv`, nettoie les caches MATLAB/Simulink, vérifie les fichiers essentiels et crée automatiquement le commit :

```text
chore: reorganise MATLAB Simulink project structure
```

Il ne reste ensuite qu'à pousser :

```bash
git push origin main
```

## Déclaration IA

L'utilisation d'outils d'intelligence artificielle est décrite explicitement dans [`docs/DECLARATION_IA.md`](docs/DECLARATION_IA.md).
