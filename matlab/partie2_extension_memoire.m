%% PARTIE 2.3-2.4 - Extension, mémoire et compresseurs (Q7 à Q9)

P = parametres_perso('Essomba Michael');

%% Q7 - Extension de source
p1 = P.p1_ext;
p0 = 1-p1;
H = -p1*log2(p1)-p0*log2(p0);

Nbits = 1e5;
rng(P.graine);
bits = double(rand(1,Nbits)<p1);

kvals = 1:10;
Lth = zeros(size(kvals));
Lsim = zeros(size(kvals));

for k = kvals
    nb = 2^k;
    prob = zeros(1,nb);
    for n = 0:nb-1
        b = dec2bin(n,k)-'0';
        w = sum(b);
        prob(n+1) = p1^w*p0^(k-w);
    end

    codes = huffman_perso(prob);
    lg = cellfun(@length,codes);
    Lth(k) = sum(prob.*lg)/k;

    Nu = floor(Nbits/k)*k;
    blocs = reshape(bits(1:Nu),k,[])';
    idx = blocs*(2.^(k-1:-1:0))'+1;
    Lsim(k) = sum(lg(idx))/Nu;
end

figure('Name','P2 - Extension Huffman');
plot(kvals,Lth,'o-',kvals,Lsim,'x-','LineWidth',1.3); hold on;
yline(H,'--');
plot(kvals,H+1./kvals,'s-');
grid on;
xlabel('k'); ylabel('bits/bit source');
title('Extension de source - Huffman');
legend('Théorie','Simulation','H','H+1/k','Location','best');

%% Q8-Q9 - Mémoire et bits Huffman
fichier = 'Projet_guttenberg_Le Fantôme de lOpéra.txt';
texte = fileread(fichier);
N = length(texte);

symboles = unique(texte);
freq = zeros(1,numel(symboles));
for i=1:numel(symboles)
    freq(i)=mean(texte==symboles(i));
end

H0 = entropie_empirique(texte);
Hpaires = entropie_paire(texte);
codes = huffman_perso(freq);
lg = cellfun(@length,codes);
Lhuff = sum(freq.*lg);

gzip(fichier);
info = dir([fichier '.gz']);
Lgzip = 8*info.bytes/N;

texte_court = texte(1:min(5000,N));
H0c = entropie_empirique(texte_court);
Hpc = entropie_paire(texte_court);

symc = unique(texte_court);
fc = zeros(1,numel(symc));
for i=1:numel(symc)
    fc(i)=mean(texte_court==symc(i));
end
cc = huffman_perso(fc);
Lhc = sum(fc.*cellfun(@length,cc));

fid=fopen('texte_5000.txt','w','n','UTF-8');
fwrite(fid,texte_court,'char'); fclose(fid);
gzip('texte_5000.txt');
ic=dir('texte_5000.txt.gz');
Lgc=8*ic.bytes/length(texte_court);

fprintf('\nMéthode              Complet      5000\n');
fprintf('Entropie ordre 0     %.4f      %.4f\n',H0,H0c);
fprintf('Huffman              %.4f      %.4f\n',Lhuff,Lhc);
fprintf('H(X1,X2)/2           %.4f      %.4f\n',Hpaires,Hpc);
fprintf('gzip                 %.4f      %.4f\n',Lgzip,Lgc);

[~,idx] = ismember(texte,symboles);
bits_h = [codes{idx}];
b = bits_h-'0';
p1h = mean(b);
paires = 2*b(1:end-1)+b(2:end);
occ = histcounts(paires,-0.5:1:3.5);
pp = occ/sum(occ);
Hbits = -sum(pp(pp>0).*log2(pp(pp>0)))/2;

fprintf('\nSortie Huffman : P(1)=%.4f, H paire/bit=%.4f\n',p1h,Hbits);

methodes = { ...
    'Entropie ordre 0', ...
    'Huffman', ...
    'H(X1,X2)/2', ...
    'gzip'};

valeurs = [ ...
    H0 H0c;
    Lhuff Lhc;
    Hpaires Hpc;
    Lgzip Lgc];

figure('Name','P2 - Compression');
bar(valeurs);

xticks(1:4);
xticklabels(methodes);

ylabel('bits / caractere');
title('P2 - Comparaison des methodes de compression');
legend('Texte complet','5000 caracteres','Location','best');
grid on;
