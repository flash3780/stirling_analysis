function operat
% Determine operating parameters and do Schmidt anlysis
% Israel Urieli 4/20/02

global pmean % mean (charge) pressure [Pa]
global tk tr th % cooler, regenerator, heater temperatures [K]
global freq omega % cycle frequency [herz], [rads/s]
global new fid % new data file

if(strncmp(new,'y',1))
      pmean = input('enter mean pressure (Pa) : ');
      tk = input('enter cold sink temperature (K) : ');
      th = input('enter hot source temperature (K) : ');
      freq = input('enter operating frequency (herz) : ');
      fprintf(fid, '%.1f\n', pmean);
      fprintf(fid, '%.1f\n', tk);
      fprintf(fid, '%.1f\n', th);
      fprintf(fid, '%.1f\n', freq);
else
      pmean = fscanf(fid,'%f',1);
      tk = fscanf(fid,'%f',1);
      th = fscanf(fid,'%f',1);
      freq = fscanf(fid,'%f',1);
end

tr = (th - tk)/log(th/tk);
omega = 2*pi*freq;
fprintf('operating parameters:\n');
fprintf(' mean pressure (kPa): %.3f\n',pmean*1e-3);
fprintf(' cold sink temperature (K): %.1f\n',tk);
fprintf(' hot source temperature (K): %.1f\n',th);
fprintf(' effective regenerator temperature (K): %.1f\n',tr);
fprintf(' operating frequency (herz): %.1f\n',freq);

Schmidt; % Do Schmidt analysis
%==============================================================
function Schmidt
% Schmidt anlysis
% Israel Urieli 3/31/02

global mgas % total mass of gas in engine [kg]
global pmean % mean (charge) pressure [Pa]
global tk tr th % cooler, regen, heater temperatures [K]
global freq omega % cycle frequency [herz], [rads/s]
global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global vk vr vh % cooler, regenerator, heater volumes [m^3]
global rgas % gas constant [J/kg.K]

% Schmidt analysis
c = (((vswe/th)^2 + (vswc/tk)^2 + 2*(vswe/th)*(vswc/tk)*cos(alpha))^0.5)/2;
s = (vswc/2 + vclc + vk)/tk + vr/tr + (vswe/2 + vcle + vh)/th;
b = c/s;
sqrtb = (1 - b^2)^0.5;
bf = (1 - 1/sqrtb);
beta = atan(vswe*sin(alpha)/th/(vswe*cos(alpha)/th + vswc/tk));
fprintf(' pressure phase angle beta  %.1f(degrees)\n',beta*180/pi)
% total mass of working gas in engine
mgas=pmean*s*sqrtb/rgas;
fprintf(' total mass of gas:  %.3f(gm)\n',mgas*1e3)
% work output   
wc = (pi*vswc*mgas*rgas*sin(beta)*bf/c);  
we = (pi*vswe*mgas*rgas*sin(beta - alpha)*bf/c);
w = (wc + we);
power = w*freq;
eff = w/we; % qe = we
% Printout Schmidt analysis results
fprintf('=====================  Schmidt analysis  ===============\n')
fprintf(' Work(joules) %.3e,  Power(watts) %.3e\n', w,power);
fprintf(' Qexp(joules) %.3e,  Qcom(joules) %.3e\n', we,wc);
fprintf(' indicated efficiency %.3f\n', eff);
fprintf('========================================================\n')
% Plot Schmidt analysis pv and p-theta diagrams
fprintf('Do you want Schmidt analysis plots\n');
choice = input('y)es or n)o: ','s');
if(strncmp(choice,'y',1))
   plotpv
end
% Plot Alan Organ's particle mass distribution in Natural Coordinates
fprintf('Do you want particle mass distribution plot\n');
choice = input('y)es or n)o: ','s');
if(strncmp(choice,'y',1))
   plotmass
end
