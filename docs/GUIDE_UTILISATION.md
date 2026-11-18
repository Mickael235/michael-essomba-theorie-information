# Guide d'utilisation

## 1. Prérequis

Le projet nécessite :

- MATLAB ;
- Simulink ;
- les toolboxes utilisées par les modèles et scripts du TP, notamment DSP System Toolbox / Communications Toolbox selon l'installation.

## 2. Organisation du dépôt

```text
matlab/       scripts, fonctions, tests et applications
simulink/     modèles Simulink
docs/         sujet du TP, guide, bibliographie et déclaration IA
assets/       figures et vidéos
```

Les fichiers de données utilisés par certains scripts restent à la racine du dépôt.

## 3. Application graphique principale

Depuis la racine du dépôt, exécuter dans MATLAB :

```matlab
addpath(genpath('matlab'));
app_tp_arborescence
```

L'application se replace automatiquement à la racine du dépôt et ajoute les dossiers `matlab/` et `simulink/` au chemin MATLAB.

### Fonctionnement

L'interface suit les parties du TP :

- Partie 2 : codage de source ;
- Partie 3 : chaîne de base et détection ;
- Partie 4 : codage Hamming ;
- Partie 5 : modulation QPSK ;
- Partie 6 : mise en forme et filtre RRC ;
- Partie 7 : complément sur le canal à deux trajets.

Pour chaque étape, l'application indique les fichiers associés et permet, selon la question :

- d'exécuter le ou les scripts MATLAB ;
- d'afficher les figures produites directement dans l'interface ;
- de consulter l'interprétation correspondante ;
- de lancer un test de validation ;
- d'ouvrir le modèle Simulink concerné.

Un indicateur d'état signale si l'exécution est en cours, terminée ou en erreur.

## 4. Mini-application en ligne de commande

Une seconde interface plus simple est disponible :

```matlab
addpath(genpath('matlab'));
mini_application_tp
```

Elle permet de lancer les scripts, tests, modèles Simulink et simulations principales à partir d'un menu dans la console MATLAB.

Elle est utile pour :

- vérifier rapidement une partie ;
- relancer tous les tests ;
- relancer les simulations principales sans utiliser l'interface graphique.

## 5. Paramètres personnels

Les paramètres personnels sont définis dans :

```text
matlab/parametres_perso.m
```

Les scripts concernés chargent ces valeurs avant les simulations.

## 6. Modèles Simulink

Les modèles se trouvent dans `simulink/`.

Exemples :

```text
Codage_source.slx
Partie3_CBS.slx
Partie3_Detecteur.slx
Partie4_Hamming.slx
Partie4_Registre.slx
Partie5_QPSK.slx
Partie5_QPSK_naturel.slx
Partie5_QPSK_Hamming.slx
Partie6_RRC.slx
```

## 7. Tests

Les principaux tests sont regroupés dans les fichiers :

```text
test_huffman.m
test_lz78m.m
test_hamming74.m
test_partie6_rrc.m
run_partie4_registre.m
```

La mini-application permet de les lancer depuis l'option **Tests rapides du TP**.

## 8. Figures et vidéos

Les médias destinés au README ou au rapport sont stockés dans :

```text
assets/figures/
assets/videos/
```

Exemple d'utilisation dans le README :

```markdown
![Performances Hamming](assets/figures/p4_hamming_performances.png)
```
