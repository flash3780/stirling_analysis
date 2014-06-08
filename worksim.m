function dwork = worksim(var,dvar);
% Evaluate the pressure drop available work loss [J]
% Israel Urieli, 7/23/2002
% Arguments:
%   var(22,37) array of variable values every 10 degrees (0 - 360)
%   dvar(16,37) array of derivatives every 10 degrees (0 - 360)
% Returned value: 
%   dwork - pressure drop available work loss [J]

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

global tk tr th % cooler, regenerator, heater temperatures [K]
global freq omega % cycle frequency [herz], [rads/s]
global vh % heater void volume [m^3]
global ah % heater internal free flow area [m^2]
global dh % heater hydraulic diameter [m]
global lh % heater effective length [m]
global vk % cooler void volume [m^3]
global ak % cooler internal free flow area [m^2]
global dk % cooler hydraulic diameter [m]
global lk % cooler effective length [m]
global vr % regen void volume [m^3]
global ar % regen internal free flow area [m^2]
global lr % regenerator effective length [m]
global dr % regen hydraulic diameter [m]
global matrix_type % m)esh or f)oil

dtheta = 2*pi/36;
dwork = 0; % initialise pumping work loss

for(i = 1:1:36)
    gk = (var(GACK,i) + var(GAKR,i))*omega/(2*ak);
    [mu,kgas,re(i)] = reynum(tk,gk,dk);
    [ht,fr] = pipefr(dk,mu,re(i));
    dpkol(i) = 2*fr*mu*vk*gk*lk/(var(MK,i)*dk^2);

    gr = (var(GAKR,i) + var(GARH,i))*omega/(2*ar);
    [mu,kgas,re(i)] = reynum(tr,gr,dr);
    if(strncmp(matrix_type,'m',1))
         [st,fr] = matrixfr(re(i));
    elseif (strncmp(matrix_type,'f',1))
         [st,ht,fr] = foilfr(dr,mu,re(i));
    end
    dpreg(i) = 2*fr*mu*vr*gr*lr/(var(MR,i)*dr^2);

    gh = (var(GARH,i) + var(GAHE,i))*omega/(2*ah);
    [mu,kgas,re(i)] = reynum(th,gh,dh);

    [ht,fr] = pipefr(dh,mu,re(i));
    dphot(i) = 2*fr*mu*vh*gh*lh./(var(MH,i)*dh^2);
    dp(i) = dpkol(i) + dpreg(i) + dphot(i);

    dwork=dwork+dtheta*dp(i)*dvar(VE,i); % pumping work [J]
	pcom(i) = var(P,i);
	pexp(i) = pcom(i) + dp(i);
end

dpkol(COL) = dpkol(1);
dpreg(COL) = dpreg(1);
dphot(COL) = dphot(1);
dp(COL) = dp(1);
pcom(COL) = pcom(1);
pexp(COL) = pexp(1);

choice = 'x';
while(~strncmp(choice,'q',1))
	fprintf('Choose pumping loss plot type:\n');
	fprintf('   h - for heat exchanger pressure drop plot\n');
	fprintf('   p - for working space pressure plot\n');
	fprintf('   q - to quit\n');
	choice = input('h)x_pdrop, p)ressure, q)uit: ','s');
	if(strncmp(choice,'h',1))
		figure;
		x = 0:10:360;
		plot(x,dpkol,'b-',x,dphot,'r-',x,dpreg,'g-');
		grid on
		xlabel('Crank angle (degrees)');
		ylabel('Heat exchanger pressure drop [Pa]');
		title('Heat exchanger pressure drop vs crank angle');
	elseif(strncmp(choice,'p',1))
		figure
		x = 0:10:360;
		pcombar = pcom*1e-5;
		pexpbar = pexp*1e-5;
		plot(x,pcombar,'b-',x,pexpbar,'r-');
		grid on
		xlabel('Crank angle (degrees)');
		ylabel('Working space pressure [bar]');
		title('Working space pressure vs crank angle');
	end
end
fprintf('quitting pressure plots...\n');
