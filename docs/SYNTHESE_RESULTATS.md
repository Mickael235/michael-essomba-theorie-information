# Synthèse des résultats

Ce document rassemble les principaux enseignements du TP de théorie de l'information et du codage. Il complète les scripts MATLAB, les modèles Simulink et les figures exportées dans `assets/figures/`.

## 1. Codage de source

L'objectif du codage de source est de réduire la redondance du message avant transmission.

### Entropie

L'entropie mesure la quantité moyenne d'information produite par une source. Elle est maximale pour une source binaire équiprobable et diminue lorsque la distribution devient déséquilibrée.

La comparaison entre entropie, code fixe et code de Huffman permet de vérifier qu'un code statistique adapté à la distribution des symboles réduit la longueur moyenne du message.

### Huffman

Le code de Huffman attribue les mots les plus courts aux symboles les plus fréquents. Les validations réalisées dans le projet portent notamment sur :

- la propriété de préfixe ;
- l'inégalité de Kraft ;
- la relation `H <= L < H + 1` ;
- le décodage exact du texte.

Le coût de la table de codage devient négligeable lorsque le texte est suffisamment long.

### Extension de source

L'extension de source consiste à coder des blocs de plusieurs symboles. La longueur moyenne par symbole se rapproche alors davantage de l'entropie.

L'inconvénient principal est la croissance rapide de l'alphabet : pour une source binaire et des blocs de taille `k`, l'alphabet contient `2^k` symboles possibles.

### Mémoire de la source et LZ78

La comparaison entre entropie d'ordre 0, entropie sur les paires, Huffman et gzip met en évidence la présence de mémoire dans un texte réel.

LZ78 exploite cette structure sans nécessiter de probabilités connues à l'avance. Ses performances sont moins intéressantes sur les messages courts car le dictionnaire doit d'abord se construire.

---

## 2. Chaîne de base et détection optimale

La partie 3 compare différents modèles de bruit et montre l'intérêt du détecteur optimal.

### Canal binaire symétrique

Dans un CBS, chaque bit est inversé avec une probabilité donnée. Le TEB simulé doit donc rester cohérent avec cette probabilité.

La capacité du canal diminue quand la probabilité d'erreur augmente et devient nulle pour un canal complètement ambigu.

### Bruit uniforme et bruit gaussien

Le bruit uniforme possède un support borné. Lorsque les distributions associées aux deux symboles ne se recouvrent pas, une décision sans erreur peut être possible.

Le bruit gaussien possède au contraire un support non borné. Les distributions se recouvrent toujours, ce qui impose une probabilité d'erreur non nulle pour un rapport signal sur bruit fini.

### Détecteur optimal

L'intégration sur toute la durée du bit permet d'exploiter l'énergie disponible du signal.

Les simulations montrent que le TEB obtenu avec intégration est nettement meilleur que celui obtenu avec un seul échantillon. La courbe simulée suit la tendance de la relation théorique associée au bruit gaussien.

---

## 3. Codage de canal Hamming C(7,4)

Le code Hamming C(7,4) ajoute trois bits de redondance à quatre bits d'information.

### Correction d'erreur

La distance minimale vaut 3. Le code peut donc corriger une erreur simple par mot.

Le syndrome permet de localiser la position d'une erreur. La validation a été réalisée à la fois avec une implémentation matricielle et avec le registre Simulink.

### Performances

Les simulations montrent que le codage n'est pas toujours avantageux à faible `E_b/N_0`, car l'énergie disponible est répartie sur davantage de bits transmis.

Lorsque le rapport `E_b/N_0` devient suffisamment élevé, la correction d'erreur améliore le TEB.

Dans les simulations réalisées, le croisement entre la chaîne codée et non codée apparaît autour de 5,85 dB. Le gain de codage mesuré autour d'un TEB de `10^-4` est d'environ 0,31 dB.

### Coût du codage

Le rendement du code vaut :

```text
R = 4/7
```

Pour conserver le même débit utile, le débit transmis sur le canal doit être multiplié par `7/4`, soit une augmentation de 75 %.

