% parameters of real network 210 East
% Load the existing data
load('large_scale_params.mat')
% segment topology
params.has_or = has_orp;
% freeflow speed
params.v = v;
% congestion wave speed
params.w = w;
% split ratios
params.beta = beta;
% or demands
demand_ind = find(demand_constant);
params.d = demand_constant(demand_ind);
% ml demands
n_seg = numel(v);
params.d_up = [upstream_demand_constant;zeros(n_seg-1,1)];
% capacities
params.f_bar = f_bar;
% jam densities
params.n_bar = n_jam;
% or capacities
params.r_bar = r_bar;