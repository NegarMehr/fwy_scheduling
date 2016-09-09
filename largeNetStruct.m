%% vectorized network data
% segment topology
params.has_or = [0;1;0;0;0;1;0;0;0;1];
% freeflow speed
params.v = [0.6;0.6;0.6;0.6;0.6;0.6;0.6;0.6;0.6;0.6];
% congestion wave speed
params.w = [0.2;0.2;0.2;0.2;0.2;0.2;0.2;0.2;0.2;0.2];
% split ratios
params.beta = [0;0;0.2;0;0;0;0;0.2;0;0];
% or demands
params.d = [0.5;0.5;0.5];
% ml demands
params.d_up = [3;zeros(9,1)];
% capacities
params.f_bar = 4*ones(10,1);
% jam densities
params.n_bar = (1./params.v + 1./params.w).*params.f_bar;
% or capacities
params.r_bar = 2*ones(3,1);