Le traitement par blocs introduit également une latence supplémentaire.

---

## 4. Modulation QPSK

La QPSK transporte deux bits par symbole.

### Mapping Gray

Le mapping Gray fait en sorte que deux symboles voisins ne diffèrent que d'un seul bit.

Cette propriété limite le nombre d'erreurs binaires lorsqu'une mauvaise décision conduit vers un symbole adjacent.

### Performances

À même `E_b/N_0`, la QPSK Gray conserve un comportement de TEB cohérent avec deux voies BPSK indépendantes en phase et en quadrature.

Le mapping naturel est moins favorable car certaines erreurs de symbole peuvent produire plusieurs erreurs binaires.

### QPSK et Hamming

La combinaison QPSK + Hamming permet de réunir efficacité spectrale et correction d'erreur.

Deux mots Hamming représentent 14 bits, soit exactement 7 symboles QPSK. Aucun bourrage n'est donc nécessaire dans cette configuration.

---

## 5. Mise en forme et filtre RRC

La mise en forme contrôle la bande occupée et limite l'interférence entre symboles.

### Critère de Nyquist

Le filtre RRC seul ne possède pas directement toutes les propriétés de Nyquist aux instants symboles. La cascade du filtre d'émission et du filtre adapté de réception forme un cosinus surélevé.

La réponse globale présente alors des valeurs proches de zéro aux multiples de la période symbole, en dehors de l'instant de décision.

### Roll-off

Le paramètre `alpha` fixe un compromis :

- faible `alpha` : bande occupée plus faible ;
- grand `alpha` : bande plus large mais meilleure tolérance temporelle.

Les simulations montrent qu'un décalage de l'instant d'échantillonnage dégrade le diagramme de l'œil et augmente le TEB.

---

## 6. Canal à deux trajets

Le canal est modélisé sous la forme :

```text
h_c(t) = delta(t) + beta delta(t - tau)
```

Le second trajet ajoute une copie retardée du signal reçu.

### Interférence entre symboles

Lorsque le retard est comparable à la durée symbole, la copie retardée se superpose aux symboles suivants.

Les conséquences principales sont :

- fermeture du diagramme de l'œil ;
- augmentation de l'interférence entre symboles ;
- dégradation du TEB ;
- violation du critère de Nyquist pour la chaîne globale.

### Égalisation

Une égalisation peut compenser la réponse du canal.

Deux approches classiques sont :

- **Zero-Forcing** : cherche à inverser le canal, au risque d'amplifier le bruit ;
- **MMSE** : réalise un compromis entre suppression de l'IES et amplification du bruit.

Les paramètres du canal, notamment `beta` et `tau`, doivent être connus ou estimés.

---

## 7. Limites de Shannon

La capacité de Shannon donne une limite théorique fondamentale.

Elle ne décrit pas directement un codeur ou une modulation particulière. Elle indique plutôt si une transmission fiable peut théoriquement être obtenue pour un débit donné et un niveau de bruit donné.

Les résultats du TP restent naturellement au-dessus des limites idéales de Shannon car les schémas étudiés utilisent des codes, détecteurs et modulations de complexité finie.

---

## 8. Bilan global

Le TP met en évidence plusieurs compromis fondamentaux :

| Bloc | Apport principal | Coût / limite |
|---|---|---|
| Codage de source | Réduction de redondance | Complexité de codage |
| Détecteur optimal | Réduction du TEB | Synchronisation nécessaire |
| Hamming C(7,4) | Correction d'erreurs | +75 % de débit canal |
| QPSK | Deux bits par symbole | Sensibilité aux erreurs de phase / décision |
| RRC | Contrôle de bande et de l'IES | Compromis bande / synchronisation |
| Égalisation | Compensation d'un canal dispersif | Complexité et amplification possible du bruit |

La chaîne complète ne repose donc pas sur un seul bloc. La qualité finale dépend de la combinaison entre compression, détection, codage correcteur, modulation, mise en forme et adaptation au canal.

Les figures exportées dans `assets/figures/` permettent d'illustrer directement ces différentes étapes dans le README ou le rapport.
