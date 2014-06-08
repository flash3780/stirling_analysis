function [x, y, dy] = rk4(deriv,n,x,dx,y)
%Classical fourth order Runge-Kutta method
%Integrates n first order differential equations 
%dy(x,y) over interval x to x+dx
%Israel Urieli - Jan 21, 2002
x0 = x;
y0 = y;

[y,dy1] = feval(deriv,x0,y);
for i = 1:n
	y(i) = y0(i) + 0.5*dx*dy1(i);
end
xm = x0 + 0.5*dx;
[y,dy2] = feval(deriv,xm,y);
for i = 1:n
	y(i) = y0(i) + 0.5*dx*dy2(i);
end
[y,dy3] = feval(deriv,xm,y);
for i = 1:n
	y(i) = y0(i) + dx*dy3(i);
end
x = x0 + dx;
[y,dy] = feval(deriv,x,y);
for i = 1:n
	dy(i) = (dy1(i) + 2*(dy2(i) + dy3(i)) + dy(i))/6;
	y(i) = y0(i) + dx*dy(i);
end

