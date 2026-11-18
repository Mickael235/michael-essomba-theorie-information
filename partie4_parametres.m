%% Paramètres communs - Partie 4
P = parametres_perso('Essomba Michael');

Tb = 1;
A = P.A;
L = P.L;
R = 4/7;

Tc = 4*Tb/7;
Te_code = Tc/L;
A_code = A;

graine = P.graine;
graine_bruit = graine + 2;

EbN0_dB = 5;
EbN0 = 10^(EbN0_dB/10);
Eb = A^2*Tb;
N0 = Eb/EbN0;

variance_bruit_code = N0/(2*Tc); 
variance_bruit_sym = N0/(2*Tb);

nErrMax = 100;
d_hamming = 1;
Tstop = 1e6;

Q = @(x) 0.5*erfc(x/sqrt(2));
