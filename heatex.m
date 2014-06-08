function heatex
% Specify heat exchanger geometric parameters 
% Israel Urieli 3/31/02 (modified 12/01/03)
% Modified 2/14/2010 annulus and slots wetted area
cooler;
regen;
heater;
%========================================================
function cooler
% Specify cooler geometric parameters 
% Israel Urieli 4/15/02

global vk % cooler void volume [m^3]
global ak % cooler internal free flow area [m^2]
global awgk % cooler internal wetted area [m^2]
global dk % cooler hydraulic diameter [m]
global lk % cooler effective length [m]
global new fid % new data file

cooler_type = 'u';
while(strncmp(cooler_type,'u',1))
	if(strncmp(new,'y',1))
		fprintf('Available cooler types are:\n')
   		fprintf('   p, for smooth pipes\n')
   		fprintf('   a, for smooth annulus\n')
   		fprintf('   s, for slots\n')
   		cooler_type = input('enter cooler type ','s');
		fprintf(fid, '%c\n', cooler_type(1));
	else
		fscanf(fid, '%c',1); % bypass the previous newline character
		cooler_type = fscanf(fid, '%c',1);
	end
   	if(strncmp(cooler_type,'p',1))
      	[vk,ak,awgk,dk,lk] = pipes;    
  	elseif(strncmp(cooler_type,'a',1)) 
      	[vk,ak,awgk,dk,lk] = annulus;    
   	elseif(strncmp(cooler_type,'s',1)) 
      	[vk,ak,awgk,dk,lk] = slots;    
   	else
      	fprintf('cooler type is undefined\n')
      	cooler_type = 'u';
   	end
end
fprintf('cooler data summary:\n');
fprintf(' void volume(cc) %.2f\n', vk*1e6)
fprintf(' free flow area (cm^2) %.2f\n', ak*1e4)
fprintf(' wetted area (cm^2) %.2f\n', awgk*1e4)
fprintf(' hydraulic diameter(mm) %.2f\n', dk*1e3)
fprintf(' cooler length (cm) %.2f\n', lk*1e2)

%========================================================
function heater
% Specify heater geometric parameters 
% Israel Urieli 4/15/02

global vh % heater void volume [m^3]
global ah % heater internal free flow area [m^2]
global awgh % heater internal wetted area [m^2]
global dh % heater hydraulic diameter [m]
global lh % heater effective length [m]
global new fid % new data file

heater_type = 'u';
while(strncmp(heater_type,'u',1))
	if(strncmp(new,'y',1))
		fprintf('Available heater types are:\n')
   		fprintf('   p, for smooth pipes\n')
   		fprintf('   a, for smooth annulus\n')
   		fprintf('   s, for slots\n')
   		heater_type = input('enter heater type ','s');
		fprintf(fid, '%c\n', heater_type(1));
	else
		fscanf(fid, '%c',1); % bypass the previous newline character
		heater_type = fscanf(fid, '%c',1);
	end
    if(strncmp(heater_type,'p',1))
      	[vh,ah,awgh,dh,lh] = pipes;    
   	elseif(strncmp(heater_type,'a',1)) 
      	[vh,ah,awgh,dh,lh] = annulus;    
   	elseif(strncmp(heater_type,'s',1)) 
      	[vh,ah,awgh,dh,lh] = slots;    
   	else
      	fprintf('heater type is undefined\n')
     	heater_type = 'u';
   	end
end
fprintf('heater data summary:\n');
fprintf(' void volume(cc) %.2f\n', vh*1e6)
fprintf(' free flow area (cm^2) %.2f\n', ah*1e4)
fprintf(' wetted area (cm^2) %.2f\n', awgh*1e4)
fprintf(' hydraulic diameter(mm) %.2f\n', dh*1e3)
fprintf(' heater length (cm) %.2f\n', lh*1e2)

%========================================================
function [v,a,awg,d,len] = pipes
% homogeneous smooth pipes heat exchanger 
% Israel Urieli 4/15/02
global new fid % new data file

fprintf('homogeneous bundle of smooth pipes\n')
if(strncmp(new,'y',1))
	d = input('enter pipe inside diameter [m] : ');
	len = input('enter heat exchanger length [m] : ');
	num = input('enter number of pipes in bundle : ');
	fprintf(fid, '%.3e\n', d);
	fprintf(fid, '%.3e\n', len);
	fprintf(fid, '%d\n', num);
else
	d = fscanf(fid,'%e',1);
	len = fscanf(fid,'%e',1);
	num = fscanf(fid,'%d',1);
end
a = num*pi*d*d/4;
v = a*len;
awg = num*pi*d*len;
%========================================================
function [v,a,awg,d,len] = annulus
% annular gap heat exchanger 
% Israel Urieli 12/01/03
% Modified 2/14/2010 wetted area
global new fid % new data file

fprintf(' annular gap heat exchanger\n')
if(strncmp(new,'y',1))
	dout = input('enter annular gap outer diameter [m] : ');
	din = input('enter annular gap inner diameter [m] : ');
	len = input('enter heat exchanger length [m] : ');
	fprintf(fid, '%.3e\n', dout);
	fprintf(fid, '%.3e\n', din);
	fprintf(fid, '%.3e\n', len);
else
	dout = fscanf(fid,'%e',1);
	din = fscanf(fid,'%e',1);
	len = fscanf(fid,'%e',1);
end

a = pi*(dout*dout - din*din)/4;
v = a*len;
awg = pi*dout*len;
d = dout - din;
%========================================================
function [v,a,awg,d,len] = slots
% slots heat exchanger 
% Israel Urieli 12/01/03
% Modified 2/14/2010 wetted area
global new fid % new data file

fprintf(' slots heat exchanger\n')
if(strncmp(new,'y',1))
	w = input('enter width of slot [m] : ');
	h = input('enter height of slot [m] : ');
	len = input('enter heat exchanger length [m] : ');
	num = input('enter number of slots : ');
	fprintf(fid, '%.3e\n', w);
	fprintf(fid, '%.3e\n', h);
	fprintf(fid, '%.3e\n', len);
	fprintf(fid, '%d\n', num);
else
	w = fscanf(fid,'%e',1);
	h = fscanf(fid,'%e',1);
	len = fscanf(fid,'%e',1);
	num = fscanf(fid,'%d',1);
end

a = num*w*h;
v = a*len;
awg = num*(w + 2*h)*len;
d = 4*v/awg;
%========================================================



