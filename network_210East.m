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
params.beta = 0.5*beta;
% or demands
demand_ind = find(demand_constant);
params.d = demand_constant(demand_ind);
% params.d(6,:) = 4.5;
% ml demands
n_seg = numel(v);
params.d_up = [upstream_demand_constant;zeros(n_seg-1,1)];
% capacities
params.f_bar = f_bar;
% jam densities
params.n_bar = n_jam;
% or capacities
or_ind = find(has_orp);
params.r_bar = r_bar(or_ind);
% time varying demand
params.d_up_tv = [upstream_demand_time_varying; zeros(n_seg-1,28800)];
params.d_tv = demand_time_varying(demand_ind,:);

