%% PARTIE 4 - Hamming C(7,4) : théorie et validation (Q1 à Q9)
run('partie4_parametres.m');

%% Q1 - Matrices G et H
Pmat = [1 1 0; 0 1 1; 1 1 1; 1 0 1];
G = [eye(4) Pmat];
H = [Pmat' eye(3)];

fprintf('G*H'' mod 2 =\n');
disp(mod(G*H',2));

%% Q2 - Distance minimale
messages = dec2bin(0:15,4)-'0';
codewords = mod(messages*G,2);
poids = sum(codewords,2);
dmin = min(poids(poids>0));

fprintf('dmin = %d | correction = %d | détection = %d\n', ...
    dmin,floor((dmin-1)/2),dmin-1);

%% Q3 - Validation Matlab du codeur/décodeur
run('test_hamming74.m');

%% Q7 - Probabilité d'un bloc juste
p = linspace(0,0.5,500);
Pjuste_sans = (1-p).^4;
Pjuste_hamming = (1-p).^7 + 7*p.*(1-p).^6;



%% Q8 - Approximation demandée dans l'énoncé
Pb_approx = zeros(size(p));
for j=2:7
    Pb_approx = Pb_approx + (j/7)*nchoosek(7,j).*p.^j.*(1-p).^(7-j);
end



%% Q9 - Lien avec Eb/N0
EbN0_dB_vec = 0:9;
gamma = 10.^(EbN0_dB_vec/10);

Pb_sans = Q(sqrt(2*gamma));
p_code = Q(sqrt(2*R*gamma));
Pb_hamming = zeros(size(gamma));

for j=2:7
    Pb_hamming = Pb_hamming + ...
        (j/7)*nchoosek(7,j).*p_code.^j.*(1-p_code).^(7-j);
end

figure('Name','P4 - Hamming théorie');
semilogy(EbN0_dB_vec,Pb_sans,'LineWidth',1.4); hold on;
semilogy(EbN0_dB_vec,Pb_hamming,'o-','LineWidth',1.4);
grid on;
xlabel('E_b/N_0 (dB)'); ylabel('TEB');
title('Performances théoriques du code Hamming C(7,4)');
legend('Sans codage','Hamming - approximation Q8','Location','southwest');
