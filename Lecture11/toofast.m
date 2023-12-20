close all; clear
s = tf('s')
G = 1/(s^2+0.7*s+1);
figure(1)
step(G,20)
set(gca,'fontsize',14)
axis([0 20 0 2])
hold on

figure(2)
bodemag(G)
set(gca,'fontsize',14)
hold on
grid on

for h = [1e-1  1e-3]
    Gd = c2d(G,h);
    [n,d]=tfdata(Gd,'v')
    rng(42)
    nhat = n.*(1 + 1e-6*randn(size(n)));
    dhat = d.*(1 + 1e-6*randn(size(n)));
    Gdhat = tf(nhat,dhat,h)
    figure(1)
    step(Gdhat,20);
    figure(2)
    bodemag(Gdhat);
end

figure(1)
lines = findobj(gcf,'Type','Line');
for i = 1:numel(lines)
  lines(i).LineWidth = 1.6;
end
%print -depsc toofast01.eps

figure(2)
lines = findobj(gcf,'Type','Line');
for i = 1:numel(lines)
  lines(i).LineWidth = 1.6;
end
%print -depsc toofast02.eps