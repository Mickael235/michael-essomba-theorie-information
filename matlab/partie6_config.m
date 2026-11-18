function partie6_config(type_filtre, decal, alpha_val)
%PARTIE6_CONFIG Filtres, retard et phase d'échantillonnage (workspace de base).
%   type_filtre : 'porte' ou 'rrc'
%   decal       : décalage de l'instant d'échantillonnage, en échantillons
%                 (0 = optimal, round(L/4) = T/4). Doit vérifier 0 <= decal < L.
%   alpha_val   : roll-off du RRC (ignoré pour la porte)
%
% Retard : le signal émis pour le symbole m passe par deux filtres de N
% échantillons ; le maximum de h*h est à l'indice m*L + (N-1), décalé de 'decal'.
%   S = (N-1) + decal
% Le Buffer 7 doit retrouver les frontières des mots Hamming : le retard total
% doit valoir Q symboles avec Q multiple de 7 (et D >= 1 pour le bloc Delay) :
%   Q = 7*ceil((S+1)/(7L)),  D = Q*L - S  (échantillons de Delay avant le Downsample)
% Latence en trames de 8 Tb : lag_trames = Q/7 + 1 (+1 : trame initiale du Buffer).
g = @(n) evalin('base',n);
L = g('L'); span = g('span');
assert(decal >= 0 && decal < L, 'decal doit etre dans [0, L-1]');

switch lower(type_filtre)
    case 'porte', h_tx = ones(1,L)/sqrt(L);
    case 'rrc',   h_tx = rrc_perso(alpha_val, L, span);
    otherwise,    error('Filtre inconnu : %s', type_filtre);
end
h_rx = fliplr(h_tx);                    % filtre adapté

N = numel(h_tx);
S = (N-1) + decal;                      % retard emission+reception+decalage
Q = 7*ceil((S+1)/(7*L));
D_ech = Q*L - S;
lag_trames = Q/7 + 1;

v = {'h_tx',h_tx; 'h_rx',h_rx; 'S_ech',S; 'Q_symboles',Q; 'D_ech',D_ech; ...
     'lag_trames',lag_trames; 'filtre_type',type_filtre; ...
     'alpha_rrc',alpha_val; 'decalage_echantillons',decal};
for k = 1:size(v,1), assignin('base',v{k,1},v{k,2}); end
end
