% Assumes T=1
close all; clear
z = tf('z',1);
N = 256;
%rng(1)
e = randn(N,1);

figure(1)
subplot(221)
d = 0.9;
G1 = 1/(1-d*z^(-1));
u = lsim(G1,e);
UN = fft(u);
phiN = abs(UN.^2)/N;
dw = 2*pi/N;
wvec = dw*(0:(N-1)/2);
loglog(wvec,phiN(1:N/2),'b','linewidth',1.4)
axis([1e-2 10 1e-2 4e2])
set(gca,'fontsize',16)
xlabel('Frequency [rad/sec]')
hold on
G1w = freqresp(G1,wvec);
G1w = squeeze(G1w);     % get rid of empty dimensions
loglog(wvec,abs(G1w.^2),'r--','linewidth',2)
legend('Periodogram','True spectrum')

subplot(222)
d = -0.9;
G2 = 1/(1-d*z^(-1));
u = lsim(G2,e);
UN = fft(u);
phiN = abs(UN.^2)/N;
dw = 2*pi/N;
wvec = dw*(0:(N-1)/2);
loglog(wvec,phiN(1:N/2),'b','linewidth',1.4)
axis([1e-2 10 1e-2 4e2])
set(gca,'fontsize',16)
xlabel('Frequency [rad/sec]')
hold on
G2w = freqresp(G2,wvec);
G2w = squeeze(G2w);     % get rid of empty dimensions
loglog(wvec,abs(G2w.^2),'r--','linewidth',2)
legend('Periodogram','True spectrum')

subplot(223)
G3 = (1+0.5*z^(-1))/(1-1.5*z^(-1) + 0.7*z^(-2));
u = lsim(G3,e);
UN = fft(u);
phiN = abs(UN.^2)/N;
dw = 2*pi/N;
wvec = dw*(0:(N-1)/2);
loglog(wvec,phiN(1:N/2),'b','linewidth',1.4)
axis([1e-2 10 1e-2 4e2])
set(gca,'fontsize',16)
xlabel('Frequency [rad/sec]')
hold on
G3w = freqresp(G3,wvec);
G3w = squeeze(G3w);     % get rid of empty dimensions
loglog(wvec,abs(G3w.^2),'r--','linewidth',2)
legend('Periodogram','True spectrum')


subplot(224)
mu = 0.02;
ind = rand(N,1)<mu;    % sporadic noise
e = sqrt(1/mu)*randn(N,1).*ind;
u = lsim(G3,e);
UN = fft(u);
phiN = abs(UN.^2)/N;
dw = 2*pi/N;
wvec = dw*(0:(N-1)/2);
loglog(wvec,phiN(1:N/2),'b','linewidth',1.4)
axis([1e-2 10 1e-2 4e2])
set(gca,'fontsize',16)
xlabel('Frequency [rad/sec]')
hold on
loglog(wvec,abs(G3w.^2),'r--','linewidth',2)
legend('Periodogram','True spectrum')

%print -depsc periodogram01.eps

