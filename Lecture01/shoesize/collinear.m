
close all; clear

N = 100;

y = 10 + sqrt(2)*randn(N,1);

rho1 = 0.4 + 0.1*rand
x1 = rho1*y + sqrt(0.02)*randn(N,1);

rho2 = 0.4 + 0.1*rand
x2 = rho2*y + sqrt(0.02)*randn(N,1);

plot(x1,y,'bx')
hold on
plot(x2,y,'ro')
axis([0 15 0 15 ]); grid on


X = [x1 x2 ones(N,1)];

theta = X\y

