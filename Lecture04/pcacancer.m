clear 
close all
load ovariancancer
columnmeans = mean(obs,1);
obs = obs - columnmeans;
tic
[U,S,V] = svd(obs,'econ');
toc
% project on first 3 PCA components
figure(1)
obs3 = obs*V(:,1:3);
% the first n1 patients have cancer, the rest are healthy
n1 = 121;
plot3(obs3(1:n1,1),obs3(1:n1,2),obs3(1:n1,3),'rx','LineWidth',2,'Markersize',8)
hold on
plot3(obs3(n1+1:end,1),obs3(n1+1:end,2),obs3(n1+1:end,3),'bo','LineWidth',2,'Markersize',8)
view(-350,40)
grid on
%print -depsc cancer01.eps


% Create 2nd diagram of biplot
figure(2)
obsU = (U(:,1:3))'*obs;
plot3(obsU(1,:),obsU(2,:),obsU(3,:),'kx')
view(-350,40)
grid on

figure(3)
plot(diag(S),'-x')
%plot(cumsum(diag(S).^2),'-x')
%V = axis;
%V(3) = 0;
%axis(V);
grid on

% Biplot
% columns 2655, (2663, 2664), 3173, 3174 are interesting