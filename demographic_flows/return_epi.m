function [time_state, y_state] =return_epi(times_step_changes, flows_demographic, initial_state)

%flows_demographic must be an NxNxM matrix, with time_step_changes being of
%length M and initial state of length N or a matrix in which the product of
%the dimensions = N

initial_state_long = reshape(initial_state, prod(size(initial_state)), 1);
[t,y] = ode45(@ydot, [times_step_changes(1),times_step_changes(end)], initial_state_long);

% after running the ODE, convert y to daily values
[time_state, y_state_long] = change_to_daily_specify_time_dimension(t, y, 1);

% reshape y to the original shape of initial_state and the time dimension
size_init_state = size(initial_state);
size_init_state = size_init_state(size_init_state >1); 
size_yreturn = [size_init_state, length(time_state)];
y_state = reshape(y_state_long', size_yreturn);

 
    function yslope = ydot(t, y)
        % determine which of the matrices in flows_demographic should be
        % used based on the current time
    which_flow=sum(times_step_changes<=t);
    which_flow = min(which_flow, size(flows_demographic, 3));
    flows_at_t = flows_demographic(:, :, which_flow);
    yslope = flows_at_t * y;
    end


end