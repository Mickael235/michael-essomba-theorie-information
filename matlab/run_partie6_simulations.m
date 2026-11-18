%% run_partie6_simulations.m - Partie 6 : TEB, constellations, oeil, decalage T/4
% Un seul modèle (Partie6_RRC) :
%  - chaîne A (QPSK non codée) = erreurs sur les 14 bits codés (trames_cod/trames_dem)
%    avec variance_bruit = (Eb/gamma)/2
%  - chaîne B (Hamming)        = erreurs sur les 8 bits utiles (trames_info/trames_dec)
%    avec variance_bruit = (Eb/gamma)/2/R   (Eb/N0 rapporté au bit utile)
 bdclose all;
run('partie6_parametres.m');
partie6_config('porte',0,0);
if ~exist('Partie6_RRC.slx','file'), build_Partie6_RRC; end
mdl = 'Partie6_RRC';  load_system(mdl);

EbN0_vec = 0:2:8;   Nbits_teb = 6e4;   Nbits_plot = 4e3;
T4 = round(L/4);
cfg = { 'Porte',            'porte', 0,      0;
        'RRC alpha=0.22',   'rrc',   0.22,   0;
        'RRC 0.22, T/4',    'rrc',   0.22,   T4;
        'RRC alpha=1',      'rrc',   1.00,   0;
        'RRC 1, T/4',       'rrc',   1.00,   T4 };
nc = size(cfg,1);  ns = numel(EbN0_vec);
tebA = nan(nc,ns);  tebB = nan(nc,ns);

%% TEB
Nbits = Nbits_teb;
for c = 1:nc
    partie6_config(cfg{c,2},cfg{c,4},cfg{c,3});
    for i = 1:ns
        variance_bruit_p6 = var_A(EbN0_vec(i));              % chaîne A
        out = sim(mdl);
        tebA(c,i) = teb_trames(en_trames(out.get('trames_cod'),14), ...
                               en_trames(out.get('trames_dem'),14), lag_trames);
        variance_bruit_p6 = var_B(EbN0_vec(i));              % chaîne B
        out = sim(mdl);
        tebB(c,i) = teb_trames(en_trames(out.get('trames_info'),8), ...
                               en_trames(out.get('trames_dec'), 8), lag_trames);
        fprintf('%-16s %d dB | A %.4e | B %.4e\n',cfg{c,1},EbN0_vec(i),tebA(c,i),tebB(c,i));
    end
end
save('resultats_partie6.mat','EbN0_vec','cfg','tebA','tebB','L','alpha_perso');
th = Q(sqrt(2*10.^(EbN0_vec/10)));

figure('Name','P6 - Q1/Q5 TEB');
semilogy(EbN0_vec,th,'k-',EbN0_vec,nz(tebA(1,:)),'o-',EbN0_vec,nz(tebA(2,:)),'s-', ...
         EbN0_vec,nz(tebB(2,:)),'d-','LineWidth',1.3); grid on;
xlabel('E_b/N_0 (dB)'); ylabel('TEB'); title('TEB : porte, RRC \alpha=0.22 et RRC + Hamming');
legend('Théorie QPSK','Porte (A)','RRC 0.22 (A)','RRC 0.22 + Hamming (B)','Location','southwest');

figure('Name','P6 - Q6 alpha 0.22 vs 1, optimal vs T/4');
for k = 1:2
    subplot(1,2,k); T = {tebA,tebB}; Tt = T{k};
    semilogy(EbN0_vec,th,'k-',EbN0_vec,nz(Tt(2,:)),'o-',EbN0_vec,nz(Tt(3,:)),'o--', ...
             EbN0_vec,nz(Tt(4,:)),'s-',EbN0_vec,nz(Tt(5,:)),'s--','LineWidth',1.3); grid on;
    xlabel('E_b/N_0 (dB)'); ylabel('TEB');
    tt = {'Chaîne A (QPSK)','Chaîne B (Hamming)'}; title(tt{k});
    legend('Théorie QPSK','\alpha=0.22 opt.','\alpha=0.22 T/4','\alpha=1 opt.','\alpha=1 T/4','Location','southwest');
end

%% Constellations (alpha=0.22 et 1 ; optimal / T/4 ; 10 dB et sans bruit)
Nbits = Nbits_plot;  figure('Name','P6 - Constellations');
cas = {0.22,0,10; 0.22,T4,10; 0.22,T4,Inf; 1.00,0,10; 1.00,T4,10; 1.00,T4,Inf};
for k = 1:size(cas,1)
    partie6_config('rrc',cas{k,2},cas{k,1});
    if isinf(cas{k,3}), variance_bruit_p6 = 0; else, variance_bruit_p6 = var_A(cas{k,3}); end
    out = sim(mdl);
    r = en_trames(out.get('symboles_rx'),7);  r = reshape(r.',[],1);
    r = r(Q_symboles+8:end);                              % transitoire exclu
    subplot(2,3,k); plot(real(r),imag(r),'.'); axis equal; grid on;
    xlim([-1.6 1.6]); ylim([-1.6 1.6]); xlabel('I'); ylabel('Q');
    title(sprintf('\\alpha=%.2f, %s, %s',cas{k,1},ifelse(cas{k,2}==0,'optimal','T/4'), ...
          ifelse(isinf(cas{k,3}),'sans bruit','10 dB')));
end

%% Diagrammes de l'oeil (sans bruit) : instant optimal = trait vert, T/4 = trait rouge
figure('Name','P6 - Oeil'); variance_bruit_p6 = 0;
for k = 1:2
    a = [0.22 1.00];  partie6_config('rrc',0,a(k));
    out = sim(mdl);  sig = real(squeeze(out.get('signal_rx')));  sig = sig(:);
    subplot(1,2,k); hold on;
    N = span*L+1;  t = (-L:L)/L;
    for m = span+3 : floor((numel(sig)-N-L)/L)-3
        i0 = m*L + (N-1);                                 % instant optimal (base 0)
        plot(t, sig(i0-L+1:i0+L+1),'b');
    end
    xline(0,'g-','LineWidth',1.5); xline(T4/L,'r--','LineWidth',1.5);
    grid on; xlim([-1 1]); xlabel('t/T_s'); ylabel('amplitude (I)');
    title(sprintf('Oeil RRC \\alpha=%.2f',a(k)));
end
close_system(mdl,0);

%% ---------- fonctions locales ----------
function x = en_trames(x,w)
if ndims(x)==3, x = permute(x,[3 1 2]); end
x = reshape(x,[],w);
end
function teb = teb_trames(ref,dec,lag)
M = size(dec,1);  d = dec(lag+1:M,:);  s = ref(1:M-lag,:);
teb = sum(s(:)~=d(:))/numel(s);
end
function t = nz(t), t(t==0) = NaN; end      % TEB nuls non tracés en log
function y = ifelse(c,a,b), if c, y=a; else, y=b; end, end
