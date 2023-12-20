clear; close all

%% Parameters
N = 100;
Tmax = 100000;
k = 0.1;

%% Create system
% Note: This rod is NOT insulated at ends
% Heat transfer to surrounding room, which has temperature zero

D2 = -2*eye(N) + diag(ones(N-1,1),1) + diag(ones(N-1,1),-1);
D2(1,1)=-1;
A = eye(N) + k*D2;
B = zeros(N,1);B(1)=k;
C = zeros(1,N);C(N/2)=1;
D = 0;

G = ss(A,B,C,D,1);
[Gbal,sig] = balreal(G);

figure(1)
[y,t,x] = step(G,0:Tmax);
plot(t,y,'b','linewidth',2);
hold on
set(gca,'fontsize',16)
grid on

figure(2)
[mag1,phase1,w1] = bode(G,{1e-7 1});
mag1 = squeeze(mag1); phase1 = squeeze(phase1);
subplot(211)
loglog(w1,mag1,'b','linewidth',2)
hold on; grid on
subplot(212)
semilogx(w1,phase1,'b','linewidth',2)
hold on; grid on

for threshold = [1e-1 1e-2 1e-4]
    elim = (sig < threshold*sig(1));         % small entries of sig -> negligible states
    Ghat = modred(Gbal,elim);
    tf(Ghat)

    figure(1)
    [yh,t] = step(Ghat,0:Tmax);
    plot(t,yh,'--','linewidth',1.4);

    figure(2)
    subplot(211)
    [mag2,phase2,w2] = bode(Ghat,w1);
    mag2 = squeeze(mag2); phase2 = squeeze(phase2);
    loglog(w2,mag2,'--','linewidth',1.4)
    axis([1e-5 1 1e-4 1e2])
    set(gca,'fontsize',16)
    subplot(212)
    loglog(w2,phase2-phase2(1),'--','linewidth',1.4)
    axis([1e-5 1 -700 20])
    set(gca,'fontsize',16)
 
end

figure(1)
legend('order 100','order 1','order 2','order 5','Location','best')
title('Step Response','fontsize',18)
xlabel('Time','fontsize',18)

figure(2)
legend('order 100','order 1','order 2','order 5','Location','best')
title('Bode diagram','fontsize',18)
xlabel('Frequency','fontsize',18)

figure(3)
semilogy(sig,'-x')
set(gca,'fontsize',16)
axis([0 100 1e-15 1e2])
grid on


