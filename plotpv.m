function plotpv
% plot pv and p-theta diagrams of schmidt analysis
% Israel Urieli 1/6/03

global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global vk % cooler void volume [m^3]
global vh % heater void volume [m^3]
global vr % regen void volume [m^3]
global mgas % total mass of gas in engine [kg]
global rgas % gas constant [J/kg.K]
global pmean % mean (charge) pressure [Pa]
global tk tr th % cooler, regenerator, heater temperatures [K]

theta = 0:5:360;
vc = vclc + 0.5*vswc*(1 + cos(theta*pi/180));
ve = vcle + 0.5*vswe*(1 + cos(theta*pi/180 + alpha));
p = mgas*rgas./(vc/tk + vk/tk + vr/tr + vh/th + ve/th)*1e-5; % [bar]
vtot = (vc + vk + vr + vh + ve)*1e6; % [cc]
figure
plot(vtot,p)
grid on
xlabel('total volume (cc)')
ylabel('pressure (bar)')
title('Schmidt pv diagram')
figure
plot(theta,p)
grid on
hold on
x = [0,360];
y = [pmean*1e-5, pmean*1e-5];
plot(x,y)
xlabel('crank angle (deg)')
ylabel('pressure (bar)')
title('Schmidt p-theta diagram')
