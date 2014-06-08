function regen
% Specifies regenerator geometric and thermal properties
% Israel Urieli 04/20/02 (modified 12/01/03)
% modified 2/12/2010 to include awgr0 (wetted area)
% modified 11/27/2010 to include 'no regenerator matrix'


global lr % regenerator effective length [m]
global awgr0 % no matrix regenerator wetted area [m^2]
global cqwr % regenerator housing thermal conductance [W/K]
global new fid % new data file

regen_type = 'u';
while(strncmp(regen_type,'u',1))
	if(strncmp(new,'y',1))
   		fprintf('Available regenerator configurations are:\n')
   		fprintf('   t, for tubular regenerator set\n')
   		fprintf('   a, for annular regenerator\n')
  	 	regen_type = input('enter regenerator configuration ','s');
		fprintf(fid, '%c\n', regen_type(1));
	else
		fscanf(fid, '%c',1); % bypass the previous newline character
		regen_type = fscanf(fid, '%c',1);
	end
   	if(strncmp(regen_type,'t',1))
      	fprintf('tubular regenerator housing\n')
		if(strncmp(new,'y',1))
      		dout = input('enter tube housing external diameter [m] : ');
      		domat = input('enter tube housing internal diameter [m] : ');
	  		lr = input('enter regenerator length [m] : ');
     		num = input('enter number of tubes : ');
			fprintf(fid, '%.3e\n', dout);
			fprintf(fid, '%.3e\n', domat);
			fprintf(fid, '%.3e\n', lr);
			fprintf(fid, '%d\n', num);
		else
			dout = fscanf(fid, '%e',1);
			domat = fscanf(fid, '%e',1);
			lr = fscanf(fid, '%e',1);
			num = fscanf(fid, '%d',1);
		end
	  	dimat = 0; 
        awgr0 = num*pi*domat*lr;
   	elseif(strncmp(regen_type,'a',1)) 
      	fprintf('annular regenerator housing\n')
		if(strncmp(new,'y',1))
     		dout = input('enter housing external diameter [m] : ');
      		domat = input('enter housing internal diameter [m] : ');
      		dimat = input('enter matrix internal diameter [m] : ');
	  		lr = input('enter regenerator length [m] : ');
			fprintf(fid, '%.3e\n', dout);
			fprintf(fid, '%.3e\n', domat);
			fprintf(fid, '%.3e\n', dimat);
			fprintf(fid, '%.3e\n', lr);
		else
			dout = fscanf(fid, '%e',1);
			domat = fscanf(fid, '%e',1);
			dimat = fscanf(fid, '%e',1);
			lr = fscanf(fid, '%e',1);
		end
	  	num = 1;
        awgr0 = pi*(dimat + domat)*lr;
   else
      fprintf('regenerator configuration is undefined\n')
      regen_type = 'u';
   end
end

amat = num*pi*(domat*domat - dimat*dimat)/4; % regen matrix area
awr = num*pi*(dout*dout - domat*domat)/4; % regen housing wall area
%########temporary fix (4/20/02):
kwr = 25; % thermal conductivity [W/m/K]
% note that stainless steel thermal conductivity is temp dependent
%   25 W/m/K for normal engine conditions,
%    6 W/m/K for cryogenic coolers.
cqwr = kwr*awr/lr; % regen wall thermal conductance [W/K]

matrix(amat);
%===============================================================
function matrix(amat)
% Specifies regenerator matrix geometric and thermal properties
% Israel Urieli 03/31/02
% modified 11/27/10 for no regenerator matrix

global matrix_type % m)esh, f)oil or n)o matrix
global new fid % new data file

matrix_type = 'u';
while(strncmp(matrix_type,'u',1))
	if(strncmp(new,'y',1))
   		fprintf('Available matrix types are:\n')
   		fprintf('   m, for mesh matrix\n')
   		fprintf('   f, for foil matrix\n')
        fprintf('   n, for no matrix\n')
  		matrix_type = input('enter matrix type ','s');
		fprintf(fid, '%c\n', matrix_type(1));
	else
		fscanf(fid, '%c',1); % bypass the previous newline character
		matrix_type = fscanf(fid, '%c',1);
	end
   	if(strncmp(matrix_type,'m',1))
	 	mesh(amat); 
   	elseif(strncmp(matrix_type,'f',1)) 
	  	foil(amat); 
   	elseif(strncmp(matrix_type,'n',1)) 
	  	nomatrix(amat); 
   	else
      	fprintf('matrix configuration is undefined\n')
     	matrix_type = 'u';
  	end
