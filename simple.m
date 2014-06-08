function [var,dvar] = simple
% simple analysis - including heat transfer and pressure drop effects
% Israel Urieli, 7/22/2002 (modified 12/3/2003 for temp plots)
% Modified 2/7/2010 to include qrloss in hotsim & kolsim
% Modified 2/15/2010 logical reorganization
% Returned values: 
%   var(22,37) array of variable values every 10 degrees (0 - 360)
%   dvar(16,37) array of derivatives every 10 degrees (0 - 360)

% Row indices of the var, dvar arrays:
 TC = 1;  % Compression space temperature [K]
 TE = 2;  % Expansion space temperature [K]
 QK = 3;  % Heat transferred to the cooler [J]
 QR = 4;  % Heat transferred to the regenerator [J]
 QH = 5;  % Heat transferred to the heater [J]
 WC = 6;  % Work done by the compression space [J]
 WE = 7;  % Work done by the expansion space [J]
 W  = 8;  % Total work done (WC + WE) [J]
 P  = 9;  % Pressure [Pa]
 VC = 10; % Compression space volume [m^3]
 VE = 11; % Expansion space volume [m^3]
 MC = 12; % Mass of gas in the compression space [kg]
 MK = 13; % Mass of gas in the cooler [kg]
 MR = 14; % Mass of gas in the regenerator [kg]
 MH = 15; % Mass of gas in the heater [kg]
 ME = 16; % Mass of gas in the expansion space [kg]
 TCK = 17; % Conditional temperature compression space / cooler [K]
 THE = 18; % Conditional temeprature heater / expansion space [K]
 GACK = 19; % Conditional mass flow compression space / cooler [kg/rad]
 GAKR = 20; % Conditional mass flow cooler / regenerator [kg/rad]
 GARH = 21; % Conditional mass flow regenerator / heater [kg/rad]
 GAHE = 22; % Conditional mass flow heater / expansion space [kg/rad]
% Size of var(ROWV,COL), dvar(ROWD,COL)
 ROWV = 22; % number of rows in the var matrix
 ROWD = 16; % number of rows in the dvar matrix
 COL = 37; % number of columns in the matrices (every 10 degrees) 
%======================================================================

global freq % cycle frequency [herz]
global tk tr th % cooler, regenerator, heater temperatures [K]
global cqwr % regenerator housing thermal conductance [W/K]

twk = tk; % Cooler wall temp - equal to initial cooler gas temp
twh = th; % Heater wall temp - equal to initial heater gas temp
epsilon = 1; % allowable temperature error bound for cyclic convergence
terror = 10*epsilon; % Initial temperature error (to enter loop)

while (terror>epsilon)
   [var,dvar] = adiab;
   qrloss = regsim(var); % included 2/7/2010
   tgh = hotsim(var,twh,qrloss); % new heater gas temperature
   tgk = kolsim(var,twk,qrloss); % new cooler gas temperature
   terror = abs(th - tgh) + abs(tk - tgk);
   th = tgh;
   tk = tgk;
   tr = (th-tk)/log(th/tk);
end

fprintf('===== converged heater and cooler mean temperatures =====\n');
fprintf('heater wall/gas temperatures: Twh = %.1f[K], Th = %.1f[K]\n',twh,th);
fprintf('cooler wall/gas temperatures: Twk = %.1f[K], Tk = %.1f[K]\n',twk,tk);
% Print out ideal adiabatic analysis results
eff = var(W,COL)/var(QH,COL); % engine thermal efficency
Qkpower = var(QK,COL)*freq;   % Heat transferred to the cooler (W)
Qrpower = var(QR,COL)*freq;   % Heat transferred to the regenerator (W)
Qhpower = var(QH,COL)*freq;   % Heat transferred to the heater (W)
Wpower = var(W,COL)*freq;     % Total power output (W)
fprintf('========== ideal adiabatic analysis results ==========\n');
fprintf(' Heat transferred to the cooler: %.2f[W]\n', Qkpower);
fprintf(' Net heat transferred to the regenerator: %.2f[W]\n', Qrpower);
fprintf(' Heat transferred to the heater: %.2f[W]\n', Qhpower);
fprintf(' Total power output: %.2f[W]\n', Wpower);
fprintf(' Ideal Adiabatic Thermal efficiency: %.1f[%%]\n', eff*100);
fprintf('============= Regenerator analysis results============\n');
fprintf(' Regenerator net enthalpy loss: %.1f[W]\n', qrloss*freq);
qwrl = cqwr*(twh - twk)/freq;
fprintf(' Regenerator wall heat leakage: %.1f[W]\n', qwrl*freq);

% Temperature plot of the simple simulation results
		figure
		x = 0:10:360;
		Tcomp = var(TC,:);
		Texp = var(TE,:);
		plot(x,Tcomp,'b-',x,Texp,'r-');
		hold on
		x = [0,360];
		y = [twk,twk];
		plot(x,y,'b--')
		y = [tk,tk];
		plot(x,y,'b-')
		y = [tr,tr];
		plot(x,y,'g-')
		y = [th,th];
		plot(x,y,'r-')
		y = [twh,twh];
		plot(x,y,'r--')
		hold off
		grid on
		xlabel('Crank angle (degrees)');
		ylabel('Temperature (K)');
		title('Simple Simulation - Wall and Gas Temps vs crank angle');
% Various plots of the ideal adiabatic simulation results
plotadiab(var,dvar);
fprintf('========= pressure drop simple analysis =============\n');
dwork = worksim(var,dvar);
fprintf(' Pressure drop available work loss: %.1f[W]\n', dwork*freq)
actWpower = Wpower - dwork*freq;
actQhpower = Qhpower + qrloss*freq + qwrl*freq;
acteff = actWpower/actQhpower;
fprintf(' Actual power from simple analysis: %.1f[W]\n', actWpower); 
fprintf(' Actual heat power in from simple analysis: %.1f[W]\n', actQhpower); 
fprintf(' Actual efficiency from simple analysis: %.1f[%%]\n', acteff*100); 
