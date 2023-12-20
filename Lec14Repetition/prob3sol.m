% problem 3
close all
clear
load 2021jan_problem3.mat
N = length(y);
t = Ts*(1:N);
figure(1)
subplot(211)
plot(t,y)
hold on
subplot(212)
plot(t,u)
Ntrain = N/2;
yutrain = iddata(y(1:Ntrain),u(1:Ntrain),Ts);
yutest = iddata(y(Ntrain+1:N),u(Ntrain+1:N),Ts);

NN = [1 1 1 ; 2 2 1 ; 3 3 1; 4 4 1 ; 5 5 1 ];
V = arxstruc(yutrain,yutest,NN);
%Nbest = selstruc(V)

%%

Nbest  =[5 5 1];
arxbest = arx(yutrain,Nbest);

figure(2)
compare(yutest,arxbest);

%%
figure(3)
resid(yutest,arxbest);

%%

oe331 = oe(yutrain,[3 3 1]);
present(oe331)

figure(10)
compare(yutest,oe331)

%%

figure(11)
p = bodeoptions;
set(p,'ConfidenceRegionNumberSD',5);
h = bodeplot(oe331);
showConfidence(h)

figure(12)
resid(yutest,oe331)

figure(13)
pzmap(oe331)
% 
% %%
% %save('2021jan_problem3.mat','y','u','Ts','time')
% 
% s = tf('s')
% G1 = 0.5/((1+2*s)*(1+0.2*s))
% M1 = c2d(G1,Ts)
% G3 = 0.5/(1+0.1*s*0.5+s^2*0.5^2);
% M3 = c2d(G3,Ts);
% G4 = 0.5/((1+0.1*s*0.5+s^2*0.5^2)*(1+0.05*s*0.1+s^2*0.1^2));
% M4 = c2d(G4,Ts);
% 
% figure(20)
% w=linspace(1e-1,10*pi,10000);
% subplot(221)
% bodemag(M1,w)
% grid on
% subplot(222)
% bodemag(M,w)
% grid on
% subplot(223)
% bodemag(M3,w)
% grid on
% subplot(224)
% bodemag(M4,w)
% grid on
% 
% 
