function [var,dvar]=filmatrix(j,y,dy,var,dvar);
% Fill in the j-th column of the var, dvar matrices with values of y, dy
% Israel Urieli, 7/20/2002
% Arguments:  j - column index (1 - 37, every 10 degrees of cycle angle)
%             y(ROWV) - vector of current variable values 
%             dy(ROWD) vector of current derivatives
%             var(ROWV,37) - matrix of current variables vs cycle angle
%             dvar(ROWD,37) - matrix of current derivatives vs cycle angle
% Returned values: 
%             var(ROWV,37) - matrix of updated variables vs cycle angle
%             dvar(ROWD,37) - matrix of updated derivatives vs cycle angle

ROWV = 22; % number of rows in the var matrix
ROWD = 16; % number of rows in the dvar matrix

for(i = 1:1:ROWV)
   var(i,j) = y(i);
end
for(i = 1:1:ROWD)
   dvar(i,j) = dy(i);
end
