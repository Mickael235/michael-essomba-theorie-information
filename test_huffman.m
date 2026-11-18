%% Validation de huffman_perso


prob = [0.4 0.2 0.2 0.1 0.1];
codes = huffman_perso(prob);
lg = cellfun(@length,codes);

Lmoy = sum(prob.*lg);
kraft = sum(2.^(-lg));

prefixe = true;
for i=1:numel(codes)
    for j=1:numel(codes)
        if i~=j && length(codes{i})<=length(codes{j}) ...
                && strncmp(codes{i},codes{j},length(codes{i}))
            prefixe = false;
        end
    end
end

fprintf('Longueur moyenne : %.4f (attendu 2.2)\n',Lmoy);
fprintf('Somme de Kraft   : %.4f\n',kraft);
fprintf('Code préfixe      : %d\n',prefixe);

assert(abs(Lmoy-2.2)<1e-12);
assert(abs(kraft-1)<1e-12);
assert(prefixe);
