function tgk = kolsim(var,twk,qrloss)
% evaluate cooler average heat transfer performance
% Israel Urieli, 7/22/2002
% Modified 2/6/2010 to include regenerator qrloss 
% Arguments:
%   var(22,37) array of variable values every 10 degrees (0 - 360)
%   twk - cooler wall temperature [K]
%   qrloss - heat loss due to imperfect regenerator [J]
% Returned values: 
%   tgk - cooler average gas temperature [K]

% Row indices of the var array:
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

global tk % cooler temperature [K]
global freq omega % cycle frequency [herz], [rads/s]
global ak % cooler internal free flow area [m^2]
global awgk % cooler internal wetted area [m^2]
global dk % cooler hydraulic diameter [m]

% Calculating the Reynolds number over the cycle
for(i = 1:1:37)
   gak(i) = (var(GACK,i) + var(GAKR,i))*omega/2;
   gk = gak(i)/ak;
   [mu,kgas,re(i)] = reynum(tk,gk,dk);
end

% Average and maximum Reynolds number
sumre=0;
remax=re(1);
for (i=1:1:36)
   sumre=sumre + re(i);
   if(re(i) > remax)
      remax = re(i);
   end
end
reavg = sumre/36;

[ht,fr] = pipefr(dk,mu,reavg); % Heat transfer coefficient
tgk = twk - (var(QK,37)-qrloss)*freq/(ht*awgk); % Heater gas temperature [K]

fprintf('============ Cooler Simple analysis =============\n')
fprintf(' Average Reynolds number : %.1f\n',reavg)
fprintf(' Maximum Reynolds number : %.1f\n',remax)
fprintf(' Heat transfer coefficient [W/m^2*K] : %.2f\n',ht)
fprintf('cooler wall/gas temperatures: Twk = %.1f[K], Tk = %.1f[K]\n',twk,tgk);

