close all
clear
a = -0.96;
b = 1;
mu = 1;
lam = 2;
N = 1000;  % nr of data in each test
M = 10000;  % nr of tests
ahat = zeros(M,1);
bhat = ahat;
y = zeros(N,1);
for iter = 1:M
    u = sqrt(mu)*randn(N,1);
    e = sqrt(lam)*randn(N,1);
    y(1) = e(1);
    for t = 2:N
        y(t) = -a*y(t-1) + b*u(t-1) + e(t);
    end
    Y = y(2:N);
    Phi = [-y(1:N-1) u(1:N-1)];
    thetaN = Phi\Y;
    ahat(iter) = thetaN(1);
    bhat(iter) =  thetaN(2);
end
    
figure(1)
subplot(211)
hist(ahat,100)
title('Histogram for $\hat a_N$','interpreter','latex','fontsize',16)
subplot(212)
hist(bhat,100)
title('Histogram for $\hat b_N$','interpreter','latex','fontsize',16)
% print -depsc arxfig.eps

cova = cov(ahat)
cova_formula = (1-a^2)*lam/(mu+lam)/N    % 1-a^2
covb = cov(bhat)
covb_formula = lam/mu/N

figure(2)
plot(ahat,bhat,'.')
xlabel('$\hat{a}$','Interpreter','latex','FontSize',24)
ylabel('$\hat{b}$','Interpreter','latex','FontSize',24)
set(gca,'FontSize',20)
grid on
%fixfig
