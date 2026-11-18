%% Paramètres - Partie 6 (mise en forme + filtre adapté)
% Même convention que la Partie 5 : Es = 1, Eb(QPSK non codée) = 1/2.
P = parametres_perso('Essomba Michael');

Tb = 1;                 % durée d'un bit (unité de référence)
Es = 1;  Eb = Es/2;     % énergie par symbole / par bit (QPSK non codée)
R  = 4/7;               % rendement Hamming(7,4)
p1 = 0.5;               % bits équiprobables (énoncé 3.10)

L          = P.L;       % échantillons par symbole
alpha_perso = P.alpha;  % roll-off personnel
span       = 10;        % troncature des filtres : N = span*L + 1

%% Cadencement (établi AVANT le modèle)
%  8 bits utiles -> 14 bits codés -> 7 symboles  : trame toutes les 8*Tb
Ts = 8*Tb/7;            % durée d'un symbole QPSK
Te = Ts/L;              % période d'échantillonnage du signal suréchantillonné
%  Pas fondamental = pgcd(Tb, Te) : Tb/Te = 7L/8 n'est pas toujours entier
%  (L=4 -> 3.5), donc Tf = Te/(8/pgcd(L,8)).
Tf = Te/(8/gcd(L,8));
assert(abs(Tb/Tf-round(Tb/Tf))<1e-9 && abs(Te/Tf-round(Te/Tf))<1e-9, ...
       'Tf n''est pas un sous-multiple commun de Tb et Te');

%% Aléas
graine       = P.graine;
graine_bruit = graine + 20;
Nbits        = 5e4;     % multiple de 8
EbN0_dB      = 5;

%% Variance du bruit par composante (I ou Q) et par échantillon
%  Filtres à énergie unité -> la variance en sortie du filtre adapté est
%  la même qu'à l'entrée : sigma^2 = N0/2.
var_A = @(dB) (Eb/10^(dB/10))/2;        % Eb/N0 rapporté au bit QPSK non codé
var_B = @(dB) (Eb/10^(dB/10))/2/R;      % Eb/N0 rapporté au bit utile (Hamming)
variance_bruit_p6 = var_B(EbN0_dB);

Q = @(x) 0.5*erfc(x/sqrt(2));
