%% Paramètres - Partie 5 QPSK
P = parametres_perso('Essomba Michael');
p1 = P.p1;
Tb = 1;
A  = P.A;
L  = P.L;
R  = 4/7;

Es = 1;
Eb_qpsk = Es/2;

Tc = 4*Tb/7;
Ts = 8*Tb/7;

EbN0_dB = 5;
gamma = 10^(EbN0_dB/10);

% QPSK non codée : variance sur chacune des voies I et Q
N0 = Eb_qpsk/gamma;
variance_bruit_qpsk = N0/2;

graine = P.graine;
graine_bruit = graine + 20;

% Nombre de bits simulés par défaut
Nbits = 5e4;

% Compatibilité avec les anciens scripts
variance_IQ = variance_bruit_qpsk;
mapping_mode = 0;

Ts_q2 = 2*Tb;
T_bloc6 = 8*Tb;
Tstop = Nbits*Tb;

Q = @(x) 0.5*erfc(x/sqrt(2));
