% problem 3
close all
clear
rng(0)
Ts = 0.1;
z = tf('z',Ts)
B = [0 0.4 0.1 -0.2];
F = [1 -1.4 1.28 -0.33];
NoiseVariance = 0.01;
M = idpoly(1,B,1,1,F,NoiseVariance,Ts)
andre = idpoly(1,[0 0.5095 0.04778],1,1,[1 -1.053 0.917],NoiseVariance,Ts);

%figure(1)
%bodeplot(M)
%grid 
%shg

N = 1000;
time = (1:N)*Ts;
u = idinput(N,'rbs',[0 0.1]);
y = sim(M,u,simOptions('AddNoise',true));
%figure(2)
%subplot(211)
%plot(t,y)
%hold on
%subplot(212)
%plot(t,u)
Ntrain = N/2;
yutrain = iddata(y(1:Ntrain),u(1:Ntrain),Ts);
yutest = iddata(y(Ntrain+1:N),u(Ntrain+1:N),Ts);

oe331 = oe(yutrain,[3 3 1]);
present(oe331)

figure(10)
compare(yutest,oe331)

figure(11)
p = bodeoptions;
set(p,'ConfidenceRegionNumberSD',5);
h = bodeplot(M,oe331,andre,p);
showConfidence(h)

figure(12)
resid(yutest,oe331)

figure(13)
pzmap(oe331)

%save('2021jan_problem3.mat','y','u','Ts','time')

s = tf('s')
G1 = 0.5/((1+2*s)*(1+0.2*s))
M1 = c2d(G1,Ts)
G3 = 0.5/(1+0.1*s*0.5+s^2*0.5^2);
M3 = c2d(G3,Ts);
G4 = 0.5/((1+0.1*s*0.5+s^2*0.5^2)*(1+0.05*s*0.1+s^2*0.1^2));
M4 = c2d(G4,Ts);

figure(20)
w=linspace(1e-1,10*pi,10000);
subplot(221)
bodemag(M1,w)
grid on
subplot(222)
bodemag(M,w)
grid on
subplot(223)
bodemag(M3,w)
grid on
subplot(224)
bodemag(M4,w)
grid on


