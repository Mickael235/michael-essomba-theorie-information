%% run_partie4_registre.m
% Valide le codeur a registre a decalage (Partie4_Registre.slx) :
%  1) table des etats du registre pour m = [1,0,1,1]
%  2) comparaison avec le codeur matriciel pour les 16 messages

modele = 'Partie4_Registre';
load_system(modele);
Tb = 1;

%% Les 16 messages, bits entres poids fort d'abord (m3 m2 m1 m0)
P = [1 1 0; 0 1 1; 1 1 1; 1 0 1];          % partie P de G = [I4 | P]
M = zeros(16, 4);                          % M(n+1,:) = [m0 m1 m2 m3]
for n = 0:15, M(n+1,:) = bitget(n, 1:4); end
serie = fliplr(M);                         % [m3 m2 m1 m0]
bits  = reshape(serie.', [], 1);           % 64 bits, message apres message
entree_msg = [(0:numel(bits)-1)'*Tb, bits];

%% Simulation
sortie = sim(modele, 'ReturnWorkspaceOutputs', 'on');
T = double(squeeze(sortie.get('table_etats')));
if size(T,2) ~= 5 && size(T,1) == 5, T = T.'; end   % colonnes : [m f s0 s1 s2]
% ligne k du journal <-> instant (k-1)*Tb

%% 1) Table des etats pour m = [1,0,1,1]  (n = 13)
b = 13;
fprintf('\nTable des etats du registre, m = [1 0 1 1], entree m3 m2 m1 m0 :\n');
fprintf(' horloge | m_in | f | s0 s1 s2\n');
fprintf('    0    |  -   | - |  0  0  0   (remise a zero par le Switch)\n');
for i = 1:4
    ligne = T(4*b + i, :);                 % m_in et f a l'horloge i
    etat  = T(4*b + i + 1, 3:5);           % etat apres l'horloge i
    fprintf('    %d    |  %d   | %d |  %d  %d  %d\n', i, ligne(1), ligne(2), etat);
end

%% 2) Les 16 mots-codes : registre contre produit matriciel
fprintf('\n  m0 m1 m2 m3 | c matriciel      | c registre       | ok\n');
nerr = 0;
for b = 0:15
    m     = M(b+1, :);
    c_ref = [m, mod(m*P, 2)];
    r_sim = T(4*(b+1) + 1, 3:5);           % registre a l'instant 4(b+1)Tb
    c_sim = [m, r_sim];
    ok = isequal(c_ref, c_sim);
    nerr = nerr + ~ok;
    fprintf('  %d  %d  %d  %d  | %s | %s | %d\n', m, ...
            sprintf('%d', c_ref), sprintf('%d', c_sim), ok);
end
if nerr == 0
    fprintf('\nLe registre produit les 16 mots-codes du codeur matriciel : VALIDE.\n');
else
    fprintf('\n%d mot(s)-code(s) different(s) : a verifier.\n', nerr);
end
