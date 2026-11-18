%% PARTIE 5 - QPSK : référence Matlab (Q1, Q3, Q4, Q5)

P = parametres_perso('Essomba Michael');
rng(P.graine);

Qfun = @(x) 0.5*erfc(x/sqrt(2));

%% Q1 - Mapping Gray, Es=1 donc Eb=Es/2
bits_ref = [0 0; 0 1; 1 1; 1 0];
I = (1-2*bits_ref(:,1))/sqrt(2);
Q = (1-2*bits_ref(:,2))/sqrt(2);
s_ref = I + 1j*Q;

Es = mean(abs(s_ref).^2);
Eb = Es/2;

fprintf('Es = %.3f | Eb = %.3f\n',Es,Eb);

figure('Name','P5 - Constellation Gray');
plot(real(s_ref),imag(s_ref),'o','MarkerSize',9); hold on;
labels = {'00','01','11','10'};
for k=1:4
    text(real(s_ref(k))+0.05,imag(s_ref(k))+0.05,labels{k});
end
grid on; axis equal;
xlim([-1 1]); ylim([-1 1]);
xlabel('I'); ylabel('Q');
title('Constellation QPSK Gray');

%% Q3 - Constellations reçues
Nsym = 5000;
bits = randi([0 1],2*Nsym,1);
b = reshape(bits,2,[])';

I = (1-2*b(:,1))/sqrt(2);
Qv = (1-2*b(:,2))/sqrt(2);
s = I + 1j*Qv;

for EbN0_dB = [0 5 10]
    gamma = 10^(EbN0_dB/10);
    N0 = Eb/gamma;
    sigma = sqrt(N0/2);

    r = s + sigma*(randn(Nsym,1)+1j*randn(Nsym,1));

    figure('Name','P5 - Constellation bruitée');
    plot(real(r(1:1500)),imag(r(1:1500)),'.');
    grid on; axis equal;
    xlim([-2 2]); ylim([-2 2]);
    xlabel('I'); ylabel('Q');
    title(sprintf('QPSK Gray - E_b/N_0 = %d dB',EbN0_dB));

end

%% Q4-Q5 - TEB Gray et mapping naturel
EbN0_dB = 0:9;
gamma = 10.^(EbN0_dB/10);

Pb_gray = Qfun(sqrt(2*gamma));
Pb_naturel_approx = 1.5*Pb_gray;

figure('Name','P5 - Gray vs naturel (théorie)');
semilogy(EbN0_dB,Pb_gray,'-o','LineWidth',1.4); hold on;
semilogy(EbN0_dB,Pb_naturel_approx,'-s','LineWidth',1.4);
grid on;
xlabel('E_b/N_0 (dB)');
ylabel('TEB');
title('QPSK : Gray vs mapping naturel');
legend('Gray','Naturel - approximation haut SNR','Location','southwest');

fprintf('Q4 : QPSK Gray et BPSK ont le même TEB à E_b/N_0 égal.\n');
fprintf('À durée symbole égale, la QPSK transporte 2 bits/symbole.\n');
