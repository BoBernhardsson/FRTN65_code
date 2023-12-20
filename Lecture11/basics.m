% This file illustrates some basic commands 
% in the system identification toolbox: 
% Define a true system
% Generate some input and output data using true system
% Estimates a model

close all; clear;

a1 = -0.96;
b1 = 0.5;

A = [1 a1];
B = [0 b1];
C = 1;
D = 1;
F = 1;
lambda = 0.36;  % noisevariance
h = 0.1;   % sample rate

%%
% Use sim to simulate a system
% Can also use lsim, but then you must add the noise manually
%    which is easy for OE, but harder for AR, ARMA and BJ models

mysys = idpoly(A,B,C,D,F,lambda,h)

N = 100;
mu = 1;
u = sqrt(mu)*randn(N,1);
opt1 = simOptions('AddNoise',true);
y = sim(mysys,u,opt1);  % uses iddata/sim

figure(1)
subplot(211)
plot(y)
subplot(212)
plot(u)

%%

z = iddata(y,u,h);
arx1 = arx(z,[1 1 1])



%%
theoreticalfit_infN = 1-sqrt(lambda/cov(y))   % (think)
theoretical_std_A2 = sqrt(lambda/(lambda+mu)/N*(1-A(2)^2))  % see lecture
theoretical_std_B1 = sqrt(lambda/mu/N)

%%
figure(2)
bodeplot(mysys,arx1)
legend('mysys','arx1')

%%
present(arx1)
[Aest,Best] = polydata(arx1)
[pvec,dpvec] = getpvec(arx1)




