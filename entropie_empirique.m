function H = entropie_empirique(sequence)
%ENTROPIE_EMPIRIQUE Entropie empirique d'une séquence.

[~,~,idx] = unique(sequence);
occ = accumarray(idx(:),1);
p = occ/sum(occ);
H = -sum(p.*log2(p));
end
