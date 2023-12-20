% Generate data 
close all; clear
s=tf('s');
G = 1/(s^2+2*s+4);
h = 0.1;
Gd = c2d(G,h)
N = 1000;
frequencies = [0 0.05];
u = idinput(N,'rbs',frequencies);
[y,t] = lsim(Gd,u);
noiselevel = 0.05*std(y);
e = noiselevel*randn(N,1);
yn = y + e;

figure(2)
subplot(211)
plot(t,yn,'r',t,y,'b','linewidth',2)
subplot(212)
plot(t,u,'linewidth',2)
axis([0 100 -1.5 1.5])
print -depsc ident01a.eps

noisydata = iddata(yn,u,h);
noisefreedata = iddata(y,u,h);

% Identify a model on noisefree data
% model_oe = oe(noisefreedata,[2 2 1])
% model_arx = arx(noisefreedata,[2 2 1])
% model_armax = armax(noisefreedata,[2 2 2 1])
% model_bj = bj(noisefreedata,[2 2 2 2 1])
%present(model1)

% % Identify a model noisy data
 model_oe = oe(noisydata,[2 2 1])
 model_arx = arx(noisydata,[2 2 1])
 model_armax = armax(noisydata,[2 2 2 1])
 model_bj = bj(noisydata,[2 2 2 2 1])
% %present(model1)

% Validate model on noisyfree data
figure(3)
horizon = inf;    % Try varying this, i.e. horizon = inf
compare(noisefreedata,model_oe,model_arx,model_armax,model_bj,horizon)
fixfig
%print -depsc ident01b.eps

% Validate model on noisy data

figure(4)
horizon = inf;
compare(noisydata,model_oe,model_arx,model_armax,model_bj,horizon)
fixfig
%print -depsc ident01c.eps

% Validate model on noisy data
horizon = 1;
figure(5)
compare(noisydata,model_oe,model_arx,model_armax,model_bj,horizon)
fixfig
%print -depsc ident01d.eps


%%%%%%%%%%%%

figure(6)
%P = bodeoptions;
%P.FreqUnits = 'Hz'
bode(Gd,'b-')
fixfig
%print -depsc ident01_bode.eps

hold on
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_oe);
bode(tf(B,F,0.1),'g--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_arx);
bode(tf(B,A,0.1),'r--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_armax);
bode(tf(B,A,0.1),'k--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_bj);
bode(tf(B,F,0.1),'y--')
legend('true system','OE','ARX','ARMAX','BJ','Linewidth',2,'Location','West')
fixfig
%print -depsc ident01_bodeG.eps

%%%%%%%%%%%%

figure(7)
bode(tf(1,1),'b')
hold on
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_oe);
bode(tf(C,D,0.1),'g--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_arx);
bode(tf(1,A,0.1),'r--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_armax);
bode(tf(C,A,0.1),'k--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_bj);
bode(tf(C,D,0.1),'y--')
legend('true system','OE','ARX','ARMAX','BJ','Linewidth',2,'Location','SouthWest')
fixfig
%print -depsc ident01_bodeH.eps

