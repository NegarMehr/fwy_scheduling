% parameters of real network 210 East
% Load the existing data
load('large_scale_params.mat')
end_seg = 134;
% segment topology
params.has_or = has_orp(1:end_seg);
% freeflow speed
params.v = v(1:end_seg);
% congestion wave speed
params.w = w(1:end_seg);
% split ratios
params.beta = 0.5*beta(1:end_seg);
% or demands
demand_ind = find(demand_constant(1:end_seg));
params.d = 1.2*demand_constant(demand_ind);
params.d(6,:) = 1.8;
% ml demands
n_seg = numel(v(1:end_seg));
params.d_up = 1.2*[upstream_demand_constant;zeros(n_seg-1,1)];
% capacities
params.f_bar = f_bar(1:end_seg);
% jam densities
params.n_bar = n_jam(1:end_seg);
% or capacities
or_ind = find(has_orp(1:end_seg));
params.r_bar = r_bar(or_ind);
% time varying demand
% params.d_up_tv = [upstream_demand_time_varying; zeros(n_seg-1,28800)];
% params.d_tv = demand_time_varying(demand_ind,:);

