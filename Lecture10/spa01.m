close all; clear
z = tf('z',1);
N = 2^13;
rng(0)
G = 0.15*(1+z^(-1))/(1-1.6*z^(-1) + 0.9*z^(-2)); 
dw = 2*pi/N;
wvec = logspace(-2,0.5,1000);
Gw = squeeze(freqresp(G,wvec));

H = (1-0.6)/(1-0.6*z^(-1));
e = randn(N,1);
v = lsim(H,e);
Hw = squeeze(freqresp(H,wvec));
H2w = abs(Hw).^2;

u = idinput(N,'rbs',[0 1]);
x = lsim(G,u);
y = x + v;


figure(1)
Nplot = 200;
subplot(211)
plot(x(1:Nplot),'b')
axis([0 Nplot -3 3])
set(gca,'fontsize',16)
ylabel('Gu and Gu + v') 
hold on
plot(y(1:Nplot),'r')
subplot(212)
plot(u(1:Nplot))
axis([0 Nplot -1.2 1.2])
xlabel('Time')
ylabel('u')
set(gca,'fontsize',16)

figure(2)
data = iddata(y,u,1);
gamma = 400;     % Try different values here
Gest = spa(data,gamma,wvec);  % main function
bode(G,Gest,wvec)
h = gcf;
h.Children(3).YLim = [-50 20];
grid on

figure(3)
H2est = squeeze(get(Gest,'SpectrumData'));
loglog(wvec,H2est,'r')
axis([1e-2 pi 1e-2 2])
hold on
loglog(wvec,H2w,'b')
set(gca,'fontsize',16)
grid on
legend('Estimated noise spectrum |H_{est}|^2 ', 'True noise spectrum |H|^2','Location','best')
