function bits = source(N,p1)
%SOURCE Génère N bits indépendants avec P(bit=1)=p1.
bits = double(rand(1,N) < p1);
end
