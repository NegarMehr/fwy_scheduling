clear all;
clc;
close all;

%% Reading the xml file

sim_dt = 3;
ptr = ScenarioPtr;
xml_address = '/Users/Negar/Desktop/UCB/Research/MPC_Ramp_Metering/MPC_Sarah/210E_joined.xml';
ptr.load(xml_address);
%% Linearizing segments

% Identifying Sources\Sinks and link parameters
is_source_link = ptr.is_source_link;
is_sink_link = ptr.is_sink_link;

% Linear indices
fwy_linear_inds = ptr.extract_linear_fwy_indices;

% Number of freeway links
n_links = numel(fwy_linear_inds);

% Table of freeway properties
link_table = ptr.get_link_table;
link_ids = link_table.id;
link_lanes = link_table.lanes;
link_v = link_table.free_flow_speed;
link_w = link_table.congestion_speed;
link_cap = link_table.capacity;
link_length = link_table.length;

% Obtaining linear link types
link_types = ptr.get_link_types;
linear_link_types = cell(n_links,1);
for i = 1:n_links
    ind = fwy_linear_inds(i);
    linear_link_types(i) = link_types(ind);
end
n_segments = sum(strcmp(linear_link_types,'Freeway'));

%% Extracting the segments parameters
% preallocating network parameters
v = zeros(n_segments-1,1,1);
w = zeros(n_segments-1,1,1);
beta = zeros(n_segments-1,1,1);
n_jam = zeros(n_segments-1,1);
f_bar = zeros(n_segments-1,1);
has_orp = zeros(n_segments-1,1);
r_bar = zeros(n_segments-1,1);
demand_time_varying = zeros(n_segments-1,288);
upstream_demand_time_varying = zeros(1,288);

% Initializing to zeros
n_segments = 0; % Number of segments
n_or = 0; % Number of on-ramps
n_fr = 0; %  Number of off-ramp
n_act_or = 0; % Number of actuated on-ramps
n_unact_or = 0; % number of unactuated on-ramps

for i = 1:(n_links-1)
    % Finding a Freeway Link
    if strcmp(linear_link_types(i),'Freeway')
        n_segments = n_segments + 1;
            ml_ind = fwy_linear_inds(i);
            mlID = link_ids(fwy_linear_inds(i));
            hasOffRamp = false;
            has_or = false;
            mlSource = false;
            
            splitRatio = 0;
            v(n_segments) = link_v(fwy_linear_inds(i))/link_length(fwy_linear_inds(i))*sim_dt;
            w(n_segments) = link_w(fwy_linear_inds(i))/link_length(fwy_linear_inds(i))*sim_dt;
            if (v(n_segments) >= 1 || w(n_segments) >= 1)
                error('sim_dt is too large')
            end
            cap = link_cap(fwy_linear_inds(i))*link_lanes(fwy_linear_inds(i))*sim_dt;
            f_bar(n_segments) = cap;
            length = link_length(fwy_linear_inds(i));
            lanes = link_lanes(fwy_linear_inds(i));
            jam_dens = cap * (1/v(n_segments)) + 1/(w(n_segments));
            n_jam(n_segments) = jam_dens* lanes;
            
            % Assigning Demand Profiles
            
            if is_source_link(ml_ind)
                upstream_demand_time_varying(1,:) =  (ptr.get_demandprofiles_with_linkIDs(mlID).demand)*3;
            end
            
            
            % Checking if it has an off-ramp or an interconnect which is a sink
            if strcmp(linear_link_types(i+1),'Off-Ramp') || ( strcmp(linear_link_types(i+1),'Interconnect') && is_sink_link(i+1) )
                fr_ind = fwy_linear_inds(i+1);
                hasOffRamp(n_segments) = true;
                frID = link_ids(fwy_linear_inds(i+1));
                fr_begin_node = ptr.get_link(fwy_linear_inds(i+1)).begin.ATTRIBUTE.node_id;
                beta(n_segments) = 0.2;
                
%                 if ~isempty(ptr.get_split_ratios_for_node_id(fr_begin_node))
%                     seg{ind}.splitRatio = ptr.get_split_ratios_for_node_id(fr_begin_node).splitratio.CONTENT;
%                     if seg{ind}.splitRatio >= 1
%                         error('Split ratio should be less than 1')
%                     end
%                 else
%                     seg{ind}.splitRatio = 0.2; % some arbitrary value
%                 end
                
                n_fr = n_fr + 1;
                % Checking if it has an off-ramp and on-ramp
                if strcmp(linear_link_types(i+2),'On-Ramp')
                    or_ind = fwy_linear_inds(i+2);
                    has_orp(n_segments,1) = true;
                    orID = link_ids(fwy_linear_inds(i+2));
                    demand_time_varying = (ptr.get_demandprofiles_with_linkIDs(orID).demand)*sim_dt;
                    n_or = n_or + 1;
                    actOrLinMap = n_act_or;
                    r_bar(n_segments,1) = link_cap(fwy_linear_inds(i+2))* link_lanes(fwy_linear_inds(i+2))*sim_dt;
                end
                
                if ( strcmp(linear_link_types(i+2),'Interconnect') && is_source_link(i+2) )
                    or_ind = fwy_linear_inds(i+2);
                    has_orp(n_segments,1) = 1;
                    ID = link_ids(fwy_linear_inds(i+2));
                    demand_time_varying = (ptr.get_demandprofiles_with_linkIDs(orID).demand)*sim_dt;
                    n_or = n_or + 1;
                    n_act_or = n_act_or + 1;
                    actOrLinMap = n_act_or;
                    r_bar(n_segments) = link_cap(fwy_linear_inds(i+2))* link_lanes(fwy_linear_inds(i+2))*sim_dt;
                end
                
            end
            % Checking if it only has an on-ramp or it has an interconnect
            % which is a source (Interconnects are considered as actuated)
            if strcmp(linear_link_types(i+1),'On-Ramp')
                or_ind = fwy_linear_inds(i+1);
                has_orp(n_segments,1) = 1;
                orID = link_ids(fwy_linear_inds(i+1));
                demand_time_varying(n_segments,:) = (ptr.get_demandprofiles_with_linkIDs(orID).demand)*sim_dt;
                n_or = n_or + 1;
                n_act_or = n_act_or + 1;
%                 actOrLinMap = n_act_or;
                r_bar(n_segments) = link_cap(fwy_linear_inds(i+1))* link_lanes(fwy_linear_inds(i+1))*sim_dt;
            end
            
            if ( strcmp(linear_link_types(i+1),'Interconnect') && is_source_link(i+1) )
                or_ind = fwy_linear_inds(i+1);
                has_orp(n_segments) = 1;
                orID = link_ids(fwy_linear_inds(i+1));
                demand_time_varying(n_segments,:) = (ptr.get_demandprofiles_with_linkIDs(orID).demand)*sim_dt;
                n_or = n_or + 1;
                n_act_or = n_act_or + 1;
                actOrLinMap = n_act_or;
                r_bar(n_segments) = link_cap(fwy_linear_inds(i+1))* link_lanes(fwy_linear_inds(i+1))*sim_dt;
            end
    end
end
%%
demand_constant = demand_time_varying(:,213);
demand_time_varying = repelem(demand_time_varying,1,100);

upstream_demand_constant = upstream_demand_time_varying(1,213);
upstream_demand_time_varying = repelem(upstream_demand_time_varying,1,100);

save large_scale_params v w beta n_jam f_bar has_orp r_bar demand_time_varying demand_constant upstream_demand_time_varying upstream_demand_constant;






