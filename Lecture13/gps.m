% Simulate improved GPS tracking
% Using Kalman filtering, prediction and smoothing
% Uses Matlab's notation
close all
%sigma2 = 1e-1;  % fast, more noisy
sigma2 = 1e-2;  % slow, low noise
v=4;    % speed m/s
h=1;    % sampling period in seconds
N=50;   % nr samples / 2 

% The true trajectory (two straight lines with a turn)
xtrue1=[zeros(1,N+1) 0:v*h:(N-1)*v*h];     
xtrue2=[0:v*h:N*v*h N*v*h*ones(1,N)];
xtrue=[xtrue1;xtrue2];

% The gps measurements
gps_accuracy = 5; % measurement accuracy in meter  
randn('state',0)
ygps = xtrue + gps_accuracy*randn(size(xtrue));
figure(1)
plot(ygps(1,:),ygps(2,:),'b-x','linewidth',1.5); 
hold on
plot(xtrue(1,:),xtrue(2,:),'k-','linewidth',1.5)

% The Kalman filter (matlab notation)
I = eye(2);
A = [I h*I; 0*I I];
G = [0*I;I];
C = [I 0*I];
Q = sigma2*I;    % tuning parameter
R = gps_accuracy^2*I;
[M,P,Z,E] = dlqe(A,G,C,Q,R);
kalman1 = ss(A-A*M*C,A*M,eye(4),zeros(4,2),h);
kalman0 = ss(A-A*M*C,A*M,eye(4)-M*C,M,h);

% Some plotting
time = (0:2*N)*h;
xpred1 = lsim(kalman1, ygps,time)';
ypred1 = C*xpred1;
plot(ypred1(1,:),ypred1(2,:),'r-','linewidth',1.5)

xpred01 = xpred1 + M*(ygps-C*xpred1);
xpred0 = lsim(kalman0, ygps,time)';
ypred0 = C*xpred0;

plot(ypred0(1,:),ypred0(2,:),'g-','linewidth',1.5)

legend('gps','true trajectory','kalman1','kalman0','Location','East')
title(['sigma2=' num2str(sigma2)],'fontsize',16,'fontweight','b')
% print -depsc gps1.eps

dp1 = diff(ypred1');
traveled1 = sum(sqrt(sum(dp1.^2,2)))

dp0 = diff(ypred0');
traveled0 = sum(sqrt(sum(dp0.^2,2)))

