close all; clear
rng(5)   % A case that works :-)
kappa = 6e-4;  % true diffusion constant
htf = 4.5e-3;    % true heat transfer coefficient
Ngrid = 100;
L = 1;
temp = 22;
Ts = 0;
[A,B,C,D,K,x0] = heatd(kappa,htf,Ts,Ngrid,L,temp);
% Note: This rod is insulated at both ends
% u = 1 will make temperature increase towards infinity 

%% Generate data
h = 1;   
tvec = (1:h:3600)'; 
u = idinput(3600,'rbs',[0 0.05]);
u = iddata([],u,h);
opt = simOptions;
set(opt,'InitialCondition',x0)
sys = idss(A,B,C,D,K,x0,Ts);
y = sim(sys,u,opt);
data = iddata(y.y,u.u,h);

%% Grey box identification
% true model order = Ngrid

modelorder = 5;   % Try lower order than 100 here
m_init = idgrey('heatd',{5e-3 1e-3},'c',{modelorder,L,temp});
mhat = greyest(data,m_init)

%% Plot results
figure(1)
subplot(211)
compare(mhat,data)
set(gca,'fontsize',14)
subplot(212)
plot(u)
axis([0 3600 -1.2 1.2])
set(gca,'fontsize',14)
shg
lines = findobj(gcf,'Type','Line');
for iter = 1:length(lines)
    set(lines(iter),'linewidth',1.6)
end

%%

opt = n4sidOptions;   %testat olika varianter här....
opt.Focus = 'simulation'; 
opt.n4Horizon = [5;10;20;50;100;200];
opt.Display = 'on';
order = 5;
%data = detrend(data,0);
[sys4,x0] = n4sid(data,order,'Ts',1,opt)

%%
figure(2)
bodeplot(sys,mhat,sys4,logspace(-4,0,1000))
legend('true sys','greybox mhat','n4sid','Location','best')

lines = findobj(gcf,'Type','Line');
for iter = 1:length(lines)
    set(lines(iter),'linewidth',1.6)
end
lines(3).YData = lines(3).YData-90-lines(3).YData(1); % fix yellow curve
syscolor = lines(2).Color;
sys4color = lines(3).Color;
set(gca,'fontsize',14)
%%

figure(3)
compare(data,sys4,'y',mhat,'r')
lines = findobj(gcf,'Type','Line');
for iter = 1:length(lines)
    set(lines(iter),'linewidth',2)
end
lines(6).Color = [0 0 1];
lines(5).LineStyle = '--';

set(gca,'fontsize',14)
shg
pause(1)
