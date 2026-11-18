function bps = cout_lz78(sequence)
%COUT_LZ78 Nombre moyen de bits par symbole pour LZ78

sequence = char(sequence);

couples = lz78_encode(sequence);

% Taille de l'alphabet
alphabet = unique(sequence);
A = length(alphabet);

bits_symbol = ceil(log2(A));

cout_total = 0;

for i = 1:length(couples)

    % Le i-ème couple coûte ceil(log2(i)) bits pour l'indice
    bits_indice = ceil(log2(max(i,1)));

    cout_total = cout_total + bits_indice + bits_symbol;

end

bps = cout_total / length(sequence);

end