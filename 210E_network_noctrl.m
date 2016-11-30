% x is the primary variable of optimization problem
% alpha's are the prices
% n : mainline density
% l : onramp density
% f : mainline flows
% r : onramp flows 
clear all;
close all;
clc;
% network data
network_210East;
%% initial condition
n_segment = size(params.v,1);
n_or = size(find(params.has_or),1);

n0 = 50*ones(n_segment,1);
l0 = 10*ones(n_or,1);
%% Charaterizing feasibility of arrivals
or_it = 0;
f_ss = zeros(n_seg,1);
if params.has_or(1)
    or_it = or_it + 1;
    f_ss(1,1) = (1-params.beta(1))*(params.d_up(1)+params.d(or_it));
else
    f_ss(1,1) = (1-params.beta(1))*(params.d_up(1)+params.d(or_it));
end

for j = 2:n_seg
    if params.has_or(j)
        or_it = or_it + 1;
        f_ss(j) = (1-params.beta(j))*(f_ss(j-1)+params.d(or_it));
    else
        f_ss(j) = (1-params.beta(j))*(f_ss(j-1));
    end
    if f_ss(j) > params.f_bar(j)
        warning('infeasible arrival')
    end
end
%% setting up the optimization
% n_seg = size(params.v,1);
% n_or = size(find(params.has_or),1);
n_cur = n0;
l_cur = l0;
max_iter = 200;
% preallocation

n = zeros(n_seg,max_iter+1);
l = zeros(n_or, max_iter+1);
f = zeros(n_seg, max_iter);
r = zeros(n_or, max_iter);
n(:,1) = n0;
l(:,1) = l0;
%% iterative control

for iter = 1:max_iter
    % control input
    r_cur = min(l_cur + params.d, params.r_bar);
    r_cur = max(r_cur,zeros(n_or,1));
    % evolve model
    [n_next, l_next, f_cur] = fwyDynamics(n_cur, l_cur, r_cur, params);
    % storage
    n(:,iter+1) = n_next;
    l(:,iter+1) = l_next;
    f(:,iter) = f_cur;
    r(:,iter) = r_cur;
    % updating current density
    n_cur = n_next;
    l_cur = l_next;
end
%% plotting
figure('name','n');
plot(n','LineWidth',2);
legend('n_1','n_2','n_3')
figure('name','l');
plot(l','LineWidth',2);
legend('l_1','l_2','l_3')
figure('name','f');
plot(f','LineWidth',2);
legend('f_1','f_2','f_3')
figure('name','r');
plot(r','LineWidth',2);
legend('r_1','r_2','r_3')
figure('name','x');
plot(x','LineWidth',2);
legend('x_1','x_2','x_3')

%% 
figure;
plot(l_cur','b');
figure;
plot(r_cur','r');
figure;
plot(params.d','k');