function engine
% Define engine configuration and drive geometric parameters.
% Israel Urieli 4/14/02

global engine_type % s)inusoidal, y)oke r)ocker-V (all alpha engines)
global new fid % new data file

engine_type = 'u';
while(strncmp(engine_type,'u',1))
	if(strncmp(new,'y',1))
		fprintf('Available engine types are:\n');
		fprintf('   s)inusoidal drive\n');
		fprintf('   y)oke drive (Ross)\n');
		fprintf('   r)ocker-V drive (Ross)\n');
		engine_type = input('enter engine type ','s');
		fprintf(fid, '%c\n', engine_type(1));
	else
		engine_type = fscanf(fid, '%c',1);
	end
	if(strncmp(engine_type,'s',1))
		sindrive;    
	elseif(strncmp(engine_type,'y',1)) 
		yokedrive;    
    elseif(strncmp(engine_type,'r',1))
        rockerVdrive;
	else
		fprintf('engine type is undefined\n')
		engine_type = 'u';
   end
end
%==============================================================
function sindrive
% Sinusoidal drive engine configuration
% Israel Urieli 4/14/02

global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global new fid % new data file

fprintf('sinusoidal drive engine configuration\n')
if(strncmp(new,'y',1))
	vclc = input('enter compression space clearence volume [m^3]: ');
	vswc = input('enter compression space swept volume [m^3]: ');
	vcle = input('enter expansion space clearence volume [m^3]: ');
	vswe = input('enter expansion space swept volume [m^3]: ');
	phase = input('enter expansion phase angle advance [degrees]: ');
	fprintf(fid, '%.3e\n', vclc);
	fprintf(fid, '%.3e\n', vswc);
	fprintf(fid, '%.3e\n', vcle);
	fprintf(fid, '%.3e\n', vswe);
	fprintf(fid, '%.1f\n', phase);
else
	vclc = fscanf(fid,'%e',1);
	vswc = fscanf(fid,'%e',1);
	vcle = fscanf(fid,'%e',1);
	vswe = fscanf(fid,'%e',1);
	phase = fscanf(fid, '%f',1);
end
fprintf('\nsinusoidal drive engine data summary:\n');
fprintf(' comp clearence,swept vols %.1f, %.1f [cm^3]\n', vclc*1e6,vswc*1e6);
fprintf(' exp clearence,swept vols %.1f, %.1f [cm^3]\n', vcle*1e6,vswe*1e6);
fprintf(' expansion phase angle advance %.1f[degrees]\n', phase);
alpha = phase * pi/180;
%==============================================================
function yokedrive
% Ross yoke drive engine configuration
% Israel Urieli 4/14/02

global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global b1 % Ross yoke length (1/2 yoke base) [m]
global b2 % Ross yoke height [m]
global crank % crank radius [m]
global dcomp dexp % diameter of compression/expansion pistons [m]
global acomp aexp % area of compression/expansion pistons [m^2]
global ymin % minimum yoke vertical displacement [m]
global new fid % new data file

fprintf('Ross yoke drive engine configuration\n');
if(strncmp(new,'y',1))
	vclc = input('enter compression space clearence volume [m^3]: ')
	vcle = input('enter expansion space clearence volume [m^3]: ');

	b1 = input('enter Ross yoke length b1 (1/2 yoke base) [m]: ');
	b2 = input('enter Ross yoke height b2 [m]: ');
	crank = input('enter crank radius [m]: ');

	dcomp = input('enter compression piston diameter [m]: ');
	dexp = input('enter expansion piston diameter [m]: ');

	fprintf(fid, '%.3e\n', vclc);
	fprintf(fid, '%.3e\n', vcle);
	fprintf(fid, '%.3e\n', b1);
	fprintf(fid, '%.3e\n', b2);
	fprintf(fid, '%.3e\n', crank);
	fprintf(fid, '%.3e\n', dcomp);
	fprintf(fid, '%.3e\n', dexp);
else
	vclc = fscanf(fid,'%e',1);
	vcle = fscanf(fid,'%e',1);
	b1 = fscanf(fid,'%e',1);
	b2 = fscanf(fid,'%e',1);
	crank = fscanf(fid, '%e',1);
	dcomp = fscanf(fid, '%e',1);
	dexp = fscanf(fid, '%e',1);
end
acomp = pi*dcomp^2/4.0;
aexp = pi*dexp^2/4.0;
yoke = sqrt(b1^2 + b2^2);
ymax = sqrt((yoke + crank)^2 - b2^2);
ymin = sqrt((yoke - crank)^2 - b2^2);

