function codes = huffman_perso(prob)

% prob : vecteur des probabilités
% codes : cellule contenant les mots binaires

n = length(prob);

% Chaque noeud contient une liste d'indices de symboles
groupes = cell(1,n);

% Codes initiaux vides
codes = cell(1,n);

for i = 1:n
    groupes{i} = i;
    codes{i} = '';
end

poids = prob(:)';

while length(poids) > 1

    % Trier par probabilité croissante
    [poids, ordre] = sort(poids);

    groupes = groupes(ordre);

    % Deux plus petites probabilités
    g1 = groupes{1};
    g2 = groupes{2};

    % Ajouter 0 au premier groupe
    for i = g1
        codes{i} = ['0' codes{i}];
    end

    % Ajouter 1 au deuxième groupe
    for i = g2
        codes{i} = ['1' codes{i}];
    end

    % Fusion
    nouveau_groupe = [g1 g2];
    nouveau_poids = poids(1) + poids(2);

    groupes = [{nouveau_groupe}, groupes(3:end)];
    poids = [nouveau_poids, poids(3:end)];

end

end