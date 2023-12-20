% Assumes T=1
close all; clear
z = tf('z',1);
N = 256;
N = 2^10;
rng(0)
G = 0.2*(1+z^(-1))/(1-1.6*z^(-1) + 0.9*z^(-2)); % a new system
u = lsim(G,randn(N,1));
dw = 2*pi/N;
wvec = dw*(0:N/2-1);
Gw = freqresp(G,wvec);
Gw = squeeze(Gw);     % get rid of empty dimensions
figure(1)
gamma = 20;
Gest = spa(iddata(u),gamma,wvec);
spectrumplot(Gest,'b')
hold on

gamma = 500;
Phiu = spa(iddata(u),gamma,wvec);
spectrumplot(Phiu,'g')
plot(wvec,10*log10(abs(Gw.^2)),'r--')
set(gca,'fontsize',16)
xlabel('Frequency [rad/sec]')

legend('BT \gamma=20','BT \gamma=50','True spectrum','Location','best')
%print -depsc bt01.eps