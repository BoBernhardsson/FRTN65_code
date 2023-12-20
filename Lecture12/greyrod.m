%close all; clear

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
u = idinput(3600,'rbs',[0 0.005]);
u = iddata([],u,h);
opt = simOptions;
set(opt,'InitialCondition',x0)
sys = idss(A,B,C,D,K,x0,Ts);
y = sim(sys,u,opt);
data = iddata(y.y,u.u,h);

%% Grey box identification
% true model order = Ngrid

modelorder = 20;   % Try lower order here
m_init = idgrey('heatd',{5e-3 1e-3},'c',{modelorder,L,temp});
mhat = greyest(data,m_init)

%% Plot results
subplot(211)
compare(data,mhat)
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

