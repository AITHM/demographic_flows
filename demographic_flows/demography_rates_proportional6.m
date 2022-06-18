function flow_across_demographic_states = demography_rates_proportional6(time_points, states_at_time_points)
% for this function to work, the time_points argument needs to be a vector
% states_at_time_points must be a matrix with second dimension the same
% size as the time vector
if nargin ~= 2,
    disp('Need both time points and state value inputs'),
    return
end
if length(time_points) ~= size(states_at_time_points, 2),
    disp('number of time-points and number of state observations (last dimension) must be equal'),
    return
end
number_of_state_observations=length(time_points);
size_states_at_time_points = size(states_at_time_points);
% reshape states if it is greater than 2 dimensions
states_at_time_points_long = reshape(states_at_time_points, prod(size_states_at_time_points(1:end-1)), size_states_at_time_points(end));
% set up a matrix for the return values
flow_across_demographic_states = zeros(size(states_at_time_points_long, 1), size(states_at_time_points_long, 1), number_of_state_observations-1);
for state_transition = 1:number_of_state_observations-1
    % get the values relavent to this transition
    delta_t = time_points(state_transition+1) - time_points(state_transition);
    state_0 = states_at_time_points_long(:, state_transition);
    state_1 = states_at_time_points_long(:, state_transition+1);
    state_growth_rate = zeros(size(state_1));
    state_growth_rate_matrix = zeros(length(state_growth_rate));
    % tricky transition is from positive to zero -> need to avoid -INF rate
    % rather than transition to zero, transition to one thousandth
    f_state1_zero = find(state_1==0);
    state_1(f_state1_zero) = state_0(f_state1_zero)/1000;
    % these are the easy transitions, treat like scalar transition
    f_pos = find(state_0 > 0); %identify all states that have a positive starting point
    state_growth_rate(f_pos) = log(state_1(f_pos)./state_0(f_pos));
    state_growth_rate_matrix = diag(state_growth_rate);
    
    % other tricky values, states growing from a zero start
    f_zero=find(state_0==0 & state_1 > 0);
    if length(f_zero)>0,

    % calculate the integral of the values of positive states over the transition
        AUC=state_0(f_pos).*(exp(state_growth_rate(f_pos))-1)./(state_growth_rate(f_pos)); 

        % assign these flows to the zero starting point states
        rate_flow_into_zeros = state_1(f_zero)./sum(AUC);
        extra_flows = rate_flow_into_zeros*ones(1, length(f_pos));
        state_growth_rate_matrix(f_zero, f_pos) = extra_flows;

    % scale by time between states
        
    end
    state_growth_rate_matrix = state_growth_rate_matrix/delta_t;
    flow_across_demographic_states(:, :, state_transition) = state_growth_rate_matrix;

end