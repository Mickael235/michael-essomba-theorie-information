%% partie4_hamming_performances.m
% PARTIE 4 - Hamming C(7,4) : chaine complete Q10 a Q12

run('partie4_parametres.m');

mdl = 'Partie4_Hamming';
load_system(mdl);

%% =========================================================
% Parametres generaux
% ==========================================================

Q = @(x) 0.5*erfc(x/sqrt(2));

EbN0_dB_vec = 0:9;

TEB_sim     = zeros(size(EbN0_dB_vec));
TEB_hamming = zeros(size(EbN0_dB_vec));
TEB_sans    = zeros(size(EbN0_dB_vec));

% Simulation suffisamment longue pour les courbes
nErrMax = 1e9;
Tstop_Q10 = 50000;

set_param(mdl,'StopTime','Tstop_Q10');


%% =========================================================
% Mesure automatique du retard sans bruit
% ==========================================================

variance_bruit_code_save = variance_bruit_code;

variance_bruit_code = 0;

simOut = sim(mdl);

src0 = simOut.get('bits_emis');
dec0 = simOut.get('bits_decodes');

src0 = src0(:);
dec0 = dec0(:);

maxD = 50;

meilleurTEB = inf;
d_hamming = 0;

for d = 0:maxD

    N = min(numel(src0),numel(dec0)-d);

    if N <= 0
        continue;
    end

    teb_test = mean(src0(1:N) ~= dec0(1+d:d+N));

    if teb_test < meilleurTEB
        meilleurTEB = teb_test;
        d_hamming = d;
    end
end

fprintf('\n=== VALIDATION SANS BRUIT ===\n');
fprintf('Retard Hamming mesure : %d bits | TEB = %g\n', ...
    d_hamming,meilleurTEB);

if meilleurTEB == 0
    fprintf('Validation sans bruit : OK\n');
else
    fprintf('Validation sans bruit : ECHEC\n');
end

variance_bruit_code = variance_bruit_code_save;


%% =========================================================
% Q10 - Theorie et simulation
% ==========================================================

fprintf('\n=== Q10 - HAMMING C(7,4) ===\n');

for k = 1:numel(EbN0_dB_vec)

    EbN0_dB = EbN0_dB_vec(k);

    gamma = 10^(EbN0_dB/10);


    %% -----------------------------------------------------
    % Theorie sans codage
    % ------------------------------------------------------

    TEB_sans(k) = Q(sqrt(2*gamma));


    %% -----------------------------------------------------
    % Theorie Hamming
    % ------------------------------------------------------

    % Energie d'un bit code :
    % Ec = R*Eb
    %
    % p = probabilite d'erreur avant decodage

    p = Q(sqrt(2*R*gamma));

    % TEB exact sur les 4 bits utiles apres decodage

    TEB_hamming(k) = ...
        9*p^2*(1-p)^5 + ...
        19*p^3*(1-p)^4 + ...
        16*p^4*(1-p)^3 + ...
        12*p^5*(1-p)^2 + ...
        7*p^6*(1-p) + ...
        p^7;


    %% -----------------------------------------------------
    % Bruit Simulink
    % ------------------------------------------------------

    Eb = A^2*Tb;

    N0 = Eb/gamma;

    % Le modele Partie4_Hamming utilise variance_bruit_code
    variance_bruit_code = N0/(2*Tc);


    %% -----------------------------------------------------
    % Simulation
    % ------------------------------------------------------

    simOut = sim(mdl);

    source4 = simOut.get('bits_emis');
    decode4 = simOut.get('bits_decodes');

    source4 = source4(:);
    decode4 = decode4(:);


    %% -----------------------------------------------------
    % Compensation du retard
    % ------------------------------------------------------

    N = min(numel(source4),numel(decode4)-d_hamming);

    if N <= 0
        error('Pas assez de donnees pour calculer le TEB.');
    end

    src = source4(1:N);

    dec = decode4( ...
        1+d_hamming : d_hamming+N);


    %% -----------------------------------------------------
    % TEB simule
    % ------------------------------------------------------

    nb_erreurs = sum(src ~= dec);

    nb_bits = N;

    TEB_sim(k) = nb_erreurs/nb_bits;


    %% -----------------------------------------------------
    % Affichage
    % ------------------------------------------------------

    fprintf(['%2d dB : Sim %.4e | ', ...
             'Hamming %.4e | ', ...
             'Sans %.4e | ', ...
             '%d erreurs / %d bits\n'], ...
        EbN0_dB, ...
        TEB_sim(k), ...
        TEB_hamming(k), ...
        TEB_sans(k), ...
        nb_erreurs, ...
        nb_bits);
    if nb_erreurs < 100
        fprintf('       -> estimation statistique peu fiable (<100 erreurs)\n');
    end

end


%% =========================================================
% Figure Q10
% ==========================================================

figure('Name','P4 - Hamming perf Q10');
semilogy( ...
    EbN0_dB_vec, ...
    TEB_sans, ...
    '-o', ...
    'LineWidth',1.4);

hold on;

semilogy( ...
    EbN0_dB_vec, ...
    TEB_hamming, ...
    '-s', ...
    'LineWidth',1.4);

semilogy( ...
    EbN0_dB_vec, ...
    TEB_sim, ...
    'x-', ...
    'LineWidth',1.4);

xline(0.24,'--','Shannon R=4/7');

xline(-1.59,':','Limite absolue');

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('Hamming C(7,4) : theorie et simulation');

legend( ...
    'Sans codage', ...
    'Hamming theorie', ...
    'Hamming simulation', ...
    'Shannon R=4/7', ...
    'Limite absolue', ...
    'Location','southwest');


%% =========================================================
% Q11 - Croisement et gain de codage
% ==========================================================

x_dB = -2:0.001:12;

x = 10.^(x_dB/10);

Pb_s = Q(sqrt(2*x));

Pb_h = zeros(size(x));

for k = 1:numel(x)

    p = Q(sqrt(2*R*x(k)));

    Pb_h(k) = ...
        9*p^2*(1-p)^5 + ...
        19*p^3*(1-p)^4 + ...
        16*p^4*(1-p)^3 + ...
        12*p^5*(1-p)^2 + ...
        7*p^6*(1-p) + ...
        p^7;
end


%% Croisement

iCross = find(Pb_h < Pb_s,1,'first');


%% Eb/N0 pour TEB = 1e-4

[~,iS] = min(abs(Pb_s - 1e-4));

[~,iH] = min(abs(Pb_h - 1e-4));


fprintf('\n=== Q11 - GAIN DE CODAGE ===\n');

fprintf('Croisement : %.3f dB\n', ...
    x_dB(iCross));

fprintf('Sans code a 1e-4 : %.3f dB\n', ...
    x_dB(iS));

fprintf('Hamming a 1e-4   : %.3f dB\n', ...
    x_dB(iH));

fprintf('Gain de codage    : %.3f dB\n', ...
    x_dB(iS)-x_dB(iH));


%% =========================================================
% Q12 - Debit et latence
% ==========================================================

fprintf('\n=== Q12 - DEBIT ET LATENCE ===\n');

fprintf('R = 4/7 = %.4f\n',R);

fprintf(['Debit canal a debit utile constant : ', ...
         'x7/4, soit +75 %%.\n']);

fprintf(['Latence : attente d''un bloc de 4 bits ', ...
         'a l''encodage et de 7 bits codes ', ...
         'au decodage.\n']);