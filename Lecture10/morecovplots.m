close all

maxlag = 20;
tauv = -maxlag:maxlag;


figure(1)
subplot(221)
d = -0.9;
c0 = 1;
c1 = 0;
G = tf([c0 c1],[1 d],1);
Rw = 1./(1-d.^2)*(-d).^(abs(tauv));
plot(tauv,Rw,'b','linewidth',2)
set(gca,'fontsize',16)
ylabel('R_w(\tau)')
v = axis;
hold on


subplot(222)
d = 0.9;  
c0 = 1;
c1 = 0;
G = tf([c0 c1],[1 d],1);
Rw = 1./(1-d.^2)*(-d).^(abs(tauv));
plot(tauv,Rw,'b','linewidth',2)
set(gca,'fontsize',16)
ylabel('R_w(\tau)')
axis([-20 20 -6 6])
hold on

subplot(223)
d1 = -1.5;
d2 = 0.7;
c0 = 1;
c1 = 0.5;
c2 = 0;
G = tf([c0 c1 c2],[1 d1 d2],1);
h = impulse(G);
[Rw,lags]=xcov(h,20,'none');
plot(lags,Rw,'b','linewidth',2);
e = randn(1000000,1);
w = lsim(G,e);
mean(w.^2)
set(gca,'fontsize',16)
xlabel('lag \tau')
ylabel('R_w(\tau)')
hold on


subplot(224)
plot(lags,Rw,'b','linewidth',2);
set(gca,'fontsize',16)
xlabel('lag \tau')
ylabel('R_w(\tau)')
hold on

%print -depsc morecovplots.eps