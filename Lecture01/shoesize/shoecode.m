% Example from Lecture 01 / Lecture 02
% close all; clear

load Lec1_shoedata.mat


% Plot  data
figure(1)
subplot(211)
plot(height,shoe,'bx')
xlabel('height [m]')
ylabel('shoe size')
hold on; grid on
subplot(212)
plot(leg,shoe,'bx')
xlabel('leglength [m]')
ylabel('shoe size')
hold on; grid on

% Fit linear lines to data
subplot(211); 
p1 = polyfit(height,shoe,1);
Ypred1 = polyval(p1,height);
plot(height,Ypred1,'r')
text(1.42,40,'shoe = 24.0 height - 2.0','color','red')

subplot(212); 
p2 = polyfit(leg,shoe,1);
Ypred2 = polyval(p2,leg);
plot(leg,Ypred2,'r')
text(0.66,40,'shoe = 51.2 leglength - 0.3','color','red')


%%
% Standard LS estimation
% Using height and leg data and estimate also a bias
% The resulting estimated theta seems strange, can you explain the problem?

Y = shoe; 
%X1 = [height ones(N,1)];
%X2 = [leg    ones(N,1)];
X = [height leg ones(N,1)];     % Using both height and leglength

theta = X\Y                     % Solution to normal equations, same as inv(Xk'*Xk) * Xk' * y

%YpredLS = X*theta;
%rmsLS = sqrt(mean((YpredLS-Y).^2));

%%
% Linear regression analysis
%  training N times on different subset of data


thetav = zeros(3,N); 
Ypred = zeros(N,1);

for k = 1:N
    ind = [1:k-1 k+1:N];
    thetahat = X(ind,:) \ Y(ind); 
    Ypred(k) = X(k,:) * thetahat;
    thetav(:,k) = thetahat;
end

% Uncomment this to study results

rmseLOOCV  = sqrt(mean((Ypred-Y).^2))      % Leave-one-out CV performance


% 
figure(2)
subplot(211)
hist(thetav(1,:),40)
title('histogram of theta1 (cv=200)')
subplot(212)
hist(thetav(2,:),40)
title('histogram of theta2 (cv=200)')
    
% Hint: Any ideas from the results of this ?
% svd(Xk'*Xk)

figure(3)
plot(thetav(1,:), thetav(2,:),'x')

% corr([height leg Y])
    