end
%===============================================================
function mesh(amat)
% Specifies mesh matrix geometric and thermal properties
% Israel Urieli 03/31/02

global vr % regen void volume [m^3]
global ar % regen internal free flow area [m^2]
global awgr % regen internal wetted area [m^2]
global awgr0 % no matrix regenerator wetted area [m^2]
global lr % regenerator effective length [m]
global dr % regen hydraulic diameter [m]
global new fid % new data file

fprintf(' stacked wire mesh matrix\n')
if(strncmp(new,'y',1))
	porosity = input('enter matrix porosity : ');
	dwire = input('enter matrix wire diameter [m] : ');
	fprintf(fid, '%.3f\n', porosity);
	fprintf(fid, '%.3e\n', dwire);
else
	porosity = fscanf(fid,'%f',1);
	dwire = fscanf(fid,'%e',1);
end

ar = amat*porosity;
vr = ar*lr;
dr = dwire*porosity/(1 - porosity);
awgr = 4*vr/dr + awgr0;

fprintf(' matrix porosity: %.3f\n', porosity)
fprintf(' matrix wire diam %.2f(mm)\n', dwire*1e3)
fprintf(' hydraulic diam %.3f(mm)\n', dr*1e3)
fprintf(' total wetted area %.3e(sq.m)\n', awgr)
fprintf(' regenerator length %.1f(mm)\n', lr*1e3)
fprintf(' void volume %.2f(cc)\n', vr*1e6)
%===============================================================
function foil(amat)
% Specifies foil matrix geometric and thermal properties
% Israel Urieli 03/31/02

global vr % regen void volume [m^3]
global ar % regen internal free flow area [m^2]
global awgr % regen internal wetted area [m^2]
global awgr0 % no matrix regenerator wetted area [m^2]
global lr % regenerator effective length [m]
global dr % regen hydraulic diameter [m]
global new fid % new data file

fprintf(' wrapped foil matrix\n')
if(strncmp(new,'y',1))
	fl = input('enter unrolled length of foil [m] : ');
	th = input('enter foil thickness [m] : ');
	fprintf(fid, '%.3f\n', fl);
	fprintf(fid, '%.3e\n', th);
else
	fl = fscanf(fid,'%f',1);
	th = fscanf(fid,'%e',1);
end

am = th*fl;
ar = amat - am;
vr = ar*lr;
awgr = 2*lr*fl + awgr0;
dr = 4*vr/awgr;
porosity = ar/amat;

fprintf(' unrolled foil length: %.3f(m)\n', fl)
fprintf(' foil thickness %.3f(mm)\n',th*1e3)
fprintf(' hydraulic diam %.3f(mm)\n', dr*1e3)
fprintf(' total wetted area %f(sq.m)\n', awgr)
fprintf(' void volume %.2f(cc)\n', vr*1e6)
fprintf(' porosity %.3f\n', porosity)
%===============================================================
function nomatrix(amat)
% Specifies conditions for no regenerator matrix
% Israel Urieli 11/27/10

global vr % regen void volume [m^3]
global ar % regen internal free flow area [m^2]
global awgr % regen internal wetted area [m^2]
global awgr0 % no matrix regenerator wetted area [m^2]
global lr % regenerator effective length [m]
global dr % regen hydraulic diameter [m]

fprintf(' no regenerator matrix\n')

ar = amat;
vr = ar*lr;
awgr = awgr0;
dr = 4*vr/awgr;

fprintf(' hydraulic diam %.3f(mm)\n', dr*1e3)
fprintf(' total wetted area %f(sq.m)\n', awgr)
fprintf(' void volume %.2f(cc)\n', vr*1e6)
%===============================================================

