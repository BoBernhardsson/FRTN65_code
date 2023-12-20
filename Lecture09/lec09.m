close all; 
clear
s=tf('s')
G1 = 3/(s^2+s+1)
G1d = c2d(G1,0.1)
z = tf('z',0.1)
G2d = z/(z^2+0.5*z+0.8)

[A,B,C,D]=ssdata(G1)
[n,d]=tfdata(G2d,'v')
% [z,p,k]=zpkdata(G1,'v')

%% -----------------------------------
% lsim
h = 0.1;
t = 0:h:20;
u = (t>3) + (t>6);
[y,t] = lsim(G1,u,t);
plot(t,u,t,y)

% step, impulse
% fixfig


%% -----------------------------------
% idinput
% iddata
N = 1000;
frequencies = [0 0.02];
u = idinput(N,'rbs',frequencies);
[y,t] = lsim(G1d,u);
Hd = z^2/(z^2-z+0.25);       
w = lsim(Hd,randn(N,1)); 
noiselevel = 1;
bias = 0;   % try changing this later
yn = y + noiselevel*std(y)/std(w)*w + bias;

%yn = y +randn(N,1);

figure(2)
subplot(211)
plot(t,y,t,yn)
subplot(212)
plot(t,u)

noisefreedata = iddata(y,u,h);
noisydata = iddata(yn,u,h);

%% -----------------------------------

model_oe = oe(noisefreedata,[2 2 1])
model_arx = arx(noisefreedata,[2 2 1])
model_armax = armax(noisefreedata,[2 2 2 1])
model_bj = bj(noisefreedata,[2 2 2 2 1])


model_oe = oe(noisydata,[2 2 1])
model_arx = arx(noisydata,[2 2 1])
model_armax = armax(noisydata,[2 2 2 1])
model_bj = bj(noisydata,[2 2 2 2 1])


%% -----------------------------------
% present
% compare
% polydata

present(model_bj)


%The fit is calculated as:
%          FIT = 100 * (1-norm(Y-YHAT)/norm(Y-mean(Y))) (in %)


% Validate model on noisefree data
figure(3)
horizon = inf;    % Try varying this, i.e. horizon = 10
compare(noisefreedata,model_oe,model_arx,model_armax,model_bj,horizon)
fixfig

[A,B,C,D,F]=polydata(model_bj)


%% -----------------------------------
%bodeoptions

figure(4)
P = bodeoptions;
P.FreqUnits = 'Hz';
bode(G1d,'b-',P)
fixfig
hold on
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_oe);
bode(tf(B,F,0.1),'g--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_arx);
bode(tf(B,A,0.1),'r--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_armax);
bode(tf(B,A,0.1),'k--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_bj);
bode(tf(B,F,0.1),'y--')
legend('true system G1d','OE','ARX','ARMAX','BJ','Linewidth',2,'Location','West')
fixfig

%% -----------------------------------
figure(5)
%bode(tf(1,1),'b')
bode(Hd,'b')
hold on
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_oe);
bode(tf(C,D,0.1),'g--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_arx);
bode(tf(1,A,0.1),'r--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_armax);
bode(tf(C,A,0.1),'k--')
[A,B,C,D,F,dA,dB,dC,dD,dF] = polydata(model_bj);
bode(tf(C,D,0.1),'y--')
legend('true system Hd','OE','ARX','ARMAX','BJ','Linewidth',2,'Location','SouthWest')
fixfig

%[MAG,PHASE] = bode(SYS,W)

%%
figure(6)

h = bodeplot(G1d,model_bj); % try also model_arx 
hold on
showConfidence(h,2) % plots confidence regions (but assumes correct model structure!)

%%

figure(7)
h = iopzplot(model_oe);
showConfidence(h,2)
% hold on; 
% iopzplot(G1d)
% axis([0.8 1 -0.1 0.1])
%%

figure(8)

simsd(model_bj,u)

%% -----------------------------------
% help ident
% print -depsc nicefigure03.eps
% systemIdentification