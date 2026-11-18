function P = parametres_perso(nom)
%PARAMETRES_PERSO Paramètres personnels reproductibles du TP.

n = upper(strtrim(nom));
c = double(n);
graine = mod(sum(c .* (1:numel(c)) * 31) + 7*numel(c), 2^31 - 1);

s = RandStream('mt19937ar','Seed',graine);
u = @(a,b) a + (b-a)*rand(s);

P.nom           = n;
P.p1            = round(u(0.15,0.40)*100)/100;
P.pe_cbs        = round(u(0.02,0.15)*1000)/1000;
P.A             = 1;
P.a_unif        = round(u(1.2,2.0)*100)/100;
P.sigma         = round(u(0.5,0.9)*100)/100;

Ls = [4 8 16];
P.L = Ls(randi(s,3));

alphas = [0.22 0.25 0.35];
P.alpha = alphas(randi(s,3));

P.beta          = round(u(0.2,0.5)*100)/100;
P.retard_trajet = randi(s,2);
P.graine        = mod(graine,1e6);
P.p1_ext        = round(u(0.05,0.15)*100)/100;
end
