%% PARTIE 3.1 - Canal binaire symétrique (Q1 à Q3)
run('partie3_parametres.m');

sim('Partie3_CBS');

N = min(length(bits_emis),length(bits_recus));
erreurs = sum(bits_emis(1:N) ~= bits_recus(1:N));
TEB = erreurs/N;
IC = 1.96*sqrt(TEB*(1-TEB)/N);

fprintf('TEB simulé : %.6f\n',TEB);
fprintf('pe théorique : %.6f\n',pe);
fprintf('IC 95 %% : [%.6f ; %.6f]\n',TEB-IC,TEB+IC);

Hpe = -pe*log2(pe) - (1-pe)*log2(1-pe);
C = 1-Hpe;
R = 4/7;

fprintf('Capacité CBS : %.4f bit/usage\n',C);
fprintf('R=4/7 < C : %d\n',R<C);

pe_vec = linspace(0.001,0.5,500);
H_vec = -pe_vec.*log2(pe_vec) -(1-pe_vec).*log2(1-pe_vec);
C_vec = 1-H_vec;

figure('Name','P3 - Capacité CBS');plot(pe_vec,C_vec,'LineWidth',1.5); hold on;
yline(R,'--');
plot(pe,C,'o','LineWidth',1.5);
grid on;
xlabel('p_e'); ylabel('Capacité C');
title('Capacité du canal binaire symétrique');
legend('C(p_e)','R=4/7','Paramètre personnel','Location','best');
