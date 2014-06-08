function [vc,ve,dvc,dve] = volume(theta)
% determine working space volume variations and derivatives
% Israel Urieli, 7/6/2002
% Modified 2/14/2010 to include rockerV (rockdrive)
% Argument:  theta - current cycle angle [radians]
% Returned values: 
%   vc, ve - compression, expansion space volumes [m^3]
%   dvc, dve - compression, expansion space volume derivatives 

global engine_type % s)inusoidal, y)oke r)ockerV (all alpha engines)

if(strncmp(engine_type,'s',1))
	[vc,ve,dvc,dve] = sinevol(theta);
elseif(strncmp(engine_type,'y',1))
	[vc,ve,dvc,dve] = yokevol(theta);
elseif(strncmp(engine_type,'r',1))
	[vc,ve,dvc,dve] = rockvol(theta);    
end
%==============================================================

function [vc,ve,dvc,dve] = sinevol(theta)
% sinusoidal drive volume variations and derivatives
% Israel Urieli, 7/6/2002
% Argument:  theta - current cycle angle [radians]
% Returned values: 
%   vc, ve - compression, expansion space volumes [m^3]
%   dvc, dve - compression, expansion space volume derivatives 

global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
	
 vc = vclc + 0.5*vswc*(1 + cos(theta+pi));
 ve = vcle + 0.5*vswe*(1 + cos(theta + alpha+pi));
 dvc = -0.5*vswc*sin(theta+pi);
 dve = -0.5*vswe*sin(theta + alpha+pi);
%==============================================================

function [vc,ve,dvc,dve] = yokevol(theta)
% Ross yoke drive volume variations and derivatives
% Israel Urieli, 7/6/2002
% Argument:  theta - current cycle angle [radians]
% Returned values: 
%   vc, ve - compression, expansion space volumes [m^3]
%   dvc, dve - compression, expansion space volume derivatives 

global vclc vcle % compression,expansion clearence vols [m^3]
global vswc vswe % compression, expansion swept volumes [m^3]
global alpha % phase angle advance of expansion space [radians]
global b1 % Ross yoke length (1/2 yoke base) [m]
global b2 % Ross yoke height [m]
global crank % crank radius [m]
global dcomp dexp % diameter of compression/expansion pistons [m]
global acomp aexp % area of compression/expansion pistons [m^2]
global ymin % minimum yoke vertical displacement [m]
	
 sinth = sin(theta);
 costh = cos(theta);
 bth = (b1^2 - (crank*costh)^2)^0.5;
 ye = crank*(sinth + (b2/b1)*costh) + bth;
 yc = crank*(sinth - (b2/b1)*costh) + bth;

 ve = vcle + aexp*(ye - ymin);
 vc = vclc + acomp*(yc - ymin);
 dvc = acomp*crank*(costh + (b2/b1)*sinth + crank*sinth*costh/bth);
 dve = aexp*crank*(costh - (b2/b1)*sinth + crank*sinth*costh/bth); 
%==============================================================

function [vc,ve,dvc,dve] = rockvol(theta)
% Ross Rocker-V drive volume variations and derivatives
% Israel Urieli, 7/6/2002 & Martine Long 2/25/2005
% Argument:  theta - current cycle angle [radians]
% Returned values: 
%   vc, ve - compression, expansion space volumes [m^3]
%   dvc, dve - compression, expansion space volume derivatives 

global vclc vcle % compression,expansion clearence vols [m^3]
global crank % crank radius [m]
global acomp aexp % area of compression/expansion pistons [m^2]
global conrodc conrode % length of comp/exp piston connecting rods [m]
global ycmax yemax % maximum comp/exp piston vertical displacement [m]

	
 sinth = sin(theta);
 costh = cos(theta);
 beth = (conrode^2 - (crank*costh)^2)^0.5;
 bcth = (conrodc^2 - (crank*sinth)^2)^0.5;
 ye = beth - crank*sinth;
 yc = bcth + crank*costh;

 ve = vcle + aexp*(yemax - ye);
 vc = vclc + acomp*(ycmax - yc);
 dvc = acomp*crank*sinth*(crank*costh/bcth + 1);
 dve = -aexp*crank*costh*(crank*sinth/beth - 1); 

