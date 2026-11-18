function mini_application_tp
% MINI_APPLICATION_TP
% Navigation, verification et lancement du TP de transmission numerique.
% Les fichiers build_*.m ne sont pas necessaires : les modeles .slx sont deja construits.

clc;close all;

while true
    fprintf('\n====================================================\n');
    fprintf(' TP - CHAINE DE TRANSMISSION NUMERIQUE\n');
    fprintf('====================================================\n');
    fprintf('1 - Partie 2 : codage de source\n');
    fprintf('2 - Partie 3 : chaine de base\n');
    fprintf('3 - Partie 4 : codage Hamming\n');
    fprintf('4 - Partie 5 : modulation QPSK\n');
    fprintf('5 - Partie 6 : mise en forme / RRC\n');
    fprintf('6 - Synthese generale\n');
    fprintf('7 - Tests rapides du TP\n');
    fprintf('8 - Simulations principales du TP\n');
    fprintf('0 - Quitter\n');

    choix = input('\nChoix : ');

    switch choix
        case 1, lancer_partie2;
        case 2, lancer_partie3;
        case 3, lancer_partie4;
        case 4, lancer_partie5;
        case 5, lancer_partie6;
        case 6, appeler_fonction('interpretation_conclusion_tp');
        case 7, tests_rapides;
        case 8, simulations_principales;
        case 0
            fprintf('Fin.\n');
            return;
        otherwise
            fprintf('Choix invalide.\n');
    end
end
end

%% ---------------- PARTIE 2 ----------------
function lancer_partie2
fprintf('\nPARTIE 2 - CODAGE DE SOURCE\n');
fprintf('1 - Source binaire / entropie   : partie2_source.m\n');
fprintf('2 - Huffman Q3-Q6               : partie2_huffman.m\n');
fprintf('3 - Extension / memoire Q7-Q9   : partie2_extension_memoire.m\n');
fprintf('4 - Test Huffman                 : test_huffman.m\n');
fprintf('5 - Test LZ78 Q10-Q11           : test_lz78m.m\n');
fprintf('6 - Modele source Simulink       : Codage_source.slx\n');
fprintf('7 - Interpretations              : interpretations_partie2.m\n');
c=input('Choix : ');
switch c
    case 1, executer('partie2_source.m');
    case 2, executer('partie2_huffman.m');
    case 3, executer('partie2_extension_memoire.m');
    case 4, executer('test_huffman.m');
    case 5, executer('test_lz78m.m');
    case 6, ouvrir_modele('Codage_source');
    case 7, appeler_fonction('interpretations_partie2');
end
end

%% ---------------- PARTIE 3 ----------------
function lancer_partie3
fprintf('\nPARTIE 3 - CHAINE DE BASE\n');
fprintf('1 - CBS Q1-Q3                  : partie3_cbs.m\n');
fprintf('2 - Modele CBS                 : Partie3_CBS.slx\n');
fprintf('3 - Bruit uniforme Q4-Q6       : partie3_uniforme.m\n');
fprintf('4 - Bruit gaussien Q7-Q9       : partie3_gaussien.m\n');
fprintf('5 - Detecteur optimal Q10-Q13  : partie3_detecteur_optimal.m\n');
fprintf('6 - Modele detecteur           : Partie3_Detecteur.slx\n');
fprintf('7 - Interpretations            : interpretations_partie3.m\n');
c=input('Choix : ');
switch c
    case 1, executer('partie3_cbs.m');
    case 2, ouvrir_modele('Partie3_CBS');
    case 3, executer('partie3_uniforme.m');
    case 4, executer('partie3_gaussien.m');
    case 5, executer('partie3_detecteur_optimal.m');
    case 6, ouvrir_modele('Partie3_Detecteur');
    case 7, appeler_fonction('interpretations_partie3');
end
end

%% ---------------- PARTIE 4 ----------------
function lancer_partie4
fprintf('\nPARTIE 4 - CODAGE HAMMING C(7,4)\n');
fprintf('1 - Theorie Q1-Q9             : partie4_hamming_theorie.m\n');
fprintf('2 - Test codeur/decodeur      : test_hamming74.m\n');
fprintf('3 - Modele registre Q4-Q5     : Partie4_Registre.slx\n');
fprintf('4 - Validation registre       : run_partie4_registre.m\n');
fprintf('5 - Modele chaine Hamming     : Partie4_Hamming.slx\n');
fprintf('6 - Performances Q10-Q12      : partie4_hamming_performances.m\n');
fprintf('7 - Interpretations           : interpretations_partie4.m\n');
c=input('Choix : ');
switch c
    case 1, executer('partie4_hamming_theorie.m');
    case 2, executer('test_hamming74.m');
    case 3, ouvrir_modele('Partie4_Registre');
    case 4, executer('run_partie4_registre.m');
    case 5
        executer('partie4_parametres.m');
        ouvrir_modele('Partie4_Hamming');
    case 6
        executer('partie4_parametres.m');
        executer('partie4_hamming_performances.m');
    case 7, appeler_fonction('interpretations_partie4');
end
end

