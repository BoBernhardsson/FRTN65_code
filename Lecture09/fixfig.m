function [] = fixfig(fignr,linewidth, fontsize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin == 1
   figure(fignr)
end
if nargin < 2
    linewidth = 2.0;
end
if nargin < 3 
    fontsize = 18;
end
lines = findobj(gcf,'Type','Line');
for i = 1:numel(lines)
  lines(i).LineWidth = linewidth;
end
set(findall(gcf,'-property','FontSize'),'FontSize',fontsize)

end

