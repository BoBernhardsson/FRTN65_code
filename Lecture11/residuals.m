close all
clear
%% Our system
rng(12); % random example
h = 1;
z = tf('z',h);
G = (z+2)/(z^6 + 0.7*z^5);
[bd,ad] = tfdata(G,'v');
sig = 1;
arxtrue = idpoly(ad,bd,1,1,1,sig,h);

N = 10000;
u = idinput(N,'rgs');
y = sim(arxtrue,u,simOptions('AddNoise',true));
traindata = iddata(y(1:N/2),u(1:N/2),h);
testdata = iddata(y(N/2+1:end),u(N/2+1:end),h)

%%
%Find best model structure
figure(1)
NN = struc(1:4,1:4,1:10);
V = arxstruc(traindata,testdata,NN);
%Nbest = selstruc(V,'mdl')
Nbest = selstruc(V) % interactive choice
arxbest = arx(traindata,Nbest)
resid(testdata,arxbest)


%% 
% Lets see what happens if we choose wrong structure

figure(2)
arx111 = arx(traindata,[1 1 1])
resid(testdata,arx111)

%%
% Coompare with the true structure
figure(3)
arx125 = arx(traindata,[1 2 5])
resid(testdata,arx125)
