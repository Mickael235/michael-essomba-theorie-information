%% PARTIE 3.2 - Canal à bruit uniforme (Q4 à Q6)
run('partie3_parametres.m');

a = a_unif;
r = linspace(-A-a-0.5,A+a+0.5,2000);

%% Q4 - Densités et seuil optimal
f0 = zeros(size(r));
f1 = zeros(size(r));
f0(r>=-A-a & r<=-A+a) = 1/(2*a);
f1(r>= A-a & r<= A+a) = 1/(2*a);

figure('Name','P3 - Uniforme densités');
plot(r,f0,'LineWidth',1.4); hold on;
plot(r,f1,'LineWidth',1.4);
grid on;
xlabel('r'); ylabel('Densité');
title('Canal uniforme : densités conditionnelles');
legend('f(r|0)','f(r|1)','Location','best');

if a<=A
    s_opt = 0;
elseif p0>p1
    s_opt = a-A;
elseif p1>p0
    s_opt = A-a;
else
    s_opt = 0;
end

fprintf('Seuil optimal choisi : %.4f\n',s_opt);

%% Q5-Q6 - Théorie et simulation selon le seuil
Nsim = 1e5;
seuils = linspace(-1.5,1.5,61);
Pe_sim = zeros(size(seuils));
Pe_theo = zeros(size(seuils));

rng(graine);
bits = source(Nsim,p1);
x = A*(2*bits-1);
y = x + (-a + 2*a*rand(1,Nsim));

for k=1:numel(seuils)
    s = seuils(k);
    Pe_sim(k) = mean(double(y>s)~=bits);

    if s < -A-a
        Pe_theo(k)=p0;
    elseif s < A-a
        Pe_theo(k)=p0*(-A+a-s)/(2*a);
    elseif s <= a-A
        Pe_theo(k)=p0*(a-A-s)/(2*a)+p1*(a-A+s)/(2*a);
    elseif s <= A+a
        Pe_theo(k)=p1*(s-A+a)/(2*a);
    else
        Pe_theo(k)=p1;
    end
end

[Pe_min,idx] = min(Pe_sim);
fprintf('Seuil simulé : %.4f | Pe min : %.4f\n',seuils(idx),Pe_min);

figure('Name','P3 - Uniforme Pe');
plot(seuils,Pe_theo,'LineWidth',1.4); hold on;
plot(seuils,Pe_sim,'o','MarkerSize',4);
xline(s_opt,'--');
grid on;
xlabel('Seuil s'); ylabel('P_e');
title('Canal uniforme : théorie et simulation');
legend('Théorie','Simulation','Seuil optimal','Location','best');
