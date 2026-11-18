%% EXPORT_FIGURES_TP
% Exporte automatiquement les figures produites par les scripts du TP.

matlabDir = fileparts(mfilename('fullpath'));
repoDir = fileparts(matlabDir);
figDir = fullfile(repoDir,'assets','figures');

cd(repoDir);
addpath(genpath(matlabDir));
addpath(fullfile(repoDir,'simulink'));

if ~exist(figDir,'dir')
    mkdir(figDir);
end

scripts = { ...
    'partie2_source.m', ...
    'partie2_huffman.m', ...
    'partie2_extension_memoire.m', ...
    'test_lz78m.m', ...
    'partie3_cbs.m', ...
    'partie3_uniforme.m', ...
    'partie3_gaussien.m', ...
    'partie3_detecteur_optimal.m', ...
    'partie4_hamming_theorie.m', ...
    'partie4_hamming_performances.m', ...
    'partie5_qpsk_analyse.m', ...
    'run_partie5_simulations.m', ...
    'partie6_analyse_filtres.m', ...
    'run_partie6_simulations.m'};

for i = 1:numel(scripts)

    fprintf('\nExecution : %s\n',scripts{i});

    % Figures deja ouvertes : application, anciennes figures, etc.
    avant = findall(groot,'Type','figure');

    try
        run(fullfile(matlabDir,scripts{i}));
    catch ME
        fprintf(2,'ERREUR : %s\n',ME.message);
        continue;
    end

    drawnow;

    % Ne garder que les figures creees par CE script.
    apres = findall(groot,'Type','figure');
    figs = setdiff(apres,avant,'stable');
    figs = flip(figs(:));

    if isempty(figs)
        fprintf('  -> aucune figure\n');
        continue;
    end

    for k = 1:numel(figs)

        nom = get(figs(k),'Name');

        if isempty(nom)
            nom = sprintf('%s_%02d',erase(scripts{i},'.m'),k);
        end

        nom = regexprep(nom,'[^a-zA-Z0-9_-]','_');
        fichier = fullfile(figDir,[nom '.png']);

        exportgraphics(figs(k),fichier,'Resolution',180);

        fprintf('  -> %s\n',fichier);
    end

    % Fermer uniquement les figures que ce script vient de creer.
    for k = 1:numel(figs)
        if isvalid(figs(k))
            close(figs(k));
        end
    end
end

fprintf('\nExport des figures termine.\n');
