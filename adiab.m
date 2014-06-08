function [var,dvar] = adiab
% ideal adiabatic model simulation
% Israel Urieli, 7/6/2002
% Returned values: 
%   var(22,37) array of variable values every 10 degrees (0 - 360)
%   dvar(16,37) array of derivatives every 10 degrees (0 - 360)

global tk th % cooler, heater temperatures [K]

% Row indices of the var, dvar matrices, and the y,dy variable vectors:
 TC = 1;    % Compression space temperature (K)
 TE = 2;    % Expansion space temperature (K)
 QK = 3;    % Heat transferred to the cooler (J)
 QR = 4;    % Heat transferred to the regenerator (J)
 QH = 5;    % Heat transferred to the heater (J)
 WC = 6;    % Work done by the compression space (J)
 WE = 7;    % Work done by the expansion space (J)
 W  = 8;    % Total work done (WC + WE) (J)
 P  = 9;    % Pressure (Pa)
 VC = 10;   % Compression space volume (m^3)
 VE = 11;   % Expansion space volume (m^3)
 MC = 12;   % Mass of gas in the compression space (kg)
 MK = 13;   % Mass of gas in the cooler (kg)
 MR = 14;   % Mass of gas in the regenerator (kg)
 MH = 15;   % Mass of gas in the heater (kg)
 ME = 16;   % Mass of gas in the expansion space (kg)
 TCK = 17;  % Conditional temperature compression space / cooler (K)
 THE = 18;  % Conditional temeprature heater / expansion space (K)
 GACK = 19; % Conditional mass flow compression space / cooler (kg/rad)
 GAKR = 20; % Conditional mass flow cooler / regenerator (kg/rad)
 GARH = 21; % Conditional mass flow regenerator / heater (kg/rad)
 GAHE = 22; % Conditional mass flow heater / expansion space (kg/rad)
% Size of var(ROWV,COL), y(ROWV), dvar(ROWD,COL), dy(ROWD)
 ROWV = 22; % number of rows in the var matrix
 ROWD = 16; % number of rows in the dvar matrix
 COL = 37;  % number of columns in the matrices (every 10 degrees) 
%======================================================================
fprintf('============Ideal Adiabatic Analysis====================\n')
fprintf('Cooler Tk = %.1f[K], Heater Th = %.1f[K]\n', tk, th);
 epsilon = .01;  % Allowable error in temerature (K)
 max_iteration = 20;  % Maximum number of iterations to convergence
 ninc = 360; % number if integration increments (every degree)
 step = ninc/36; % for saving values in var, dvar matrices
 dtheta = 2.0*pi/ninc; % integration increment (radians)
% Initial conditions:
 y(THE) = th;
 y(TCK) = tk;
 y(TE) = th;
 y(TC) = tk;
 iter = 0;
 terror = 10*epsilon; % Initial error to enter the loop
% Iteration loop to cyclic convergence
 while ((terror >= epsilon)&(iter < max_iteration))
% cyclic initial conditions
    tc0 = y(TC);
    te0 = y(TE);
    theta = 0;
    y(QK) = 0;
    y(QR) = 0;
    y(QH) = 0;
    y(WC) = 0;
    y(WE) = 0;
    y(W) = 0;
    fprintf('iteration %d: Tc = %.1f[K], Te = %.1f[K]\n',iter,y(TC),y(TE))
    for(i = 1:1:ninc)
       [theta,y,dy] = rk4('dadiab',7,theta,dtheta,y);
    end
    terror = abs(tc0 - y(TC)) + abs(te0 - y(TE));
    iter = iter + 1;
  end

 if (iter >= max_iteration)
     fprintf('No convergence within %d iteration\n',max_iteration)
 end

 % Initial var and dvar matrix
 var = zeros(22,37);
 dvar = zeros(16,37);

 % a final cycle, to fill the var, dvar matrices
 theta=0;
 y(QK)=0;
 y(QR)=0;
 y(QH)=0;
 y(WC)=0;
 y(WE)=0;
 y(W)=0;
 [var,dvar] = filmatrix(1,y,dy,var,dvar);
 for(i = 2:1:COL)
     for(j = 1:1:step)
         [theta,y,dy] = rk4('dadiab',7,theta,dtheta,y);
     end
     [var,dvar] = filmatrix(i,y,dy,var,dvar);
 end
