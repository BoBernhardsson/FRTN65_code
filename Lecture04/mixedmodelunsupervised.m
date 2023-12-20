% Generate some data for M=2 clusters
clear, close all
rng('default')
dim = 2;
pi1 = 0.75;
pi2 = 0.25;
mu1 = [-1;3];
mu2 = [1; 5];
Sigma1 = [2 -1; -1 2];
Sigma2 = 0.2*[1 1 ; 1 2];
N = 200;
f1 = figure(1);
plotfix
hold on
n1 = 0;
n2 = 0;
pi1hat = 0*pi1;
pi2hat = 0*pi2;
mu1hat = 0*mu1;
mu2hat = 0*mu2;
Sigma1hat = 0*Sigma1;
Sigma2hat = 0*Sigma2;
for i=1:N
    if rand < pi1
        z(:,i) = mu1 + chol(Sigma1,'lower')*randn(2,1);
        plot(z(1,i),z(2,i),'b.','Markersize',12)
    else
        z(:,i) = mu2 + chol(Sigma2,'lower')*randn(2,1);
        plot(z(1,i),z(2,i),'r.','Markersize',12);
    end
end
axis([-6 4 -2 8])
axis('square')
a1 = gca;

% Stupid initial guess for EM algorithm
pi1hat = 0.5;
pi2hat = 0.5;
mu1hat = randn(2,1);
mu2hat = randn(2,1);
Sigma1hat = eye(2,2);
Sigma2hat = eye(2,2);

%EM algorithm
for iter = 1:50
    
    f = figure(iter+1);
    plotfix
    a2 = copyobj(a1,f);

    % Estimate class probabilities
    % This is wrong. Should include 
    w = zeros(1,N);
    for i = 1:N
        zi = z(:,i);
        w1 = pi1hat*exp(-0.5*(zi-mu1hat)'*inv(Sigma1hat)*(zi-mu1hat))/sqrt(det(Sigma1hat));
        w2 = pi2hat*exp(-0.5*(zi-mu2hat)'*inv(Sigma2hat)*(zi-mu2hat))/sqrt(det(Sigma2hat));
        w(i) = w1/(w1+w2);
        if w(i)>0.5
           plot(z(1,i),z(2,i),'bo','Markersize',10);
        else
           plot(z(1,i),z(2,i),'ro','Markersize',10);
        end   
    end
 
    % plot ellipsoids
    phi = 0:0.05:2*pi;
    for r=[0.5 1 2]
      ellips1 = repmat(mu1hat,1,length(phi)) + r*chol(Sigma1hat,'lower')*[cos(phi);sin(phi)];
      plot(ellips1(1,:), ellips1(2,:),'b-')
      ellips2 = repmat(mu2hat,1,length(phi)) + r*chol(Sigma2hat,'lower')*[cos(phi);sin(phi)];
      plot(ellips2(1,:), ellips2(2,:),'r-')
    end
    
    % update moment estimates
    n1hat = sum(w)
    n2hat = sum(1-w)
    pi1hat = n1hat/N;
    pu2hat = n2hat/N;
    mu1hat = sum(z.*[w;w],2)/n1hat
    mu2hat = sum(z.*[1-w;1-w],2)/n2hat
    z1 = z - repmat(mu1hat,1,N);
    z2 = z - repmat(mu2hat,1,N);
    Sigma1hat = (z1.*[w;w])*z1'/n1hat
    Sigma2hat = (z2.*[1-w;1-w])*z2'/n2hat
    text(-3,7.6,['Iteration ' num2str(iter)])
    axis([-6 4 -2 8])
    axis('square')
    drawnow   
    
end


    