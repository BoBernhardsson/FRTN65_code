close all
N = 2^10;
fs = 100;
dt = 1/fs;
df = fs/N;
f = 10;
f = round(f/df)*df    % no spectral leakage
t = dt*(1:N);
x = sin(2*pi*f*t);
X = dt * fft(x);

figure(1)
h = gcf;
h.Position = [514 463 927 302];
subplot(121)
semilogy(0:N-1,abs(X),'b','linewidth',1.6)
hold on
set(gca,'fontsize',16)
axis([0 N-1 1e-4 7])
grid on
title('semilogy(0:N-1,abs(X))')
xlabel('Frequency Index n = 0..N-1')


subplot(122)
fvec = (-N/2+1:N/2)*df;
semilogy(fvec,fftshift(abs(X)),'b','linewidth',1.6)
hold on
set(gca,'fontsize',16)
set(gca,'XTick',-50:10:50)
grid on
title('semilogy(fvec,fftshift(abs(X)))')
xlabel('Frequency [Hz]')
axis([-50 50 1e-4 7])

%print -depsc spec02.eps