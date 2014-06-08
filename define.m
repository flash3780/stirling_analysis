function define
% define the stirling engine geometric 
% and operational parameters
% Israel Urieli 4/1/02 (April Fool's Day)
% Modified 2/12/2010 to include no-matrix regenerator awgr0
clc;
clear all;
% The set of global variables defined are:
% engine
global engine_type % s)inusoidal, y)oke r)ockerV (all alpha engines)
global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global b1 % Ross yoke length (1/2 yoke base) [m]
global b2 % Ross yoke height [m]
global crank % crank radius [m]
global dcomp dexp % diameter of compression/expansion pistons [m]
global acomp aexp % area of compression/expansion pistons [m^2]
global ymin % minimum yoke vertical displacement [m]
global conrodc conrode % length of comp/exp piston connecting rods [m]
global ycmax yemax % maximum comp/exp piston vertical displacement [m]
% heatex/cooler
global vk % cooler void volume [m^3]
global ak % cooler internal free flow area [m^2]
global awgk % cooler internal wetted area [m^2]
global dk % cooler hydraulic diameter [m]
global lk % cooler effective length [m]
% heatex/heater
global vh % heater void volume [m^3]
global ah % heater internal free flow area [m^2]
global awgh % heater internal wetted area [m^2]
global dh % heater hydraulic diameter [m]
global lh % heater effective length [m]
% heatex/regenerator
global lr % regenerator effective length [m]
global cqwr % regenerator housing thermal conductance [W/K]
global matrix_type % m)esh f)oil n}o matrix
global vr % regen void volume [m^3]
global ar % regen internal free flow area [m^2]
global awgr0 % no matrix regenerator wetted area [m^2]
global awgr % regen internal wetted area [m^2]
global dr % regen hydraulic diameter [m]
% gas
global rgas % gas constant [J/kg.K]
global cp % specific heat capacity at constant pressure [J/kg.K]
global cv % specific heat capacity at constant volume [J/kg.K]
global gama % ratio: cp/cv
global mu0 % dynamic viscosity at reference temp t0 [kg.m/s]
global t0 t_suth % reference temp. [K], Sutherland constant [K]
global prandtl % Prandtl number
% operat
global pmean % mean (charge) pressure [Pa]
global tk tr th % cooler, regenerator, heater temperatures [K]
global freq omega % cycle frequency [herz], [rads/s]
global mgas % total mass of gas in engine [kg]
% new data file
global new fid

new = input('Create a new data file? (y/n)','s');
if strncmp(new,'y',1)
	filename = input('enter new filename: ','s');
	fid = fopen(filename,'w');
else
	fid = 0;
	while fid < 1
		filename = input('open filename: ','s');
		[fid, message] = fopen(filename,'r');
		if fid == -1
			display(message)
        	display('press ^C to exit')
		end
	end
end
engine
heatex
gas
operat
status = fclose(fid);
