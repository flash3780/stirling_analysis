function plotadiab(var,dvar)
% various plots of ideal adiabatic simulation results
% Israel Urieli, 7/21/2002 (corrected temp plots 12/3/2003) 
% Arguments: 
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
global tk tr th % cooler, regenerator, heater temperatures [K]
global vk % cooler void volume [m^3]
global vr % regen void volume [m^3]
global vh % heater void volume [m^3]

choice = 'x';
while(~strncmp(choice,'q',1))
	fprintf('Choose plot type:\n');
	fprintf('   p - for a PV diagram\n');
	fprintf('   t - for a temperature vs crank angle plot\n');
	fprintf('   e - for an energy vs crank angle plot\n');
	fprintf('   q - to quit\n');
	choice = input('p)vdiagram, t)emperature, e)nergy, q)uit: ','s');
	if(strncmp(choice,'p',1))
		figure
		vol = (var(VC,:) + vk + vr + vh + var(VE,:))*1e6; % cubic centimeters
		pres = (var(P,:))*1e-5; % bar
		plot(vol,pres,'k')
		grid on
		xlabel('Volume (cc)')
		ylabel('Pressure (bar [1bar = 100kPa])')
		title('P-v diagram')
	elseif(strncmp(choice,'t',1))
		figure
		x = 0:10:360;
		Tcomp = var(TC,:);
		Texp = var(TE,:);
		plot(x,Tcomp,'b-',x,Texp,'r-');
		hold on
		x = [0,360];
		y = [tk,tk];
		plot(x,y,'b-')
		y = [tr,tr];
		plot(x,y,'g-')
		y = [th,th];
		plot(x,y,'r-')
		hold off
		grid on
		xlabel('Crank angle (degrees)');
		ylabel('Temperature (K)');
		title('Temperature vs crank angle');
	elseif(strncmp(choice,'e',1))
		figure
		x = 0:10:360;
		Qkol = var(QK,:); % [J]
		Qreg = var(QR,:); % [J]
		Qhot = var(QH,:); % [J]
		Work = var(W,:); % [J]
		Wcom = var(WC,:); % [J]
		Wexp = var(WE,:); % [J]
		plot(x,Qkol,'b-',x,Qreg,'g-',x,Qhot,'r-',x,Work,'k-.',x,Wcom,'b--',x,Wexp,'r--');
		grid on
		xlabel('Crank angle (degrees)');
		ylabel('Energy [Joules]');
		title('Energy vs crank angle');
	end
end
fprintf('quitting ideal adiabatic plots...\n');








