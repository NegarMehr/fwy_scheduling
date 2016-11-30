function [n_next, l_next, f_cur] = fwyDynamics(n_cur, l_cur, r_cur, params,t_cur)
%% This function is used for evolving freeway dynamics for one step
% extracting parameters
v = params.v;
w = params.w;
f_bar = params.f_bar;
n_bar = params.n_bar;
beta_bar = 1 - params.beta;
or_d = params.d_tv(:,t_cur);
ml_d = params.d_up_tv(:,t_cur);
has_or = params.has_or;
M = 5000;
% downstream densities
n_bar_dwn = [n_bar(2:end);M];
n_cur_dwn = [n_cur(2:end);0];
%% mainline flows

f_cur = min([beta_bar.* v.*(n_cur) f_bar w.*(n_bar_dwn - n_cur_dwn)],[],2);
% assigning or flows
or_ind = find(has_or);
if size(or_ind,1) ~= size(r_cur,1)
    error('Geometric mismatch')
end
r_vect = zeros(size(v,1),1);
r_cur = min(r_cur, l_cur + params.d_tv(t_cur));
r_vect(or_ind) = r_cur;
% upstream flows
f_up = [0;f_cur(1:end-1)];
%% mainline dynamics

n_next = n_cur - beta_bar.^(-1).*f_cur + r_vect + ml_d + f_up;
% or dynamics
if size(l_cur,1) ~= size(r_cur,1)
    error('Dimenstion mismatch')
end
% l_next = max(l_cur + or_d - r_cur,zeros(size(or_ind,1),1));
l_next = l_cur + or_d - r_cur;