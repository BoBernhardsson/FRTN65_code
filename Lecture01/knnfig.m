close all
rng(10)
x = rand(30,1)
y = sin(8*x)+0.2*randn(size(x))
xnew = (0:0.001:1)';
for Kvalue = [1:1:4 20]
    figure(Kvalue)
    plotfix
    plot(x,y,'.','MarkerSize',30)
    idx = knnsearch(x,xnew,'K',Kvalue);
    hold on;
    plot(xnew,mean(y(idx),2),'r')
    title(['KNN with K= ' num2str(Kvalue)] )
    Filename = ['knnfig' num2str(Kvalue) '.epsc'] 
    saveas(gcf, Filename)
end