vswc = acomp*(ymax - ymin);
vswe = aexp*(ymax - ymin);
thmaxe = asin(ymax/(yoke + crank));
thmaxc = pi - thmaxe;
thmine = pi + asin(ymin/(yoke - crank));
thminc = 3*pi - thmine;
alpha = 0.5*(thmaxc - thmaxe) + 0.5*(thminc - thmine);
phase = alpha*180/pi;

fprintf('\nRoss yoke drive engine data summary:\n');
fprintf(' yoke length b1 (1/2 yoke base) %.1f [mm]\n', b1*1e3);
fprintf(' yoke height b2 %.1f [mm]\n', b2*1e3);
fprintf(' crank radius %.1f [mm]\n', crank*1e3);
fprintf(' compression piston diameter %.1f [mm]\n', dcomp*1e3);
fprintf(' expansion piston diameter %.1f [mm]\n', dexp*1e3);
fprintf(' comp clearence,swept vols %.1f, %.1f [cm^3]\n', vclc*1e6,vswc*1e6);
fprintf(' exp clearence,swept vols %.1f, %.1f [cm^3]\n', vcle*1e6,vswe*1e6);
fprintf(' ymin = %.1f(cm), ymax = %.1f(cm)\n',ymin*1e2,ymax*1e2)
fprintf(' alpha = %.1f(degrees)\n',phase);
%==============================================================
function rockerVdrive
% Ross rocker-V drive engine configuration
% Israel Urieli 4/14/02 & Martine Long 2/14/05

global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global crank % crank radius [m]
global dcomp dexp % diameter of compression/expansion pistons [m]
global acomp aexp % area of compression/expansion pistons [m^2]
global conrodc conrode % length of comp/exp piston connecting rods [m]
global ycmax yemax % maximum comp/exp piston vertical displacement [m]
global new fid % new data file

fprintf('Ross rocker-V drive engine configuration\n');
if(strncmp(new,'y',1))
    vclc = input('enter compression space clearence volume [m^3]: ')
    vcle = input('enter expansion space clearence volume [m^3]: ');
    crank = input('enter crank radius [m]: ');
    conrodc = input('enter compression piston connecting rod length [m]: ');
    conrode = input('enter expansion piston connecting rod length [m]: ');
    dcomp = input('enter compression piston diameter [m]: ');
    dexp = input('enter expansion piston diameter [m]: ');
    phase = input('enter expansion phase angle advance [degrees]: ');
    
    fprintf(fid, '%.3e\n', vclc);
    fprintf(fid, '%.3e\n', vcle);
    fprintf(fid, '%.3e\n', crank);
    fprintf(fid, '%.3e\n', conrodc);
    fprintf(fid, '%.3e\n', conrode);
    fprintf(fid, '%.3e\n', dcomp);
    fprintf(fid, '%.3e\n', dexp);
    fprintf(fid, '%.1f\n', phase);
else
    vclc = fscanf(fid,'%e',1);
    vcle = fscanf(fid,'%e',1);
    crank = fscanf(fid,'%e',1);
    conrodc = fscanf(fid,'%e',1);
    conrode = fscanf(fid,'%e',1);
    dcomp = fscanf(fid,'%e',1);
    dexp = fscanf(fid,'%e',1);
    phase = fscanf(fid,'%f',1);
end
acomp = pi*dcomp^2/4.0;
aexp = pi*dexp^2/4.0;
ycmax = conrodc + crank;
ycmin = conrodc - crank;
yemax = conrode + crank;
yemin = conrode - crank;
vswc = acomp*(ycmax - ycmin);
vswe = aexp*(yemax - yemin);

fprintf('\nRoss rocker-V drive engine data summary:\n');
fprintf(' crank radius %.1f [mm]\n', crank*1e3);
fprintf(' compression piston connecting rod length %.1f [mm]\n', conrodc*1e3);
fprintf(' expansion piston connecting rod length %.1f [mm]\n', conrode*1e3);
fprintf(' compression piston diameter  %.1f [mm]\n', dcomp*1e3);
fprintf(' expansion piston diameter %.1f [mm]\n', dexp*1e3);
fprintf(' comp clearence,swept vols %.1f, %.1f [cm^3]\n', vclc*1e6,vswc*1e6);
fprintf(' exp clearence,swept vols %.1f, %.1f [cm^3]\n', vcle*1e6,vswe*1e6);
fprintf(' COMPRESSION ymin = %.1f(cm), ymax = %.1f(cm)\n',ycmin*1e2,ycmax*1e2)
fprintf(' EXPANSION ymin = %.1f(cm), ymax = %.1f(cm)\n',yemin*1e2,yemax*1e2)
fprintf(' expansion phase angle advance %.1f[degrees]\n', phase);
alpha = phase * pi/180;
%==============================================================

