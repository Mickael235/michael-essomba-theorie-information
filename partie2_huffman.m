%% PARTIE 2.2 - Texte et Huffman (Q3 à Q6)

fichier = 'Projet_guttenberg_Le Fantôme de lOpéra.txt';
texte = fileread(fichier);
N = length(texte);

symboles = unique(texte);
M = numel(symboles);
freq = zeros(1,M);
for i = 1:M
    freq(i) = mean(texte == symboles(i));
end

H = entropie_empirique(texte);
Lfixe = ceil(log2(M));

fprintf('Caractères : %d\n',N);
fprintf('Alphabet   : %d\n',M);
fprintf('Entropie   : %.4f bits/caractère\n',H);
fprintf('Code fixe  : %d bits/caractère\n',Lfixe);

[freqTriee,ordre] = sort(freq,'descend');
symTriees = symboles(ordre);
nAff = min(20,M);

figure('Name','P2 - Fréquences caractères');
bar(freqTriee(1:nAff));
grid on;
title('Caractères les plus fréquents');
xlabel('Rang');
ylabel('Fréquence');

codes = huffman_perso(freq);
longueurs = cellfun(@length,codes);
Lmoy = sum(freq.*longueurs);
eff = H/Lmoy;

[~,indices] = ismember(texte,symboles);
liste = codes(indices);
texte_code = [liste{:}];

texte_decode = '';
courant = '';
for i = 1:length(texte_code)
    courant = [courant texte_code(i)]; %#ok<AGROW>
    j = find(strcmp(courant,codes),1);
    if ~isempty(j)
        texte_decode(end+1) = symboles(j); %#ok<AGROW>
        courant = '';
    end
end

fprintf('\nHuffman : %.4f bits/caractère\n',Lmoy);
fprintf('Efficacité : %.2f %%\n',100*eff);
fprintf('Shannon H<=L<H+1 : %d\n',H <= Lmoy && Lmoy < H+1);
fprintf('Décodage correct : %d\n',strcmp(texte,texte_decode));
fprintf('Gain vs 8 bits    : %.2f %%\n',100*(1-length(texte_code)/(8*N)));

cout_table = 8*M + sum(longueurs);
N_limite = ceil(cout_table/(0.01*Lmoy));
fprintf('Coût table : %d bits\n',cout_table);
fprintf('Table <1%% vers %d caractères\n',N_limite);
