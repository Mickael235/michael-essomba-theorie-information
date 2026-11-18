function lancer_mini_application
% LANCER_MINI_APPLICATION
% Configure les chemins du depot puis lance la mini-application existante.

matlabDir = fileparts(mfilename('fullpath'));
repoDir = fileparts(matlabDir);

cd(repoDir);
addpath(genpath(matlabDir));
addpath(fullfile(repoDir,'simulink'));

mini_application_tp;
end
