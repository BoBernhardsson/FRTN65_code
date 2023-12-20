close all
d = 0;    % change here between white noise (d=0) 
d = 0.9;  % and first order system (d=0.9)
G = tf([1 0],[1 -d],1);

figure(1)
maxlag = 20;
tauv = -maxlag:maxlag;
Rw = 1./(1-d.^2)*d.^(abs(tauv));
plot(tauv,Rw,'b','linewidth',2)
set(gca,'fontsize',16)
xlabel('lag \tau')
ylabel('R_w(\tau)')
hold on
%print -depsc covplot01.eps

rng(42)
N = 500;
for iter = 1:5
  e = randn(N,1);
  w = lsim(G,e);
  cov(w)
  1/(1-d^2)
  R = xcov(w,maxlag,'unbiased');
  hold on
  plot(tauv,R,'r-')
  text(10,1,['N= ' num2str(N)],'fontsize',20)
end
%print -depsc covplot03a.eps

figure(2)
plot(tauv,Rw,'b','linewidth',2)
set(gca,'fontsize',16)
xlabel('lag \tau')
ylabel('R_w(\tau)')
hold on
N = 50000;
for iter = 1:5
  e = randn(N,1);
  w = lsim(G,e);
  cov(w)
  1/(1-d^2)
  R = xcov(w,maxlag,'unbiased');
  hold on
  plot(tauv,R,'r-')
  text(10,1,['N= ' num2str(N)],'fontsize',20)
end
%print -depsc covplot03b.eps
