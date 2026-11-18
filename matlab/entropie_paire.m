function H2 = entropie_paire(sequence)
%ENTROPIE_PAIRE Entropie H(X1,X2)/2 de paires consécutives.

x = double(sequence(:));
paires = [x(1:end-1), x(2:end)];
[~,~,idx] = unique(paires,'rows');
occ = accumarray(idx,1);
p = occ/sum(occ);
H2 = -sum(p.*log2(p))/2;
end
