function [y,dy] = dadiab(theta,y)
% Evaluate ideal adiabatic model derivatives
% Israel Urieli, 7/6/2002
% Arguments:  theta - current cycle angle [radians]
%             y(22) - vector of current variable values 
% Returned values: 
%             y(22) - updated vector of current variables
%             dy(16) vector of current derivatives
% Function invoked : volume.m

% global variables used from "define" functions
global vk % cooler void volume [m^3]
global vr % regen void volume [m^3]
global vh % heater void volume [m^3]
global rgas % gas constant [J/kg.K]
global cp % specific heat capacity at constant pressure [J/kg.K]
global cv % specific heat capacity at constant volume [J/kg.K]
global gama % ratio: cp/cv
global mgas % total mass of gas in engine [kg]
global tk tr th % cooler, regen, heater temperatures [K]

% Indices of the y, dy vectors:
 TC = 1;  % Compression space temperature (K)
 TE = 2;  % Expansion space temperature (K)
 QK = 3;  % Heat transferred to the cooler (J)
 QR = 4;  % Heat transferred to the regenerator (J)
 QH = 5;  % Heat transferred to the heater (J)
 WC = 6;  % Work done by the compression space (J)
 WE = 7;  % Work done by the expansion space (J)
 W  = 8;  % Total work done (WC + WE) (J)
 P  = 9;  % Pressure (Pa)
 VC = 10; % Compression space volume (m^3)
 VE = 11; % Expansion space volume (m^3)
 MC = 12; % Mass of gas in the compression space (kg)
 MK = 13; % Mass of gas in the cooler (kg)
 MR = 14; % Mass of gas in the regenerator (kg)
 MH = 15; % Mass of gas in the heater (kg)
 ME = 16; % Mass of gas in the expansion space (kg)
 TCK = 17; % Conditional temperature compression space / cooler (K)
 THE = 18; % Conditional temeprature heater / expansion space (K)
 GACK = 19; % Conditional mass flow compression space / cooler (kg/rad)
 GAKR = 20; % Conditional mass flow cooler / regenerator (kg/rad)
 GARH = 21; % Conditional mass flow regenerator / heater (kg/rad)
 GAHE = 22; % Conditional mass flow heater / expansion space (kg/rad)
%=======================================================================

% Volume and volume derivatives:
 [y(VC),y(VE),dy(VC),dy(VE)] = volume(theta);

% Pressure and pressure derivatives:
 vot = vk/tk + vr/tr + vh/th;
 y(P) = (mgas*rgas/(y(VC)/y(TC) + vot + y(VE)/y(TE)));
 top = -y(P)*(dy(VC)/y(TCK) + dy(VE)/y(THE));
 bottom = (y(VC)/(y(TCK)*gama) + vot + y(VE)/(y(THE)*gama));
 dy(P) = top/bottom;

% Mass accumulations and derivatives:
 y(MC) = y(P)*y(VC)/(rgas*y(TC));
 y(MK) = y(P)*vk/(rgas*tk);
 y(MR) = y(P)*vr/(rgas*tr);
 y(MH) = y(P)*vh/(rgas*th);
 y(ME) = y(P)*y(VE)/(rgas*y(TE));
 dy(MC) = (y(P)*dy(VC) + y(VC)*dy(P)/gama)/(rgas*y(TCK));
 dy(ME) = (y(P)*dy(VE) + y(VE)*dy(P)/gama)/(rgas*y(THE));
 dpop = dy(P)/y(P);
 dy(MK) = y(MK)*dpop;
 dy(MR) = y(MR)*dpop;
 dy(MH) = y(MH)*dpop;

% Mass flow between cells:
 y(GACK) = -dy(MC);
 y(GAKR) = y(GACK) - dy(MK);
 y(GAHE) = dy(ME);
 y(GARH) = y(GAHE) + dy(MH);

% Conditional temperatures between cells:
 y(TCK) = tk;
 if(y(GACK)>0)
    y(TCK) = y(TC);
 end
 y(THE) = y(TE);
 if(y(GAHE)>0)
    y(THE) = th;
 end

% 7 derivatives to be integrated by rk4:
% Working space temperatures:
 dy(TC) = y(TC)*(dpop + dy(VC)/y(VC) - dy(MC)/y(MC));
 dy(TE) = y(TE)*(dpop + dy(VE)/y(VE) - dy(ME)/y(ME));

% Energy:
 dy(QK) = vk*dy(P)*cv/rgas - cp*(y(TCK)*y(GACK) - tk*y(GAKR));
 dy(QR) = vr*dy(P)*cv/rgas - cp*(tk*y(GAKR) - th*y(GARH));
 dy(QH) = vh*dy(P)*cv/rgas - cp*(th*y(GARH) - y(THE)*y(GAHE));
 dy(WC) = y(P)*dy(VC);
 dy(WE) = y(P)*dy(VE);
 
% Net work done:
 dy(W) = dy(WC) + dy(WE);
 y(W) = y(WC) + y(WE);




