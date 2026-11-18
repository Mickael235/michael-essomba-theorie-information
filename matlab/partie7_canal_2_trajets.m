%% PARTIE 7 - Canal a deux trajets
% Complement du TP : illustration de l'interference entre symboles
% introduite par un trajet direct et un trajet retarde.

P = parametres_perso('Essomba Michael');

%% Parametres du canal
% Valeurs de demonstration si elles ne sont pas presentes dans parametres_perso.
if isfield(P,'beta')
    beta = P.beta;
else
    beta = 0.5;
end

if isfield(P,'tau')
    tau = P.tau;
else
    tau = 1;
end

fprintf('\n============================================\n');
fprintf(' PARTIE 7 - CANAL A DEUX TRAJETS\n');
fprintf('============================================\n');
fprintf('beta = %.3f\n',beta);
fprintf('tau  = %.3f symbole(s)\n',tau);

%% Q1 - Illustration discrete du canal
% Modele simplifie :
% y[n] = x[n] + beta*x[n-d]
% avec d entier pour visualiser simplement l'effet du trajet retarde.

N = 40;
rng(P.graine);
bits = double(rand(1,N) > 0.5);
x = 2*bits - 1;

d = max(1,round(tau));

y = x;
if d < N
    y(1+d:end) = y(1+d:end) + beta*x(1:end-d);
end

figure('Name','P7 - Canal a deux trajets','NumberTitle','off');

subplot(2,1,1);
stem(0:N-1,x,'filled');
grid on;
xlabel('n');
ylabel('x[n]');
title('Signal emis');

subplot(2,1,2);
stem(0:N-1,y,'filled');
grid on;
xlabel('n');
ylabel('y[n]');
title(sprintf('Signal recu : y[n] = x[n] + %.2f x[n-%d]',beta,d));

%% Q2 - Reponse impulsionnelle
h = zeros(1,d+1);
h(1) = 1;
h(end) = beta;

figure('Name','P7 - Reponse impulsionnelle canal','NumberTitle','off');
stem(0:d,h,'filled');
grid on;
xlabel('Retard en symboles');
ylabel('Amplitude');
title('Reponse impulsionnelle du canal a deux trajets');

%% Q3 - Bilan qualitatif
fprintf('\nQ1 - Effet du canal :\n');
fprintf(['Le trajet retarde ajoute une copie d''un symbole precedent. ', ...
         'Cette superposition cree de l''interference entre symboles.\n']);

fprintf('\nQ2 - Egalisation :\n');
fprintf(['Une egalisation peut chercher a inverser ou compenser le canal. ', ...
         'Un egaliseur zero-forcing reduit l''IES mais peut amplifier le bruit, ', ...
         'alors qu''un egaliseur MMSE realise un compromis.\n']);

fprintf('\nQ3 - Transmission d''un texte :\n');
fprintf(['A faible Eb/N0, les erreurs restent nombreuses. ', ...
         'A Eb/N0 plus eleve, un codage correcteur comme Hamming devient ', ...
         'plus efficace pour restaurer les bits errones.\n']);
