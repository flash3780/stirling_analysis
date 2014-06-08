function [var,dvar] = adiabatic
% Ideal adiabatic simulation and temperature/energy vs theta plots
% Israel Urieli, 7/20/2002
% Returned values: 
%   var(22,37) array of variable values every 10 degrees (0 - 360)
%   dvar(16,37) array of derivatives every 10 degrees (0 - 360)

% Row indices of the var, dvar arrays:
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
% Size of var(ROWV,COL), dvar(ROWD,COL)
 ROWV = 22; % number of rows in the var matrix
 ROWD = 16; % number of rows in the dvar matrix
 COL = 37; % number of columns in the matrices (every 10 degrees) 
%======================================================================
global freq % cycle frequency [herz]
global tk tr th % cooler, regenerator, heater temperatures [K]
global vk % cooler void volume [m^3]
global vr % regen void volume [m^3]
global vh % heater void volume [m^3]

% do ideal adiabatic analysis:
[var,dvar] = adiab;

% Print out ideal adiabatic analysis results
eff = var(W,COL)/var(QH,COL); % engine thermal efficency
Qkpower = var(QK,COL)*freq;   % Heat transferred to the cooler (W)
Qrpower = var(QR,COL)*freq;   % Heat transferred to the regenerator (W)
Qhpower = var(QH,COL)*freq;   % Heat transferred to the heater (W)
Wpower = var(W,COL)*freq;     % Total power output (W)
fprintf('========== ideal adiabatic analysis results ============\n')
fprintf(' Heat transferred to the cooler: %.2f[W]\n', Qkpower);
fprintf(' Net heat transferred to the regenerator: %.2f[W]\n', Qrpower);
fprintf(' Heat transferred to the heater: %.2f[W]\n', Qhpower);
fprintf(' Total power output: %.2f[W]\n', Wpower);
fprintf(' Thermal efficiency : %.1f[%%]\n', eff*100);
fprintf('========================================================\n')

% Various plots of the ideal adiabatic simulation results
plotadiab(var,dvar);
