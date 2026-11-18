%% PARTIE 3.3 - Canal gaussien (Q7 à Q9)
run('partie3_parametres.m');

%% Q7 - Seuil optimal et Pe(s)
s_opt = (sigma^2/(2*A))*log(p0/p1);
s = linspace(-0.5,0.5,101);
Pe_theo = p0.*Q((s+A)/sigma) + p1.*Q((A-s)/sigma);

fprintf('Seuil optimal théorique : %.4f\n',s_opt);
fprintf('Pe(s*) : %.6f\n',p0*Q((s_opt+A)/sigma)+p1*Q((A-s_opt)/sigma));

%% Q8 - Simulation
Nsim = 1e5;
rng(graine);
bits = source(Nsim,p1);
x = A*(2*bits-1);
y = x + sigma*randn(1,Nsim);

Pe_sim = zeros(size(s));
for k=1:numel(s)
    Pe_sim(k)=mean(double(y>s(k))~=bits);
end

[Pe_min,idx] = min(Pe_sim);
Pe_s0 = mean(double(y>0)~=bits);

fprintf('Seuil optimal simulé    : %.4f\n',s(idx));
fprintf('Pe minimal simulé       : %.6f\n',Pe_min);
fprintf('Pe simulé pour s=0      : %.6f\n',Pe_s0);
fprintf('Gain relatif            : %.2f %%\n',100*(Pe_s0-Pe_min)/Pe_s0);

figure;
plot(s,Pe_theo,'LineWidth',1.4); hold on;
plot(s,Pe_sim,'o','MarkerSize',4);
xline(s_opt,'--');
xline(0,':');
grid on;
xlabel('Seuil s'); ylabel('P_e');
title('Canal gaussien : théorie et simulation');
legend('Théorie','Simulation','s^*','s=0','Location','best');

%% Q9
fprintf(['Q9 : le CBS impose directement une probabilité d''inversion ; ', ...
    'le canal uniforme possède une zone de recouvrement à vraisemblances égales ; ', ...
    'le canal gaussien dépend de sigma car ses densités se recouvrent partout.\n']);
