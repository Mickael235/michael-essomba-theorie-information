# Théorie de l'information et du codage — Michael Essomba

Projet MATLAB/Simulink réalisé à l'ENSIM autour de la **modélisation et de la simulation d'une chaîne de transmission numérique en bande de base**.

Le projet parcourt le codage de source, les canaux bruités, la détection optimale, le codage de Hamming, la modulation QPSK et la mise en forme RRC. Les résultats sont comparés aux expressions théoriques et validés par simulation.

## Structure du dépôt

```text
.
├── matlab/
│   ├── app_tp_arborescence.m
│   ├── mini_application_tp.m
│   ├── lancer_mini_application.m
│   ├── parametres_perso.m
│   ├── partie2_*.m
│   ├── partie3_*.m
│   ├── partie4_*.m
│   ├── partie5_*.m
│   ├── partie6_*.m
│   ├── run_*.m
│   └── test_*.m
│
├── simulink/
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
├── docs/
│   ├── GUIDE_UTILISATION.md
│   ├── BIBLIOGRAPHIE.md
│   ├── DECLARATION_IA.md
│   └── TP_2026-2027_Simulink-2.pdf
│
├── assets/
│   ├── figures/
│   └── videos/
│
├── Projet_guttenberg_Le Fantôme de lOpéra.txt
├── texte_fr.txt
├── resultats_partie6.mat
└── README.md
```

## Parties traitées

| Partie | Contenu |
|---|---|
| 2 | Codage de source : entropie, Huffman, mémoire et LZ78 |
| 3 | Chaîne de base : CBS, bruit uniforme, bruit gaussien et détecteur optimal |
| 4 | Codage canal : Hamming C(7,4), syndrome, registre et performances |
| 5 | Modulation QPSK : Gray, mapping naturel et QPSK + Hamming |
| 6 | Mise en forme : porte, RRC, Nyquist, DSP, œil et sensibilité temporelle |
| 7 | Complément : canal à deux trajets |

## Application graphique principale

Depuis la racine du dépôt :

```matlab
addpath(genpath('matlab'));
app_tp_arborescence
```

L'application permet de parcourir les différentes parties du TP et, selon la question :

- d'exécuter le ou les scripts MATLAB associés ;
- d'afficher les figures obtenues ;
- de lire l'interprétation des résultats ;
- de lancer les tests de validation ;
- d'ouvrir le modèle Simulink correspondant.

## Mini-application

Une version en ligne de commande permet de lancer rapidement les scripts, tests et simulations principales :

```matlab
addpath(genpath('matlab'));
lancer_mini_application
```

## Paramètres personnels

Les paramètres utilisés pour les simulations sont centralisés dans :

```text
matlab/parametres_perso.m
```

Les scripts utilisent ces paramètres afin de conserver le scénario personnel demandé dans le TP.

## Résultats principaux

Le projet permet notamment de vérifier :

- la convergence du codage de source vers l'entropie ;
- la compatibilité entre TEB simulé et expressions théoriques ;
- l'intérêt du détecteur optimal ;
- la correction d'une erreur simple par Hamming C(7,4) ;
- le compromis redondance / gain de codage ;
- l'équivalence TEB entre QPSK Gray et BPSK à même `E_b/N_0` ;
- l'influence du roll-off RRC sur la bande et la sensibilité temporelle.

## Figures et vidéo

Les figures destinées au rapport et au README sont placées dans :

```text
assets/figures/
```

Exemple :

```markdown
![Performances Hamming](assets/figures/p4_hamming_performances.png)
```

Les vidéos de démonstration sont placées dans :

```text
assets/videos/
```

## Documentation

- [Guide d'utilisation](docs/GUIDE_UTILISATION.md)
- [Bibliographie et ressources techniques](docs/BIBLIOGRAPHIE.md)
- [Déclaration d'utilisation de l'IA](docs/DECLARATION_IA.md)
- [Sujet du TP](docs/TP_2026-2027_Simulink-2.pdf)

## Nettoyage MATLAB / Simulink

Les caches et fichiers temporaires (`*.slxc`, `slprj/`, autosauvegardes) ne sont pas nécessaires au dépôt Git et sont exclus via `.gitignore`.
