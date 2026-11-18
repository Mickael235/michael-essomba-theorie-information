%% Paramètres communs - Partie 3
P = parametres_perso('Essomba Michael');

Tb = 1;
A = P.A;
L = P.L;
Te = Tb/L;

p1 = P.p1;
p0 = 1-p1;
pe = P.pe_cbs;

a_unif = P.a_unif;
sigma = P.sigma;

graine = P.graine;
graine_bruit = graine + 2;

Q = @(x) 0.5*erfc(x/sqrt(2));
