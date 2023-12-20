close all; clear
% A continuous time system
s = tf('s')
G = (s+3)/(s^2+s+4);
[A,B,C,D] = ssdata(G);
[num,den] = tfdata(G,'v');
[y,t] = step(G,10);
figure(1)
plot(t,y,'linewidth',2);
set(gca,'Fontsize',16)
hold on; shg
%print -depsc figcont.eps

% A discrete time system
%z = tf('z',0.1)
%Gd = (0.2*z-0.1)/(z^2-1.8*z+0.9)
Gd = c2d(G,0.2)
[yd,t] = step(Gd,10);
stairs(t,yd,'r','linewidth',2);shg
%print -depsc figdiscont.eps