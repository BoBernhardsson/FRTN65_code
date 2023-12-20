%% Grey box identification on dcmotor
% load and plot data
close all
clear
load(fullfile(matlabroot,'toolbox','ident','iddemos','data','dcmotordata'));
figure(1)
subplot(211)
plot(y,'linewidth',1.6)
legend('y1','y2','Location','best')
set(gca,'fontsize',14)
ylabel('output y')
subplot(212)
plot(u,'linewidth',1.6)
axis([0 400 -12 12 ])
xlabel('Time')
set(gca,'fontsize',14)
ylabel('input u')
%% Initialize Grey Box Model

A = [0 1;0 -1];
B = [0;0.25];
C = eye(2);
D = [0;0];
K = zeros(2,2);
x0 = [0;0];
m = idss(A,B,C,D,K,'Ts',0);
S = m.Structure;
S.A.Free(1,:) = false;
S.A.Free(2,1) = false;
S.B.Free(1) = false;
S.C.Free = false;
S.D.Free = false;
S.K.Free = false;
m.Structure = S;
m.NoiseVariance = [0.01 0; 0 0.1];
opt = ssestOptions;
opt.InitialState = idpar(x0);
opt.InitialState.Free(2) = false;


%% Estimate model structure
z = iddata(y,u,0.1);
m = ssest(z,m,opt)

%% Checking the result
figure(2)
compare(z,m)
hold on
lines = findobj(gcf,'Type','Line');
for iter = 1:length(lines)
    set(lines(iter),'linewidth',1.6)
end


%% Use model m for new simulation
figure(3)
e = randn(400,2);
usim = 8*idinput(400,'rbs',[0 0.05]);
simdat = iddata([],usim,'Ts',0.1);
simopt = simOptions('AddNoise',true,'NoiseData',e);
ysim = sim(m,simdat,simopt);

subplot(211)
plot(ysim.y(:,1),'b')
hold on
plot(ysim.y(:,2),'r');
subplot(212)
plot(usim)
lines = findobj(gcf,'Type','Line');
for iter = 1:length(lines)
    set(lines(iter),'linewidth',1.6)
end

%% Plot bode diagram for m
% show confidence regions

figure(4)
fig = bodeplot(m);
showConfidence(fig,3)

    