%% ---------------- PARTIE 5 ----------------
function lancer_partie5
fprintf('\nPARTIE 5 - MODULATION QPSK\n');
fprintf('1 - Analyse Q1,Q3-Q5          : partie5_qpsk_analyse.m\n');
fprintf('2 - Performances              : partie5_qpsk_performances.m\n');
fprintf('3 - Simulation / validation   : run_partie5_simulations.m\n');
fprintf('4 - Modele QPSK Gray          : Partie5_QPSK.slx\n');
fprintf('5 - Modele QPSK naturel       : Partie5_QPSK_naturel.slx\n');
fprintf('6 - Modele QPSK + Hamming     : Partie5_QPSK_Hamming.slx\n');
fprintf('7 - Interpretations           : interpretations_partie5.m\n');
c=input('Choix : ');
switch c
    case 1, executer('partie5_qpsk_analyse.m');
    case 2, executer('partie5_qpsk_performances.m');
    case 3, executer('run_partie5_simulations.m');
    case 4, ouvrir_modele('Partie5_QPSK');
    case 5, ouvrir_modele('Partie5_QPSK_naturel');
    case 6, ouvrir_modele('Partie5_QPSK_Hamming');
    case 7, appeler_fonction('interpretations_partie5');
end
end

%% ---------------- PARTIE 6 ----------------
function lancer_partie6
fprintf('\nPARTIE 6 - MISE EN FORME / FILTRE ADAPTE\n');
fprintf('1 - Analyse filtres Q2-Q4     : partie6_analyse_filtres.m\n');
fprintf('2 - Test sans bruit           : test_partie6_rrc.m\n');
fprintf('3 - Simulations Q1-Q6         : run_partie6_simulations.m\n');
fprintf('4 - Modele Simulink           : Partie6_RRC.slx\n');
fprintf('5 - Interpretations           : interpretations_partie6.m\n');
c=input('Choix : ');
switch c
    case 1, executer('partie6_analyse_filtres.m');
    case 2, executer('test_partie6_rrc.m');
    case 3, executer('run_partie6_simulations.m');
    case 4, ouvrir_modele('Partie6_RRC');
    case 5, executer_ou_fonction('interpretations_partie6.m','interpretations_partie6');
end
end


%% ---------------- TESTS RAPIDES ----------------
function tests_rapides
fprintf('\n=== TESTS RAPIDES DU TP ===\n');

fprintf('\n--- Huffman ---\n');
executer('test_huffman.m');

fprintf('\n--- LZ78 ---\n');
executer('test_lz78m.m');

fprintf('\n--- Hamming Matlab ---\n');
executer('test_hamming74.m');

fprintf('\n--- Registre Hamming Simulink ---\n');
executer('run_partie4_registre.m');

fprintf('\n--- Partie 6 sans bruit ---\n');
executer('test_partie6_rrc.m');

fprintf('\nTests rapides termines.\n');
end

%% ---------------- SIMULATIONS COMPLETES ----------------
function simulations_principales
fprintf('\n=== SIMULATIONS PRINCIPALES ===\n');

fprintf('\n--- Partie 2 ---\n');
executer('partie2_source.m');
executer('partie2_huffman.m');
executer('partie2_extension_memoire.m');

fprintf('\n--- Partie 3 ---\n');
executer('partie3_cbs.m');
executer('partie3_uniforme.m');
executer('partie3_gaussien.m');
executer('partie3_detecteur_optimal.m');

fprintf('\n--- Partie 4 ---\n');
executer('partie4_hamming_theorie.m');
executer('partie4_hamming_performances.m');

fprintf('\n--- Partie 5 ---\n');
executer('partie5_qpsk_analyse.m');
executer('run_partie5_simulations.m');

fprintf('\n--- Partie 6 ---\n');
executer('partie6_analyse_filtres.m');
executer('run_partie6_simulations.m');

fprintf('\nToutes les simulations principales ont ete lancees.\n');
end

%% ---------------- OUTILS ----------------
function executer(f)

if exist(f,'file')==2
    fprintf('\nExecution : %s\n\n',f);

    try
        % Executer le script dans le workspace de base.
        % Ainsi, un "clear" dans le script ne supprime pas
        % les variables locales de mini_application_tp.
        commande = sprintf('run(''%s'');', strrep(f,'''',''''''));
        evalin('base',commande);

    catch ME
        fprintf(2,'ERREUR dans %s :\n%s\n',f,ME.message);
    end

else
    fprintf(2,'Fichier absent : %s\n',f);
end

end

function appeler_fonction(nom)
if exist(nom,'file')==2
    fprintf('\nExecution : %s\n\n',nom);
    try
        feval(nom);
    catch ME
        fprintf(2,'ERREUR dans %s :\n%s\n',nom,ME.message);
    end
else
    fprintf(2,'Fonction absente : %s.m\n',nom);
end
end

function executer_ou_fonction(f,nom)
if exist(f,'file')~=2
    fprintf(2,'Fichier absent : %s\n',f);
    return;
end
try
    feval(nom);
catch
    executer(f);
end
end

function ouvrir_modele(m)
if exist([m '.slx'],'file')==2 || exist([m '.slx'],'file')==4
    try
        open_system(m);
        fprintf('Modele ouvert : %s.slx\n',m);
    catch ME
        fprintf(2,'Impossible d''ouvrir %s.slx :\n%s\n',m,ME.message);
    end
else
    fprintf(2,'Modele absent : %s.slx\n',m);
end
end
