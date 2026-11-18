%% partie6_analyse_filtres.m - Q3 (h, h*h, IES) et Q4 (occupation spectrale)
% Calculs hors Simulink (les filtres sont ceux du modèle : rrc_perso / porte).
run('partie6_parametres.m');
alphas = [0.22 1.00];  if ~any(abs(alphas-alpha_perso)<1e-9), alphas(end+1) = alpha_perso; end

%% Q3 : h et h*h
figure('Name','P6 - Q3 h et h*h');
for k = 1:numel(alphas)
    h  = rrc_perso(alphas(k),L,span);  hh = conv(h,h);
    t  = (-(numel(h)-1)/2 : (numel(h)-1)/2)/L;          % en unités de T
    t2 = (-(numel(hh)-1)/2 : (numel(hh)-1)/2)/L;
    c  = (numel(hh)+1)/2;  idx = c + (L:L:(c-1)); idx = [idx, c-(L:L:(c-1))]; % multiples non nuls de T
    ies = max(abs(hh(idx)))/hh(c);
    fprintf('alpha=%.2f : max |h*h(nT)|/h*h(0) = %.2e (n<>0, troncature a %d symboles) ; max |h(nT)|/h(0) = %.2f\n', ...
        alphas(k),ies,span, max(abs(h(((numel(h)+1)/2)+(L:L:span*L/2)))/h((numel(h)+1)/2)));
    subplot(2,numel(alphas),k); plot(t,h,'LineWidth',1.2); grid on; hold on;
    plot((-span/2:span/2),h((numel(h)+1)/2 + (-span/2:span/2)*L),'ro');
    title(sprintf('h(t), \\alpha=%.2f',alphas(k))); xlabel('t/T');
    subplot(2,numel(alphas),numel(alphas)+k); plot(t2,hh,'LineWidth',1.2); grid on; hold on;
    plot((-span:span),hh(c+(-span:span)*L),'ro');
    title(sprintf('h*h, \\alpha=%.2f (o : multiples de T)',alphas(k))); xlabel('t/T');
end

%% Q4 : DSP du signal émis (QPSK aléatoire suréchantillonné x L, puis filtre d'émission)
rng(graine);  Nsym = 2e4;
a = ((1-2*randi([0 1],Nsym,1)) + 1j*(1-2*randi([0 1],Nsym,1)))/sqrt(2);
x = zeros(Nsym*L,1);  x(1:L:end) = a;
filtres = {'Porte', ones(1,L)/sqrt(L); 'RRC 0.22', rrc_perso(0.22,L,span); 'RRC 1', rrc_perso(1,L,span)};
figure('Name','P6 - Q4 DSP'); hold on;
for k = 1:size(filtres,1)
    y = filter(filtres{k,2},1,x);  [f,P] = psd_welch(y,2048);  P = P/max(P);
    plot(f*L,10*log10(P),'LineWidth',1.2);
    % bande a 99 % de puissance : demi-largeur B99 (en 1/Ts), comparée a (1+alpha)/2
    Pc = P(f>=0);  fc = f(f>=0)*L;  B99 = fc(find(cumsum(Pc)/sum(Pc)>=0.99,1));
    nom = filtres{k,1};  al = sscanf(nom,'RRC %f');
    if strcmp(nom,'Porte'), ref = NaN; else, ref = (1+al)/2; end
    fprintf('%-9s : B99%% = %.3f /Ts ; (1+alpha)/(2T) = %.3f /Ts\n',nom,B99,ref);
end
legend(filtres(:,1)); grid on; xlim([-3 3]); ylim([-80 5]);
xlabel('f T_s'); ylabel('DSP normalisée (dB)'); title('Occupation spectrale avant canal');

function [f,P] = psd_welch(x,nfft)
x = x(:); w = 0.5-0.5*cos(2*pi*(0:nfft-1)'/nfft); step = nfft/2;
nseg = floor((numel(x)-nfft)/step)+1;  P = zeros(nfft,1);
for s = 1:nseg, P = P + abs(fftshift(fft(x((s-1)*step+(1:nfft)).*w))).^2; end
P = P/nseg;  f = (-nfft/2:nfft/2-1)'/nfft;
end
