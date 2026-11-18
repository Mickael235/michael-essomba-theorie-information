%% run_partie5_simulations.m
% Validation et performances des modeles Partie 5.

run('partie5_parametres.m');

modeles = { ...
    'Partie5_QPSK', ...
    'Partie5_QPSK_naturel', ...
    'Partie5_QPSK_Hamming'};

%% =========================================================
% 1) VALIDATION SANS BRUIT
% ==========================================================

variance_bruit_qpsk = 0;
Nbits = 4000;

lags = zeros(1,3);

fprintf('\n============================================\n');
fprintf(' P5 - VALIDATION SANS BRUIT\n');
fprintf('============================================\n');

for m = 1:3

    out = sim(modeles{m});

    src = getvar(out,'bits_emis');
    dec = getvar(out,'bits_decodes');

    [lags(m),teb0] = meilleur_retard(src,dec,20);

    fprintf('%-31s : retard=%d, TEB=%.3g\n', ...
        modeles{m},lags(m),teb0);

    assert(teb0 == 0, ...
        'Validation sans bruit echouee pour %s.',modeles{m});
end

fprintf('Validation Q2/Q5/Q6 : OK\n');


%% =========================================================
% 2) COURBES TEB
% ==========================================================

run('partie5_parametres.m');

Nbits = 5e4;

EbN0_vec = 0:9;
ns = numel(EbN0_vec);

teb_gray = zeros(1,ns);
teb_nat  = zeros(1,ns);
teb_ham  = zeros(1,ns);

fprintf('\n============================================\n');
fprintf(' P5 - PERFORMANCES TEB\n');
fprintf('============================================\n');

for k = 1:ns

    gamma = 10^(EbN0_vec(k)/10);

    %% QPSK non codee
    % Eb = Es/2
    variance_bruit_qpsk = Eb_qpsk/(2*gamma);

    out = sim(modeles{1});

    teb_gray(k) = teb_retarde( ...
        getvar(out,'bits_emis'), ...
        getvar(out,'bits_decodes'), ...
        lags(1));

    %% QPSK mapping naturel
    out = sim(modeles{2});

    teb_nat(k) = teb_retarde( ...
        getvar(out,'bits_emis'), ...
        getvar(out,'bits_decodes'), ...
        lags(2));

    %% QPSK + Hamming
    % Eb information = Es/(2R)
    variance_bruit_qpsk = Eb_qpsk/(2*R*gamma);

    out = sim(modeles{3});

    teb_ham(k) = teb_retarde( ...
        getvar(out,'bits_emis'), ...
        getvar(out,'bits_decodes'), ...
        lags(3));

    fprintf('%2d dB | Gray %.3e | Naturel %.3e | Hamming %.3e\n', ...
        EbN0_vec(k), ...
        teb_gray(k), ...
        teb_nat(k), ...
        teb_ham(k));
end


%% =========================================================
% 3) THEORIE QPSK GRAY
% ==========================================================

th = Q(sqrt(2*10.^(EbN0_vec/10)));


%% =========================================================
% FIGURE P5-1 : PERFORMANCES TEB
% ==========================================================

figure('Name','P5 - Performances TEB QPSK', ...
       'NumberTitle','off');

semilogy(EbN0_vec,th, ...
    'k-', ...
    'LineWidth',1.5);

hold on;

semilogy(EbN0_vec,teb_gray, ...
    'o-', ...
    'LineWidth',1.2);

semilogy(EbN0_vec,teb_nat, ...
    's-', ...
    'LineWidth',1.2);

semilogy(EbN0_vec,teb_ham, ...
    'd-', ...
    'LineWidth',1.2);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('P5 - Performances QPSK');

legend( ...
    'Theorie QPSK Gray', ...
    'QPSK Gray', ...
    'QPSK naturel', ...
    'QPSK Gray + Hamming', ...
    'Location','southwest');


%% =========================================================
% 4) CONSTELLATIONS GRAY : 0 / 5 / 10 dB
% ==========================================================

snrdb = [0 5 10];

figure('Name','P5 - Constellations QPSK Gray', ...
       'NumberTitle','off');

for j = 1:3

    gamma = 10^(snrdb(j)/10);

    variance_bruit_qpsk = Eb_qpsk/(2*gamma);

    Nbits = 4000;

    out = sim(modeles{1});

    z = getvar(out,'symboles_rx');

    subplot(1,3,j);

    plot(real(z),imag(z),'.');

    axis equal;
    grid on;

    xlim([-2 2]);
    ylim([-2 2]);

    xlabel('I');
    ylabel('Q');

    title(sprintf('E_b/N_0 = %d dB',snrdb(j)));
end

sgtitle('P5 - Constellations QPSK Gray');


%% =========================================================
% 5) BILAN
% ==========================================================

fprintf('\n============================================\n');
fprintf(' P5 - BILAN\n');
fprintf('============================================\n');

fprintf('Validation sans bruit : OK\n');
fprintf('Retard QPSK Gray      : %d bits\n',lags(1));
fprintf('Retard QPSK naturel   : %d bits\n',lags(2));
fprintf('Retard QPSK + Hamming : %d bits\n',lags(3));

fprintf(['QPSK Gray : TEB proche de la theorie ', ...
         'BPSK/QPSK a E_b/N_0 egal.\n']);

fprintf(['Mapping naturel : TEB superieur au Gray ', ...
         'car une erreur symbole peut provoquer plusieurs erreurs binaires.\n']);

fprintf(['Hamming : amelioration aux E_b/N_0 eleves ', ...
         'au prix de redondance.\n']);

fprintf('\nPartie 5 : simulations terminees.\n');


%% =========================================================
% FONCTIONS LOCALES
% ==========================================================

function v = getvar(out,name)

v = [];

try
    v = out.get(name);
catch
end

if isempty(v)
    v = evalin('base',name);
end

v = v(:);

end


function [bestLag,bestTeb] = meilleur_retard(src,dec,maxLag)

src = src(:);
dec = dec(:);

bestTeb = inf;
bestLag = 0;

for d = 0:maxLag

    % Le signal decode est retarde par rapport a la source
    N = min(numel(src),numel(dec)-d);

    if N <= 0
        continue;
    end

    t = mean(src(1:N) ~= dec(1+d:d+N));

    if t < bestTeb
        bestTeb = t;
        bestLag = d;
    end
end

end


function teb = teb_retarde(src,dec,d)

src = src(:);
dec = dec(:);

N = min(numel(src),numel(dec)-d);

teb = mean(src(1:N) ~= dec(1+d:d+N));

end