close all
%
clear
%% Our system
h = 0.1;
s=tf('s');
z = tf('z',h);
w0 = 1;
zeta0 = 0.05;
w1 = 4;
zeta1 = 0.1;
T = 6;
G = (s^2+ + 2*zeta0*w0*s + w0^2)/w0^2*w1^2/(s^2+zeta1*w1^2*s+w1^2)/(1+s*T);

%G = (w0^2)/w0^2*w1^2/(s^2+zeta1*w1^2*s+w1^2)/(1+s*T);

%G = 1/(1+s*T)   % neglecting the resonance

Gd = c2d(G,h)
[bd,ad] = tfdata(Gd,'v')

%%
figure(1)
bode(G,Gd)
legend('G','Gd')
hold on
grid on

% print -depsc robotarm01.eps

figure(2)
step(G,30)
hold on
step(Gd,30)
grid on


%%
% Identification
figure(3)
Tsimu = 1000;
N = Tsimu / h;
u = idinput(N,'rbs',[0 0.3]);
x = lsim(Gd,u);
noiselevel = 0.1;   % change noise level here 
y = x + noiselevel*std(x)*randn(N,1);

% Use this code if you want to simulate with a true system of ARX structure
% arxtrue = idpoly(ad,bd,1,1,1,0.01,h);
% y = sim(arxtrue,u,simOptions('AddNoise',true));

% Split data into train and test 
ytrain = y(1:N/2);
utrain = u(1:N/2);
ytest = y(N/2+1:end);
utest = u(N/2+1:end);
ztrain = iddata(ytrain,utrain,h);
ztest = iddata(ytest,utest,h);

T1 = (1:100)';
subplot(211)
plot(h*(T1-1),x(T1),'b')
hold on
plot(h*(T1-1),y(T1),'r')
subplot(212)
plot(h*(T1-1),u(T1),'k')

%%
% arxstruc(ZE, ZV, NN)

NN = [1 1 1 ; 2 2 1 ; 3 3 1; 4 4 1 ; 5 5 1 ; 6 6 1 ; 7 7 1; 8 8 1; 9 9 1; 10 10 1; 11 11 1; 12 12 1; 13 13 1; 14 14 1; 15 15 1];
V = arxstruc(ztrain,ztest,NN);
Nbest = selstruc(V)

%%
arx3 = arx(ztrain,[3 3 1]);
arx9 = arx(ztrain,[9 9 1]);
arx15 = arx(ztrain,[15 15 1]);
figure(4)
h4 = bodeplot(Gd,arx3,arx9,arx15);
setoptions(h4,'FreqUnits','Hz','MagScale','log','MagUnits','Abs');
legend('Gd(true)','arx3','arx9','arx15');
fixfig


%%
figure(5)
oe3 = oe(ztrain,[3 3 1])
h5 = bodeplot(Gd,oe3);

%%
figure(6)
[ypred50, FIT, X0] = compare(ztest, oe3, Inf);

%%
subplot(211)
plot(h*(1:200)',ytest(1:200),'b-')
hold on
plot(h*(1:200)',ypred50.OutputData(1:200),'r-')
legend('ytest','ypred50','Location','best')
subplot(212)
plot(h*(1:200)',utest(1:200),'b-')









