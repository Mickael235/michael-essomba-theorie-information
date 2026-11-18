%% test_partie6_rrc.m - TEB = 0 SANS bruit pour porte, RRC perso, RRC 0.22, RRC 1
 bdclose all;
run('partie6_parametres.m');
build_Partie6_RRC_si_absent = ~exist('Partie6_RRC.slx','file');
if build_Partie6_RRC_si_absent, partie6_config('porte',0,0); build_Partie6_RRC; end
load_system('Partie6_RRC');

Nbits = 4e3;  variance_bruit_p6 = 0;          % sans bruit
cas = { 'porte',        0;
        'rrc',          alpha_perso;
        'rrc',          0.22;
        'rrc',          1.00 };
ok_global = true;
for c = 1:size(cas,1)
    partie6_config(cas{c,1},0,cas{c,2});
    out = sim('Partie6_RRC');
    info = en_trames(out.get('trames_info'),8);
    dec  = en_trames(out.get('trames_dec'), 8);
    cod  = en_trames(out.get('trames_cod'),14);
    dem  = en_trames(out.get('trames_dem'),14);
    [teb,n]   = teb_trames(info,dec,lag_trames);
    [tebr,~]  = teb_trames(cod,dem,lag_trames);
    ok = (teb==0) && (tebr==0) && n>0;
    ok_global = ok_global && ok;
    fprintf('%-5s alpha=%.2f : retard=%d symboles (%d trames) TEB=%g (brut %g, %d bits) -> %s\n', ...
        cas{c,1},cas{c,2},Q_symboles,lag_trames,teb,tebr,n,ternaire(ok));
    if ~ok   % diagnostic uniquement, ne masque rien
        for lg = 0:6, fprintf('    diag lag=%d : TEB=%g\n',lg,teb_trames(info,dec,lg)); end
    end
end
close_system('Partie6_RRC',0);
if ok_global, disp('RESULTAT GLOBAL : OK'); else, error('RESULTAT GLOBAL : ECHEC'); end

function t = ternaire(b), if b, t='OK'; else, t='ECHEC'; end, end

function x = en_trames(x,w)
if ndims(x)==3, x = permute(x,[3 1 2]); end
x = reshape(x,[],w);
end

function [teb,n] = teb_trames(ref,dec,lag)
M = size(dec,1);
d = dec(lag+1:M,:);  s = ref(1:M-lag,:);
n = numel(s);  teb = sum(s(:)~=d(:))/n;
end
