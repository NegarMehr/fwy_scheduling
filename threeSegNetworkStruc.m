%% vectorized network data
% segment topology
% params.has_or = [1;1;1];
params.has_or = [1;0;1];
% freeflow speed
params.v = [0.6;0.6;0.6];
% congestion wave speed
params.w = [0.2;0.2;0.2];
% split ratios
params.beta = [0.2;0.2;0];
% or demands
params.d = [0.5;1.4];
% ml demands
params.d_up = [3.5;0;0];
% capacities
params.f_bar = [4;4;4];
% jam densities
params.n_bar = (1./params.v + 1./params.w).*params.f_bar;
% or capacities
params.r_bar = [2;2];
