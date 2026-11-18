%% PARTIE 8 - Synthese globale du TP
% Synthese de l'apport de chaque bloc sur le TEB, le debit
% et l'occupation spectrale, avec rappel des limites de Shannon.

fprintf('\n============================================\n');
fprintf(' PARTIE 8 - SYNTHESE GLOBALE\n');
fprintf('============================================\n');

%% ---------------------------------------------------------
% 1) Codage de source
% ----------------------------------------------------------
fprintf('\n1. CODAGE DE SOURCE\n');
fprintf('Objectif principal : reduire la redondance avant transmission.\n');
fprintf('Huffman se rapproche de l''entropie de la source.\n');
fprintf('L''extension de source rapproche encore la longueur moyenne de H,\n');
fprintf('au prix d''une complexite croissante.\n');
fprintf('LZ78/gzip exploitent aussi la memoire et les repetitions du texte.\n');

%% ---------------------------------------------------------
% 2) Detecteur optimal
% ----------------------------------------------------------
fprintf('\n2. DETECTEUR OPTIMAL\n');
fprintf('L''integration exploite toute l''energie du bit.\n');
fprintf('Le TEB suit la loi theorique Q(sqrt(2Eb/N0)) sur canal AWGN.\n');
fprintf('Sans integration, le TEB est nettement plus eleve.\n');

%% ---------------------------------------------------------
% 3) Hamming C(7,4)
% ----------------------------------------------------------
R = 4/7;
cross_hamming = 5.85;
gain_hamming = 0.31;

fprintf('\n3. HAMMING C(7,4)\n');
fprintf('R = 4/7 = %.4f\n',R);
fprintf('Debit canal a debit utile constant : x7/4, soit +75 %%.\n');
fprintf('Croisement code/non-code : environ %.2f dB.\n',cross_hamming);
fprintf('Gain mesure vers TEB=1e-4 : environ %.2f dB.\n',gain_hamming);
fprintf('Le gain de fiabilite se paie par de la redondance et de la latence.\n');

%% ---------------------------------------------------------
% 4) QPSK
% ----------------------------------------------------------
fprintf('\n4. QPSK\n');
fprintf('Deux bits sont transportes par symbole.\n');
fprintf('A Eb/N0 egal, la QPSK Gray conserve un TEB proche de la BPSK.\n');
fprintf('Le mapping Gray limite les erreurs binaires pour les voisins de constellation.\n');
fprintf('A debit binaire egal, le rythme symbole est divise par deux.\n');

%% ---------------------------------------------------------
% 5) RRC / mise en forme
% ----------------------------------------------------------
fprintf('\n5. FILTRAGE RRC\n');
fprintf('Le couple RRC emission/reception forme un cosinus sureleve.\n');
fprintf('Le critere de Nyquist est respecte aux instants symboles, a la troncature pres.\n');
fprintf('alpha faible : bande plus faible, sensibilite temporelle plus forte.\n');
fprintf('alpha eleve  : bande plus large, meilleure tolerance au decalage.\n');

%% ---------------------------------------------------------
% 6) Canal a deux trajets
% ----------------------------------------------------------
fprintf('\n6. CANAL A DEUX TRAJETS\n');
fprintf('Un echo retarde introduit de l''interference entre symboles.\n');
fprintf('L''oeil se ferme et le TEB augmente.\n');
fprintf('Une egalisation devient necessaire pour compenser le canal dispersif.\n');

%% ---------------------------------------------------------
% 7) Limites de Shannon
% ----------------------------------------------------------
shannon_abs = -1.59;
shannon_R = 0.24;

fprintf('\n7. LIMITES DE SHANNON\n');
fprintf('Limite absolue : %.2f dB.\n',shannon_abs);
fprintf('Limite pour R=4/7 : environ %.2f dB.\n',shannon_R);
fprintf('Le code Hamming reste loin de ces limites, ce qui est normal pour un code court.\n');

%% ---------------------------------------------------------
% Figure 1 - Synthese des compromis
% ----------------------------------------------------------
labels = categorical({ ...
    'Codage source', ...
    'Detecteur', ...
    'Hamming', ...
    'QPSK', ...
    'RRC', ...
    '2 trajets'});

% Scores qualitatifs uniquement pour visualiser les compromis.
% 1 = faible, 2 = moyen, 3 = fort.
gain_teb   = [1 3 2 1 2 1];
gain_debit = [3 1 1 3 1 1];
gain_bande = [1 1 1 3 3 1];

figure('Name','P8 - Synthese des apports','NumberTitle','off');
bar(labels,[gain_teb(:) gain_debit(:) gain_bande(:)]);
ylabel('Impact qualitatif');
title('Synthese qualitative des apports des blocs');
legend('Fiabilite / TEB','Debit','Occupation spectrale','Location','best');
grid on;

%% ---------------------------------------------------------
% Figure 2 - Repere Shannon / Hamming
% ----------------------------------------------------------
figure('Name','P8 - Hamming et Shannon','NumberTitle','off');

x = [shannon_abs shannon_R cross_hamming];
y = [1 1 1];

stem(x,y,'filled','LineWidth',1.4);
xlim([-2.5 7]);
ylim([0 1.4]);
yticks([]);
grid on;
xlabel('E_b/N_0 (dB)');
title('Repere des limites de Shannon et du croisement Hamming');

text(shannon_abs,1.08,'Limite absolue','HorizontalAlignment','center');
text(shannon_R,0.82,'Shannon R=4/7','HorizontalAlignment','center');
text(cross_hamming,1.08,'Croisement Hamming','HorizontalAlignment','center');

%% ---------------------------------------------------------
% Conclusion
% ----------------------------------------------------------
fprintf('\n============================================\n');
fprintf(' CONCLUSION\n');
fprintf('============================================\n');
fprintf(['La chaine complete illustre un compromis permanent entre ', ...
         'fiabilite, debit, bande, complexite et latence.\n']);
fprintf(['Aucun bloc n''ameliore tous les criteres simultanement : ', ...
         'la performance globale vient de leur combinaison.\n']);
