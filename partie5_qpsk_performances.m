%% PARTIE 5 - Performances QPSK Matlab
close all;
run('partie5_parametres.m');

Qfun = @(x) 0.5*erfc(x/sqrt(2));

EbN0_dB_vec = 0:9;
gamma = 10.^(EbN0_dB_vec/10);

Pb_gray = Qfun(sqrt(2*gamma));
Pb_naturel = 1.5*Pb_gray;

fprintf('Es = %.3f | Eb = %.3f\n',Es,Eb_qpsk);
fprintf('Tc = %.4f | Ts = %.4f\n',Tc,Ts);

figure('Name','P5 - Gray vs naturel (perf)');
semilogy(EbN0_dB_vec,Pb_gray,'-o','LineWidth',1.4); hold on;
semilogy(EbN0_dB_vec,Pb_naturel,'-s','LineWidth',1.4);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('TEB');
title('QPSK : Gray vs mapping naturel');
legend('Gray','Naturel - approximation haut SNR','Location','southwest');

fprintf('Q4 : QPSK Gray et BPSK ont le même TEB à E_b/N_0 égal.\n');
fprintf('Q6 : deux mots Hamming -> 14 bits -> 7 symboles QPSK, sans bourrage.\n');
