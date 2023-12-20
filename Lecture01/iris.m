clear
close all
load fisheriris
X = meas(:,1:2);
y = categorical(species);
labels = categories(y);
figure(1)
gscatter(X(:,1),X(:,2),species,'rgb','osd');
xlabel('Sepal length');
ylabel('Sepal width');
print -depsc iris.epsc

for K=[1 3 5]
    figure(100+K)
    x1range = 4:0.01:8;
    x2range = 2:0.01:4.5;
    [xx1, xx2] = meshgrid(x1range,x2range);
    XGrid = [xx1(:) xx2(:)];
    predictedspecies = predict(fitcknn(X,y,'NumNeighbors',K),XGrid);
    gscatter(xx1(:), xx2(:), predictedspecies,'rgb');
    legend off, axis tight
    legend(labels,'Location',[0.35,0.01,0.35,0.05],'Orientation','Horizontal')
    Filename = ['iris' num2str(K) '.epsc'] 
    saveas(gcf, Filename)
end