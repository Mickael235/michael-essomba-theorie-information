function app_tp_arborescence
% APP_TP_ARBORESCENCE
% Parcours complet du TP : Partie -> Question -> sous-etape.
% Les scripts sont dans matlab/ et les modeles Simulink dans simulink/.

appDir = fileparts(mfilename('fullpath'));
repoDir = fileparts(appDir);
matlabDir = fullfile(repoDir,'matlab');
simulinkDir = fullfile(repoDir,'simulink');

cd(repoDir);
addpath(genpath(matlabDir));
addpath(simulinkDir);

screen = get(groot,'ScreenSize');

fig = uifigure( ...
    'Name','TP - Chaine de transmission numerique', ...
    'Position',[20 40 screen(3)-40 screen(4)-100]);

main = uigridlayout(fig,[1 1]);
main.Padding = [5 5 5 5];

tg = uitabgroup(main);

build_partie('P2 - Codage source',data_p2());
build_partie('P3 - Chaine de base',data_p3());
build_partie('P4 - Hamming',data_p4());
build_partie('P5 - QPSK',data_p5());
build_partie('P6 - RRC',data_p6());
build_partie('P7 - Canal 2 trajets',data_p7());
build_partie('Synthese',data_syn());

    function build_partie(titre,D)
        t = uitab(tg,'Title',titre);
        g = uigridlayout(t,[1 2]);
        g.ColumnWidth = {300,'1x'};
        g.Padding = [10 10 10 10];

        % -------- Colonne gauche : arborescence
        left = uigridlayout(g,[2 1]);
        left.RowHeight = {28,'1x'};
        uilabel(left,'Text','Parcours du TP','FontWeight','bold','FontSize',14);

        tr = uitree(left);
        roots = unique({D.group},'stable');
        nodes = gobjects(numel(D),1);

        for r = 1:numel(roots)
            p = uitreenode(tr,'Text',roots{r},'NodeData',[]);
            idx = find(strcmp({D.group},roots{r}));
            for j = idx
                nodes(j) = uitreenode(p,'Text',D(j).label,'NodeData',j);
            end
        end
        expand(tr);

        % -------- Colonne droite
        right = uigridlayout(g,[7 1]);
        right.RowHeight = {30,55,22,22,70,90,'1x'};
        right.RowSpacing = 6;

        titleLab = uilabel(right,'Text','','FontWeight','bold','FontSize',16);
        qLab = uitextarea(right,'Editable','off','FontSize',13);
        fileLab = uilabel(right,'Text','','FontName','Courier New','FontSize',11);
        statusGrid = uigridlayout(right,[1 2]);
        statusGrid.ColumnWidth = {22,'1x'};
        statusGrid.Padding = [0 0 0 0];
        lamp = uilamp(statusGrid,'Color',[0.6 0.6 0.6]);
        statusLab = uilabel(statusGrid,'Text','Pret.');

        buttons = uigridlayout(right,[2 2]);
        buttons.ColumnWidth = {'1x','1x'};
        buttons.RowHeight = {30,30};
        buttons.RowSpacing = 5;
        buttons.ColumnSpacing = 8;
        buttons.Padding = [0 0 0 0];

        bFig = uibutton(buttons, ...
            'Text','Afficher résultat / figure', ...
            'ButtonPushedFcn',@(~,~) run_script());

        bInt = uibutton(buttons, ...
            'Text','Afficher interprétation', ...
            'ButtonPushedFcn',@(~,~) show_interp());

        bTest = uibutton(buttons, ...
            'Text','Lancer le test', ...
            'ButtonPushedFcn',@(~,~) run_test());

        bSlx = uibutton(buttons, ...
            'Text','Ouvrir Simulink', ...
            'ButtonPushedFcn',@(~,~) open_slx());
        

        out = uitextarea(right, ...
            'Editable','off', ...
            'FontName','Courier New', ...
            'FontSize',11);
        
        figPanel = uipanel(right,'Title','Figures obtenues', ...
            'FontWeight','bold');
        figGrid = uigridlayout(figPanel,[1 1]);
        figGrid.Padding = [5 5 5 5];
        figGrid.Scrollable = 'on';

        current = 1;
        tr.SelectionChangedFcn = @(src,evt) select_node(evt.SelectedNodes);
        select_index(1);

        function select_node(sel)
            if isempty(sel) || isempty(sel.NodeData), return; end
            select_index(sel.NodeData);
        end

        function select_index(k)
            current = k;
            titleLab.Text = D(k).label;
            qLab.Value = splitlines(D(k).question);
            fileLab.Text = fichiers_associes(D(k));
            statusLab.Text = 'Pret.';
            lamp.Color = [0.6 0.6 0.6];
            out.Value = {'Selectionne une action ci-dessus.'};

            bFig.Enable  = onoff(~isempty(D(k).script));
            bInt.Enable  = onoff(~isempty(D(k).interp));
            bTest.Enable = onoff(~isempty(D(k).test));
            bSlx.Enable  = onoff(~isempty(D(k).slx));
        end

        function run_script
            k = current;
            clear_gallery();
            close_external_figures();

            lamp.Color = [0.95 0.65 0.1];
            statusLab.Text = 'Execution en cours...';
            bFig.Text = 'Execution en cours...';
            out.Value = {'Execution en cours...'};
            drawnow;

            t0 = tic;
            txtRun = runbase(D(k).script);
            dt = toc(t0);

            out.Value = splitlines(txtRun);
            bFig.Text = 'Afficher resultat / figure';

            if contains(txtRun,'ERREUR')
                lamp.Color = [0.85 0.2 0.2];
                statusLab.Text = sprintf('Erreur apres %.1f s',dt);
            else
                lamp.Color = [0.2 0.7 0.3];
                statusLab.Text = sprintf('Termine en %.1f s',dt);
            end
            drawnow;

            ff = findall(groot,'Type','figure');
            ff = ff(ff ~= fig);
            show_figures(ff);
        end

        function show_interp
            out.Value = splitlines(D(current).interp);
        end

        function run_test
            lamp.Color = [0.95 0.65 0.1];
            statusLab.Text = 'Test en cours...';
            bTest.Text = 'Test en cours...';
            out.Value = {'Test en cours...'};
            drawnow;

            t0 = tic;
            txtTest = runbase(D(current).test);
            dt = toc(t0);

            out.Value = splitlines(txtTest);
            bTest.Text = 'Lancer le test';

            if contains(txtTest,'ERREUR') || contains(txtTest,'FAIL')
                lamp.Color = [0.85 0.2 0.2];
                statusLab.Text = sprintf('Test termine avec alerte en %.1f s',dt);
            else
                lamp.Color = [0.2 0.7 0.3];
                statusLab.Text = sprintf('Test termine en %.1f s',dt);
            end
        end

        function open_slx
            out.Value = splitlines(ouvrir(D(current).slx));
        end

        function close_external_figures
            ff = findall(groot,'Type','figure');
            for ii = 1:numel(ff)
                if ff(ii) ~= fig
                    try, close(ff(ii)); catch, end
                end
            end
        end

        function clear_gallery
            delete(figGrid.Children);
        end

        function show_figures(ff)
            clear_gallery();

            if isempty(ff)
                uilabel(figGrid,'Text','Aucune figure produite par ce script.', ...
                    'HorizontalAlignment','center');
                return
            end

            ff = flip(ff(:));
            n = numel(ff);

            % Galerie horizontale : 1 colonne si une figure, 2 sinon.
            ncol = min(2,n);
            nrow = ceil(n/ncol);
            figGrid.ColumnWidth = repmat({'1x'},1,ncol);
            figGrid.RowHeight = repmat({340},1,nrow);

            for jj = 1:n
                r = ceil(jj/ncol);
                c = mod(jj-1,ncol)+1;
                try
                    tmp = [tempname '.png'];
                    exportgraphics(ff(jj),tmp,'Resolution',130);

                    p = uipanel(figGrid);
                    p.Layout.Row = r;
                    p.Layout.Column = c;

                    pg = uigridlayout(p,[2 1]);
                    pg.RowHeight = {22,'1x'};
                    pg.Padding = [2 2 2 2];

                    nm = get(ff(jj),'Name');
                    if isempty(nm), nm = sprintf('Figure %d',jj); end
                    uilabel(pg,'Text',nm,'FontWeight','bold');

                    im = uiimage(pg,'ImageSource',tmp,'ScaleMethod','fit');
                    im.Layout.Row = 2;
                catch ME
                    lab = uilabel(figGrid,'Text',['Figure non importee : ' ME.message], ...
                        'WordWrap','on');
                    lab.Layout.Row = r;
                    lab.Layout.Column = c;
                end
            end

            for jj = 1:numel(ff)
                try, close(ff(jj)); catch, end
            end
        end
    end

    % ---------------- Outils portables du depot ----------------
    function out = runbase(f)
        if isempty(f), out = 'Aucun script associe.'; return; end
        if ischar(f) || isstring(f), f = cellstr(f); end

        blocs = cell(1,numel(f));
        for ii = 1:numel(f)
            fi = f{ii};
            full = fullfile(matlabDir,fi);
            if exist(full,'file') ~= 2
                blocs{ii} = ['Fichier absent : ' full];
                continue
            end
            cmd = sprintf('run(''%s'');',strrep(full,'''',''''''));
            try
                r = evalc('evalin(''base'',cmd)');
            catch ME
                r = sprintf('ERREUR dans %s :\n%s',fi,ME.message);
            end
            if isempty(r), r = [fi ' termine.']; end
            blocs{ii} = sprintf('--- %s ---\n%s',fi,r);
        end
        out = strjoin(blocs,sprintf('\n\n'));
    end

    function s = fichiers_associes(d)
        parts = {};
        if ~isempty(d.script)
            x = d.script; if ischar(x) || isstring(x), x = cellstr(x); end
            parts{end+1} = ['Script : ' strjoin(x,', ')]; %#ok<AGROW>
        end
        if ~isempty(d.test)
            x = d.test; if ischar(x) || isstring(x), x = cellstr(x); end
            parts{end+1} = ['Test : ' strjoin(x,', ')]; %#ok<AGROW>
        end
        if ~isempty(d.slx)
            parts{end+1} = ['Simulink : ' d.slx '.slx']; %#ok<AGROW>
        end
        if isempty(parts), s = 'Fichiers : aucun fichier specifique'; else, s = strjoin(parts,'   |   '); end
    end

    function out = ouvrir(m)
        if isempty(m), out = 'Aucun modele associe.'; return; end

        f = fullfile(simulinkDir,[m '.slx']);

        if exist(f,'file') ~= 2
            out = ['Modele absent : ' f];
            return
        end

        try
            open_system(f);
            out = ['Modele ouvert : ' f];
        catch ME
            out = sprintf('Impossible d''ouvrir %s :\n%s',f,ME.message);
        end
    end
end

%% =====================================================================
% DONNEES : une entree par question ou sous-etape
% ======================================================================

function D = data_p2
D = [ ...
item('2.1 Source binaire','Q1-Q2 - Source, entropie et debit', ...
'Construire la source Matlab/Simulink, verifier P(1) sur 10^5 bits, tracer H(p) et calculer le debit d''information.', ...
'partie2_source.m','','Codage_source', ...
'La frequence empirique doit rester compatible avec p1. L''entropie quantifie l''information moyenne : elle est maximale pour une source equiprobable et diminue lorsque la source devient desequilibree.'); ...

item('2.2 Huffman','Q3-Q6 - Texte et codage de Huffman', ...
'Caracteriser le texte, construire et valider Huffman, mesurer l''efficacite, le taux de compression et le cout de la table.', ...
'partie2_huffman.m','test_huffman.m','', ...
'Huffman attribue les mots les plus courts aux caracteres frequents. On valide le code par Kraft, la propriete de prefixe, H <= L < H+1 et le decodage exact ; le cout de table devient negligeable sur un texte long.'); ...

item('2.3 Extension','Q7 - Extension de source', ...
'Tracer L_k/k pour k=1..10 avec H et H+1/k, puis commenter la convergence et le cout de l''extension.', ...
'partie2_extension_memoire.m','','', ...
'L''extension permet d''approcher l''entropie meme pour une source binaire tres desequilibree. Le prix est une complexite exponentielle : l''alphabet contient 2^k blocs.'); ...

item('2.4 Memoire','Q8-Q9 - Memoire, compression et sortie Huffman', ...
'Comparer H0, Huffman, H(X1,X2)/2 et gzip sur le texte complet/5000 caracteres, puis analyser P(1) et l''entropie des paires de bits Huffman.', ...
'partie2_extension_memoire.m','','', ...
'Le texte possede de la memoire, donc H(X1,X2)/2 peut etre inferieure a H0 et gzip peut exploiter davantage de repetitions. Une bonne sortie de codage de source est presque equiprobable et faiblement redondante, ce qui justifie la source iid de la suite du TP.'); ...

item('2.5 LZ78','Q10-Q11 - Validation et convergence LZ78', ...
'Valider le codeur/decodeur sur l''exemple puis etudier le nombre de bits/symbole sur le texte et la source binaire en fonction de la longueur.', ...
'test_lz78m.m','test_lz78m.m','', ...
'LZ78 est universel : il apprend la structure sans probabilites connues a priori. Son surcout initial explique ses mauvaises performances sur les messages courts ; son interet apparait lorsque le dictionnaire devient representatif.')];
end

function D = data_p3
D = [ ...
item('3.2 CBS','Q1-Q3 - CBS : modele, TEB et capacite', ...
'Valider le canal binaire symetrique, comparer le TEB a p_e avec IC 95 %, puis tracer C=1-H(p_e) et comparer R=4/7 a C.', ...
'partie3_cbs.m','','Partie3_CBS', ...
'Le CBS inverse directement les bits avec probabilite p_e : le TEB doit donc etre compatible avec p_e. La capacite chute jusqu''a 0 pour p_e=0.5 ; une transmission fiable a rendement 4/7 n''est possible que si R<C.'); ...

item('3.2 Uniforme','Q4-Q6 - Bruit uniforme et seuil optimal', ...
'Tracer les densites, calculer P_e(s), puis confirmer le seuil optimal par simulation sur plusieurs seuils.', ...
'partie3_uniforme.m','','', ...
'Lorsque a<=A, les supports sont disjoints et une zone de seuils donne P_e=0. Pour a>A, seule la zone de recouvrement cree des erreurs ; la theorie et la simulation doivent donner le meme minimum.'); ...

item('3.2 Gaussien','Q7-Q9 - Canal gaussien et comparaison', ...
'Verifier le seuil gaussien, mesurer son gain sur s=0 puis comparer CBS, uniforme et gaussien.', ...
'partie3_gaussien.m','','', ...
'Les densites gaussiennes se recouvrent sur tout l''axe : le seuil optimal depend donc de sigma et des probabilites a priori. Le canal uniforme a au contraire un recouvrement borne, tandis que le CBS modelise directement une inversion binaire.'); ...

item('3.2 Detecteur optimal','Q10-Q12 - Detecteur optimal et courbes TEB', ...
'Construire le detecteur L echantillons/bit, verifier la variance apres integration puis comparer theorie, simulation et cas sans integration de 0 a 9 dB.', ...
'partie3_detecteur_optimal.m','','Partie3_Detecteur', ...
'L''integration coherente additionne l''energie utile tout en reduisant la variance du bruit a N0/(2Tb) : elle realise le filtre adapte. La courbe simulee suit Q(sqrt(2Eb/N0)), alors qu''un seul echantillon perd une partie importante de l''energie du bit.'); ...

item('3.2 Complement','Q13 - Bruit uniforme apres integration', ...
'Determiner qualitativement la loi du bruit apres somme/moyenne de L echantillons uniformes.', ...
'','','', ...
'La somme n''est plus uniforme : elle est triangulaire pour L=2 puis tend vers une gaussienne quand L augmente, par le theoreme central limite. Les formules obtenues avant integration ne sont donc plus directement applicables.')];
end

function D = data_p4
D = [ ...
item('4.2.1 Theorie','Q1-Q3 - Matrices, distance et syndrome', ...
'Construire G et H, verifier GH''=0, deduire dmin puis valider le codeur/decodeur avec une erreur simple aux 7 positions.', ...
'partie4_hamming_theorie.m','test_hamming74.m','', ...
'Les colonnes non nulles et distinctes de H donnent dmin=3 : une erreur est corrigeable et deux sont detectables. Le syndrome d''une erreur simple correspond directement a la colonne de H associee a sa position.'); ...

item('4.2.2 Implementation','Q4-Q5 - Registre et validation des 16 mots', ...
'Etudier le schema Unit Delay/XOR/Switch, la table d''etats pour 1011 et verifier les 16 messages face au codeur matriciel.', ...
'','run_partie4_registre.m','Partie4_Registre', ...
'Le registre a trois bascules realise la division par g(x)=1+x+x^3 sans produit matriciel. Sa validation est acquise si les 16 mots-codes produits sont identiques a la reference matricielle.'); ...

item('4.2.2 Implementation','Q6 - Decodeur Simulink', ...
'Valider le calcul du syndrome et la correction d''une erreur simple dans le modele complet.', ...
'','test_hamming74.m','Partie4_Hamming', ...
'Le decodeur calcule le syndrome, localise l''erreur puis inverse le bit correspondant avant d''extraire les quatre bits utiles. Le test exhaustif Matlab sert de reference au bloc Simulink.'); ...

item('4.2.3 Performances','Q7-Q9 - Theorie des performances', ...
'Comparer probabilite de bloc juste, approximation du TEB apres correction et energie E_c=4/7 E_b.', ...
'partie4_hamming_theorie.m','','', ...
'Hamming corrige tous les blocs contenant au plus une erreur ; a partir de deux erreurs, le decodeur peut effectuer une mauvaise correction. La comparaison doit conserver E_b d''information constant, sinon le gain du codage serait surestime.'); ...

item('4.2.4 Chaine complete','Q10-Q12 - TEB, gain, debit et latence', ...
'Comparer chaine codee/non codee sur 0..9 dB, determiner le croisement et le gain a 10^-4, puis commenter debit et latence.', ...
'partie4_hamming_performances.m','','Partie4_Hamming', ...
'Le code est penalisant a faible SNR puis devient avantageux vers 5.85 dB ; le gain mesure a 10^-4 est d''environ 0.31 dB. Ce gain s''obtient au prix d''un debit canal multiplie par 7/4 (+75 %) et d''une latence liee au traitement par blocs.')];
end

function D = data_p5
D = [ ...
item('5 QPSK','Q1-Q2 - Mapping Gray et validation QPSK', ...
'Construire le mapping Gray, montrer E_b=E_s/2 et valider modulation/demodulation sans bruit.', ...
{'partie5_qpsk_analyse.m','run_partie5_simulations.m'},'','Partie5_QPSK', ...
'Le mapping Gray rend les symboles voisins differents d''un seul bit et revient a deux BPSK independantes sur I et Q. Avec E_s=1, chaque symbole transporte deux bits donc E_b=1/2 ; la validation sans bruit doit donner un TEB nul.'); ...

item('5 QPSK','Q3 - Constellations a 0, 5 et 10 dB', ...
'Observer l''evolution des nuages de constellation lorsque E_b/N_0 augmente.', ...
'run_partie5_simulations.m','','Partie5_QPSK', ...
'A faible SNR, le bruit peut pousser des points au-dela des frontieres de decision et creer des erreurs de quadrant. Quand E_b/N_0 augmente, les quatre amas se resserrent autour des symboles ideaux.'); ...

item('5 QPSK','Q4-Q5 - Performances, debit et Gray vs naturel', ...
'Comparer QPSK a la chaine binaire puis comparer les TEB Gray et naturel.', ...
{'partie5_qpsk_analyse.m','run_partie5_simulations.m'},'','Partie5_QPSK_naturel', ...
'A E_b/N_0 egal, la QPSK Gray conserve le TEB de la BPSK tout en transportant deux bits par symbole, ce qui ameliore l''efficacite spectrale. Le mapping naturel degrade le TEB binaire car une erreur vers un symbole voisin peut modifier deux bits.'); ...

item('5 QPSK','Q6 - QPSK + Hamming', ...
'Former les couples sans bourrage et comparer les performances avec la partie 4.', ...
'run_partie5_simulations.m','','Partie5_QPSK_Hamming', ...
'Deux mots Hamming donnent 14 bits, soit exactement 7 symboles QPSK : aucun bit de bourrage n''est necessaire. A E_b d''information constant, les tendances de codage restent coherentes avec celles observees en partie 4.')];
end

function D = data_p6
D = [ ...
item('6 Mise en forme','Q1 - Filtre porte et detecteur optimal', ...
'Verifier que mise en forme porte + filtre adapte + echantillonnage reproduit le detecteur optimal et conserve le TEB.', ...
'run_partie6_simulations.m','','Partie6_RRC', ...
'La convolution emission/reception realise une integration sur la duree symbole. A l''instant d''echantillonnage optimal, cette chaine est equivalente au detecteur optimal de la partie 3 et doit conserver le meme TEB.'); ...

item('6 Mise en forme','Q2-Q4 - Filtre RRC, Nyquist et bande', ...
'Verifier les coefficients/limites du RRC, tracer h et h*h puis comparer la DSP et la bande occupee.', ...
'partie6_analyse_filtres.m','test_partie6_rrc.m','Partie6_RRC', ...
'Le RRC seul ne s''annule pas aux multiples de T, mais la cascade h*h forme un cosinus sureleve respectant le critere de Nyquist aux instants symboles, a la troncature pres. Le roll-off alpha regle le compromis entre bande occupee et robustesse temporelle.'); ...

item('6 Mise en forme','Q5-Q6 - Oeil, constellations, TEB et decalage T/4', ...
'Observer les performances a l''instant optimal puis avec un decalage T/4, et comparer alpha=0.22 a alpha=1.', ...
'run_partie6_simulations.m','','Partie6_RRC', ...
'A l''instant optimal, l''IES est minimale et les performances restent proches de la chaine precedente. Un decalage de T/4 ferme l''oeil et augmente le TEB ; alpha=1 est plus tolerant au decalage mais consomme davantage de bande.')];
end

function D = data_p7
D = [ ...
item('7 Canal a 2 trajets','Q1 - Oeil, TEB et critere de Nyquist', ...
'Etudier l''effet du canal h_c(t)=delta(t)+beta delta(t-tau) sur l''oeil et le TEB.', ...
'partie7_canal_2_trajets.m','','', ...
'Le trajet retarde ajoute une copie du symbole precedent et cree de l''interference entre symboles. L''oeil se ferme, le TEB augmente et le critere de Nyquist n''est plus respecte par la chaine globale.'); ...

item('7 Canal a 2 trajets','Q2 - Egalisation', ...
'Proposer une compensation recepteur et identifier les parametres du canal a connaitre.', ...
'partie7_canal_2_trajets.m','','', ...
'Un egaliseur zero-forcing peut inverser le canal mais amplifie le bruit ; un MMSE realise un compromis entre bruit et IES. Dans les deux cas, il faut au minimum estimer beta et tau.'); ...

item('7 Canal a 2 trajets','Q3 - Transmission d''un texte', ...
'Comparer le texte recu a 3 dB et 6 dB sans puis avec Hamming.', ...
'partie7_canal_2_trajets.m','','', ...
'A 3 dB, les erreurs binaires alterent de nombreux caracteres et le codage apporte peu sous son point de croisement. A 6 dB, les erreurs simples deviennent plus rares et Hamming peut corriger suffisamment de bits pour rendre le texte nettement plus lisible.')];
end

function D = data_syn
D = item('8 Conclusion','Synthese globale', ...
'Synthetiser l''apport de chaque bloc sur le TEB, le debit et l''occupation spectrale, puis situer les resultats par rapport a Shannon.', ...
'partie8_synthese.m','','', ...
['Le codage de source retire la redondance ; le detecteur optimal exploite toute l''energie utile ; Hamming corrige des erreurs au prix de debit et de latence ; QPSK augmente l''efficacite spectrale ; le RRC controle la bande et l''IES. ' ...
'La comparaison aux limites de Shannon rappelle enfin que ces blocs ameliorent la chaine sans atteindre la limite theorique ideale.']);
end

function s = item(group,label,question,script,test,slx,interp)
s.group = group;
s.label = label;
s.question = question;
s.script = script;
s.test = test;
s.slx = slx;
s.interp = interp;
end

function s = onoff(c)
if c, s = 'on'; else, s = 'off'; end
end
