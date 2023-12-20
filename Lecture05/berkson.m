close all
N = 1000;
x = rand(N,1);
y = rand(N,1);

z = x+y;
ind1 = find(z<1);
ind2 = find(z>1);

xblue = x(ind1);
yblue = y(ind1);
xred  = x(ind2);
yred  = y(ind2);

figure(1)
plot(xblue,yblue,'b.','MarkerSize',12)
axis('square')
hold on
plot(xred,yred,'r.','MarkerSize',12)

% plot regression lines
plot([0 1],[0.5 0],'b','linewidth',5)
plot([0 1],[1 0.5],'r','linewidth',5)

% calculate correlations
rho = corrcoef(x,y)
rhoblue = corrcoef(xblue,yblue)
rhored = corrcoef(xred,yred)
