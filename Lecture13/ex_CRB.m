% CRB for position estimation
% True position coordinates: theta = [theta(1);theta(2)];
% Sensor i measures distance in direction alpha(i)
% Measurement: x(i) = theta(1)*cos(alpha(i))+theta(2)*sin(alpha(i)) + e(i)
close all
theta=[4;3];                       % True position
N = 3;                             % Number of sensors
alpha = [0*pi ; 0.2*pi; 0.8*pi];   % Angles towards sensors
sigma2 = 0.45*[1; 1; 1000];        % Variance of sensors
% Caculates the Fisher Matrix I
I = zeros(2,2);
for n = 1:N
    cn = cos(alpha(n)); 
    sn = sin(alpha(n));
    I = I + 1/sigma2(n)*[cn^2 cn*sn ; cn*sn sn^2];
end
% Plot true position, uncertainty ellipsoid, and lines
figure(1)
plot(theta(1),theta(2),'b*');hold on
C = inv(I);    
phiv = (linspace(0,2*pi,100))';
ellips = ([cos(phiv) sin(phiv)])*chol(C);
plot(theta(1)+ellips(:,1),theta(2)+ellips(:,2),'r-')
axis([-10,10,-10,10])
for n = 1:N
   plot([0 15*cos(alpha(n))],[0 15*sin(alpha(n))],'k-')
end 