%% =========================================================
% QUESTION 10 - VALIDATION LZ78
% ==========================================================


sequence = 'ABAABABAABAB';

couples = lz78_encode(sequence);

fprintf('============================================\n');
fprintf('QUESTION 10 - VALIDATION LZ78\n');
fprintf('============================================\n');

for i = 1:length(couples)

    indice = couples{i}{1};
    symbole = couples{i}{2};

    fprintf('(%d,%s)\n', indice, symbole);

end

sequence_decodee = lz78_decode(couples);

fprintf('\nSéquence originale : %s\n', sequence);
fprintf('Séquence décodée   : %s\n', sequence_decodee);

if strcmp(sequence, sequence_decodee)
    fprintf('Décodage correct : OUI\n');
else
    fprintf('Décodage correct : NON\n');
end

%% =========================================================
% QUESTION 11 - PERFORMANCES LZ78
% ==========================================================

fprintf('\n============================================\n');
fprintf('QUESTION 11 - PERFORMANCES LZ78\n');
fprintf('============================================\n');

%% Texte complet

texte = fileread('Projet_guttenberg_Le Fantôme de lOpéra.txt');

bps_texte = cout_lz78(texte);

fprintf('Texte complet : %.4f bits/symbole\n', bps_texte);

%% 5000 premiers caractères

texte_5000 = texte(1:min(5000,length(texte)));

bps_5000 = cout_lz78(texte_5000);

fprintf('5000 premiers caractères : %.4f bits/symbole\n', bps_5000);

%% Source binaire p1_ext

P = parametres_perso('Essomba Michael');

p1_ext = P.p1_ext;

H_ext = -p1_ext*log2(p1_ext) ...
        -(1-p1_ext)*log2(1-p1_ext);

tailles = [1e3 1e4 1e5 1e6];

bps_bin = zeros(size(tailles));

rng(P.graine);

for j = 1:length(tailles)

    N = tailles(j);

    bits = double(rand(1,N) < p1_ext);

    % Conversion en caractères '0' et '1'
    seq_bin = char(bits + '0');

    bps_bin(j) = cout_lz78(seq_bin);

    fprintf('N = %.0f -> %.4f bits/symbole\n', ...
        N, bps_bin(j));

end

%% Tracé

figure('Name','P2 - LZ78 convergence');
semilogx(tailles, bps_bin, 'o-', ...
    'LineWidth', 1.5);

hold on;

yline(H_ext, '--', ...
    'LineWidth', 1.5);

grid on;

xlabel('Longueur du message');
ylabel('Bits par symbole');

title('Convergence du codage LZ78');

legend('LZ78', ...
       'Entropie de la source', ...
       'Location', 'best');


%%Le codage LZ78 est universel : il ne nécessite pas la connaissance préalable des probabilités des symboles. Pour une source binaire, le nombre de bits par symbole diminue lorsque la longueur du message augmente et se rapproche progressivement de l’entropie de la source. La convergence est relativement lente, car le dictionnaire doit être construit progressivement. LZ78 est donc particulièrement intéressant pour les fichiers longs, où le coût initial du dictionnaire devient négligeable.%%

