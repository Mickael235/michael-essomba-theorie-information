%% partie3_detecteur_optimal.m
% PARTIE 3.4 - Detecteur optimal et performances (Q10 a Q13)

run('partie3_parametres.m');

%% =========================================================
% PARAMETRES
% ==========================================================

p1 = 0.5;
p0 = 0.5;

d = 2;
nErrMax = 100;

Eb = A^2*Tb;

% IMPORTANT :
% utilise par Downsample1 dans la branche sans integration
ech_milieu = floor(L/2);


%% =========================================================
% Q10-Q11 - POINT DE FONCTIONNEMENT A 5 dB
% ==========================================================

EbN0_dB = 5;
EbN0 = 10^(EbN0_dB/10);

N0 = Eb/EbN0;

% Variance du bruit par echantillon
variance_bruit = N0*L/(2*Tb);

% Apres moyenne de L echantillons independants
variance_sortie = variance_bruit/L;

TEB_theorique = Q(sqrt(2*EbN0));


fprintf('\n============================================\n');
fprintf(' P3 - DETECTEUR OPTIMAL : POINT A 5 dB\n');
fprintf('============================================\n');

fprintf('Eb/N0                         = %.1f dB\n',EbN0_dB);
fprintf('Variance bruit echantillon   = %.6f\n',variance_bruit);
fprintf('Variance apres integration   = %.6f\n',variance_sortie);
fprintf('N0/(2Tb)                     = %.6f\n',N0/(2*Tb));
fprintf('TEB theorique                = %.6e\n',TEB_theorique);


%% =========================================================
% Q12 - COURBES AVEC ET SANS INTEGRATION
% ==========================================================

EbN0_dB_vec = 0:9;

TEB_sim      = zeros(size(EbN0_dB_vec));
TEB_sans_int = zeros(size(EbN0_dB_vec));
TEB_theo     = zeros(size(EbN0_dB_vec));


fprintf('\n============================================\n');
fprintf(' P3 - PERFORMANCES DU DETECTEUR\n');
fprintf('============================================\n');


for k = 1:numel(EbN0_dB_vec)

    EbN0_dB = EbN0_dB_vec(k);

    EbN0 = 10^(EbN0_dB/10);

    N0 = Eb/EbN0;

    % Bruit applique a chaque echantillon
    variance_bruit = N0*L/(2*Tb);

    % TEB theorique du detecteur optimal antipodal
    TEB_theo(k) = Q(sqrt(2*EbN0));


    %% Simulation Simulink
    sim('Partie3_Detecteur');


    %% Recuperation des resultats
    ri = err;
    rs = err_sans_int;

    % On conserve la derniere valeur :
    % [TEB, nombre erreurs, nombre bits]
    if size(ri,1) > 1
        ri = ri(end,:);
    end

    if size(rs,1) > 1
        rs = rs(end,:);
    end


    TEB_sim(k)      = ri(1);
    TEB_sans_int(k) = rs(1);


    fprintf( ...
        '%2d dB | avec integration %.4e | theorie %.4e | sans integration %.4e\n', ...
        EbN0_dB, ...
        TEB_sim(k), ...
        TEB_theo(k), ...
        TEB_sans_int(k));

end


%% =========================================================
% FIGURE - COMPARAISON
% ==========================================================

figure( ...
    'Name','P3 - Detecteur optimal', ...
    'NumberTitle','off');

semilogy( ...
    EbN0_dB_vec, ...
    TEB_theo, ...
    '-', ...
    'LineWidth',1.5);

hold on;

semilogy( ...
    EbN0_dB_vec, ...
    TEB_sim, ...
    'o-', ...
    'LineWidth',1.4);

semilogy( ...
    EbN0_dB_vec, ...
    TEB_sans_int, ...
    's-', ...
    'LineWidth',1.4);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('P3 - Influence du detecteur optimal');

legend( ...
    'Theorie', ...
    'Avec integration', ...
    'Sans integration', ...
    'Location','southwest');


%% =========================================================
% BILAN Q12
% ==========================================================

fprintf('\n============================================\n');
fprintf(' P3 - BILAN Q12\n');
fprintf('============================================\n');

fprintf(['Avec integration : la simulation suit la theorie ', ...
         'Q(sqrt(2Eb/N0)).\n']);

fprintf(['Sans integration : le TEB est nettement plus eleve ', ...
         'car un seul echantillon est utilise pour la decision.\n']);


%% =========================================================
% Q13 - BRUIT UNIFORME
% ==========================================================

fprintf('\n============================================\n');
fprintf(' P3 - Q13\n');
fprintf('============================================\n');

fprintf([ ...
    'Apres moyenne de L bruits uniformes independants, ', ...
    'la loi n''est plus uniforme et tend vers une gaussienne.\n']);

fprintf('Variance apres moyenne : a^2/(3L).\n');