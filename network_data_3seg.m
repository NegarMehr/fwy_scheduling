%% Network Data
sim_dt = 3;
% On-ramp Flow Blending Coefficient
% Gamma = 1;
Gamma = 0;

% Split Ratios
beta1 = 0;
% beta1 = 0;
% beta1 = 0.1;
beta2 = 0;
beta3 = 0;

% Demands
d1 = 1;
d2 = 0.8;
d3 = 0.8;
% d1 = 2;%0*0.35* sim_dt;
% %d2 =2.002;0.1*0.5 * sim_dt;
% d2 = 0.4;%0.1*0.5 * sim_dt;
% d3 = 0.4;%0.1*0.5 * sim_dt;
% %d3 = 2.0002;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Period of time we consider non-zero demands
% K_dem = 25;
K_dem = 30;
% Cool down period
K_cool = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = K_dem + K_cool;

% beta_bar = 1 - beta
beta1_bar = 1-beta1;
beta2_bar = 1-beta2;
beta3_bar = 1-beta2;
% beta3_bar = 1-beta3;

% Free Flow Speeds
v1 = 0.24135 * sim_dt;
v2 = 0.24135 * sim_dt;
v3 = 0.24135 * sim_dt;

% Congestion Wave speed
w1 = 0.06034 * sim_dt;
w2 = 0.06034 * sim_dt;
w3 = 0.06034 * sim_dt;

% Jam densities for on-ramps
l1_jam = 9;
l3_jam = 9;

% The ratio of available speed in the main-line that can be allocated to
% on-ramps
N_c = 1-w1;

% Maximum Flow(Capacity)
f1_bar = 3*0.5556 * sim_dt;
% f1_bar = 4;
% f2_bar = 4;
f2_bar = 3*0.5556 * sim_dt;
f3_bar = 3*0.5556 * sim_dt;
r1_bar = 2*0.5556 * sim_dt;
r3_bar = 2*0.5556 * sim_dt;
% Jam Densities
n1_jam = f1_bar*(1/v1/beta1_bar+1/w1);
n2_jam = f2_bar*(1/v2/beta2_bar+1/w2);
n3_jam = f2_bar*(1/v2/beta2_bar+1/w2);