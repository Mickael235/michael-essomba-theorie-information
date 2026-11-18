%% PARTIE 2.1 - Source binaire et entropie

P = parametres_perso('Essomba Michael');
N = 1e5;
rng(P.graine);

bits = source(N,P.p1);
freq1 = mean(bits);
p0 = 1-P.p1;
H = -P.p1*log2(P.p1) - p0*log2(p0);

fprintf('P(1) théorique : %.4f\n',P.p1);
fprintf('Fréquence des 1 : %.4f\n',freq1);
fprintf('Entropie         : %.4f bit/symbole\n',H);
fprintf('Débit info       : %.4f bit/s\n',H);

p = linspace(0.001,0.999,1000);
Hp = -p.*log2(p) - (1-p).*log2(1-p);

figure('Name','P2 - Entropie binaire');plot(p,Hp,'LineWidth',1.5); hold on;
plot(P.p1,H,'o','LineWidth',1.5);
grid on;
xlabel('p=P(1)');
ylabel('H(p) [bits/symbole]');
title('Entropie d''une source binaire');
legend('H(p)','Paramètre personnel','Location','best');
