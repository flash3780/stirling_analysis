% sea (stirling engine analysis) - main program
%Israel Urieli 7/20/02

clc;
clear all;

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
global tk tr th % cooler, regenerator, heater temperatures [K]
global vk % cooler void volume [m^3]
global vr % regen void volume [m^3]
global vh % heater void volume [m^3]

define;
choice = 'x';
while(~strncmp(choice,'q',1))
	fprintf('Choose simulation:\n');
	choice = input('a)diabatic, s)imple q)uit: ','s');
	if(strncmp(choice,'a',1))
		[var,dvar] = adiabatic;
	else if(strncmp(choice,'s',1))
		[var,dvar] = simple;
	end
	end
end
fprintf('quitting simulation...\n');
