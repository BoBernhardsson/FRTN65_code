clear, close all
rng('default')
pi1 = 0.75;
pi2 = 0.25;
mu1 = [-1;3];
mu2 = [1; 5];
Sigma1 = [2 -1; -1 2];
Sigma2 = 0.2*[1 1 ; 1 2];
N = 200
figure(1)
plotfix
hold on
for i=1:N
    if rand < pi1
        z = mu1 + chol(Sigma1,'lower')*randn(2,1);
        plot(z(1),z(2),'b.','Markersize',15)
    else
        z = mu2 + chol(Sigma2,'lower')*randn(2,1);
        plot(z(1),z(2),'r.','Markersize',15);
    end
end
a1 = gca;
%print -depsc mixedmodel01.eps

f2 = figure(2)
plotfix
a2 = copyobj(a1,f2)


phi = 0:0.01:2*pi;
for r=[0.5 1 2]
  ellips1 = repmat(mu1,1,length(phi)) + r*chol(Sigma1,'lower')*[cos(phi);sin(phi)];
  plot(ellips1(1,:), ellips1(2,:),'b-')
  ellips2 = repmat(mu2,1,length(phi)) + r*chol(Sigma2,'lower')*[cos(phi);sin(phi)];
  plot(ellips2(1,:), ellips2(2,:),'r-')
end
%print -depsc mixedmodel02.eps




    