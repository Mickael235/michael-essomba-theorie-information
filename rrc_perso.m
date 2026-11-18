function h = rrc_perso(alpha,L,span)
% Coefficients d'un filtre racine de cosinus sureleve normalise en energie.

t = -span/2:1/L:span/2;
h = zeros(size(t));

for k = 1:numel(t)
    x = t(k);

    if abs(x) < 1e-12
        h(k) = 1-alpha+4*alpha/pi;

    elseif alpha > 0 && abs(abs(x)-1/(4*alpha)) < 1e-10
        h(k) = alpha/sqrt(2) * ...
            ((1+2/pi)*sin(pi/(4*alpha)) + ...
             (1-2/pi)*cos(pi/(4*alpha)));

    else
        num = sin(pi*x*(1-alpha)) + ...
              4*alpha*x*cos(pi*x*(1+alpha));
        den = pi*x*(1-(4*alpha*x)^2);
        h(k) = num/den;
    end
end

h = h/sqrt(sum(h.^2));
end
