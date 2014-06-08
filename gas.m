function gas
% specifies the working gas properties (he, h2, air)
% Israel Urieli 4/20/02

global rgas % gas constant [J/kg.K]
global cp % specific heat capacity at constant pressure [J/kg.K]
global cv % specific heat capacity at constant volume [J/kg.K]
global gama % ratio: cp/cv
global mu0 % dynamic viscosity at reference temp t0 [kg.m/s]
global t0 t_suth % reference temperature [K], Sutherland constant [K]
global prandtl % Prandtl number
global new fid % new data file

gas_type = 'un';
while(strncmp(gas_type,'un',2))
	if(strncmp(new,'y',1))
		fprintf('Available gas types are:\n');
		fprintf('   hy)drogen)\n');
		fprintf('   he)lium\n');
		fprintf('   ai)r\n');
   		gas_type = input('enter gas type: ','s');
		gas_type = [gas_type(1), gas_type(2)];
		fprintf(fid, '%s\n', gas_type);
	else
		fscanf(fid, '%c',1); % bypass the previous newline character
		gas_type = fscanf(fid, '%c',2);
	end
    if(strncmp(gas_type,'hy',2))
       fprintf('gas type is hydrogen\n')
       gama = 1.4;    
       rgas = 4157.2; 
       mu0 = 8.35e-6; 
       t_suth = 84.4; 
   	elseif(strncmp(gas_type,'he',2)) 
      	fprintf('gas type is helium\n')
      	gama = 1.67;    
      	rgas = 2078.6; 
      	mu0 = 18.85e-6; 
      	t_suth = 80.0; 
   	elseif(strncmp(gas_type,'ai',2)) 
      	fprintf('gas type is air\n')
      	gama = 1.4;    
      	rgas = 287.0; 
      	mu0 = 17.08e-6; 
      	t_suth = 112.0; 
   	else
      	fprintf('gas type is undefined\n')
	  	gas_type = 'un';
   	end
end
cv = rgas/(gama - 1); 
cp = gama*cv;        
t0 = 273;     
prandtl = 0.71;  

