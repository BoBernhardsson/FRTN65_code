C = [1 0.5 0];
D = [1 -1.5 0.7];
Ts = 1;
G = tf(C,D,Ts);
w1v = [];
w2v = [];

fig1 = figure(1);
lam = 1;
N = 400;
e = randn(N,1);
w = lsim(G,e);
plot(w,'linewidth',1.6)
set(gca,'fontsize',16)
fig1.Position = [520 920 794 409];
% print -depsc fig01.eps

fig2 = figure(2);
mu = 0.02;
ind = rand(N,1)<mu;    % sporadic noise
e2 = sqrt(lam/mu)*randn(N,1).*ind;  % scale amplitude so cov(e)=cov(e2)
w2 = lsim(G,e2);
plot(w2,'linewidth',1.6)
set(gca,'fontsize',16)
fig2.Position = [520 920 794 409];
% print -depsc fig02.eps
