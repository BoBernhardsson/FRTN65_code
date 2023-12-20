clear; close all
figure(1)
dt = 0.01;
thetavec = -10:dt:10;
prior = normpdf(thetavec,1,5);
plot(thetavec,prior,'b')
xlabel('\theta')
ylabel('p(\theta)')
hold on
axis([-10 10 0 0.25])
text(-3,0.225,'Prior p(\theta)','FontSize',24,'Fontweight','bold')
%print -depsc bayes01.eps


%%%%%%%%%%%%%%%%%%%%%% Calculation of posterior probability
figure(2)
ym = 5;
sigma = 1;
post = zeros(size(prior));
for i=1:length(post)
    th = thetavec(i);
    post(i) = prior(i) * normpdf(ym,abs(th),sigma);
end
post = post/sum(post*dt);

%%%%%%%%%%%%%%%%%%%%%%%%%
axis([-10 10 0 0.25])
plot(thetavec,post,'r')
text(-6,0.225,'A Posteriori p(\theta|y)','FontSize',24,'Fontweight','bold')
xlabel('\theta')
ylabel('p(\theta | y)')
%print -depsc bayes02.eps