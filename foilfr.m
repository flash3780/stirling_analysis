function [st,ht,fr] = foilfr(d,mu,re)
% evaluate regenerator wrapped foil stanton number, friction factor
% Israel Urieli, 7/22/2002
% Arguments:
%   d - hydraulic diameter [m]
%   mu - gas dynamic viscosity [kg.m/s]
%   re - Reynolds number
% Returned values: 
%   st - Stanton number
%   ht - heat transfer coefficient [W/m^2.K]
%   fr - Reynolds friction factor ( = re*fanning friction factor)

global cp % specific heat capacity at constant pressure [J/kg.K]
global prandtl % Prandtl number

if (re < 2000) % normally laminar flow
   fr = 24;
else
   fr = 0.0791*re^0.75;
end
% From Reynolds simple analogy:
st=fr/(2*re*prandtl);
ht=st*re*cp*mu/d;
