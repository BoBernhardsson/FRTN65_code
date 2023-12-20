% Assumes T=1
close all
z = tf('z',1);
N = 256;
% N = 2^11;
rng(0)
e = randn(N,1);

figure(1)

d = 0.9;
%G1 = 1/(1-d*z^(-1));
G1 = (1+0.5*z^(-1))/(1-1.5*z^(-1) + 0.7*z^(-2));
u = lsim(G1,e);
UN = fft(u);
phiN = abs(UN.^2)/N;
dw = 2*pi/N;
wvec = dw*(0:N/2-1);
loglog(wvec,phiN(1:N/2),'b','linewidth',1.1)
axis([1e-2 10 1e-2 4e2])
set(gca,'fontsize',16)
xlabel('Frequency [rad/sec]')
hold on
G1w = freqresp(G1,wvec);
G1w = squeeze(G1w);     % get rid of empty dimensions
loglog(wvec,abs(G1w.^2),'r--','linewidth',2)


% Welch method. pwelch in Matlab uses scaling 1/pi compared to book
%Nw = 64;
%window = ones(1,Nw)/Nw;
window = [];
[Puu2,W] = pwelch(u,window);
loglog(W,pi*Puu2,'k-','linewidth',2)
legend('Periodogram','True spectrum','Welch''s method')