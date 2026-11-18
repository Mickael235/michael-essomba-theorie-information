fprintf('============================================\n');
fprintf('TEST COMPLET HAMMING (7,4)\n');
fprintf('============================================\n');

nb_tests = 0;
nb_erreurs = 0;

for n = 0:15

    m = dec2bin(n,4) - '0';

    c = hamming74_encode(m);

    % Sans erreur
    [m_dec, ~, ~, ~] = hamming74_decode(c);

    nb_tests = nb_tests + 1;

    if ~isequal(m_dec,m)
        nb_erreurs = nb_erreurs + 1;
    end

    % Une erreur dans chacune des 7 positions
    for pos = 1:7

        r = c;
        r(pos) = 1-r(pos);

        [m_dec, c_corr, ~, pos_detectee] = ...
            hamming74_decode(r);

        nb_tests = nb_tests + 1;

        if ~isequal(m_dec,m) || ...
           ~isequal(c_corr,c) || ...
           pos_detectee ~= pos

            nb_erreurs = nb_erreurs + 1;
        end
    end
end

fprintf('Tests réalisés : %d\n', nb_tests);
fprintf('Tests échoués   : %d\n', nb_erreurs);

if nb_erreurs == 0
    fprintf('VALIDATION : OK\n');
else
    fprintf('VALIDATION : ECHEC\n');
end