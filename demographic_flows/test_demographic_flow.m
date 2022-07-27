clear
% generate some tricky random state data, with zeros
state1 = rand(5, 1);
state1(5) = 0;
state2 = rand(5, 1);
state2(1) = 0;
state3 = rand(5, 1);


% generate the time vector 
tvec=[1, 10, 100];
state_dims = [length(state1),length(tvec) ];

% collect the states at the time points into a matrix
all_states = zeros(state_dims);
all_states(:, 1) = state1;
all_states( :, 2) = state2;
all_states( :, 3) = state3;

% this function returns a array of flows that will achieve the state
% transition
demographic_flows = demography_rates_proportional6(tvec, all_states);

% this function takes the array generated (demographic_flows) and the 
% time points and returns the states: correct for the time points and
% also intermediate time values in time units (eg days)
[time_state, y_state] = return_epi(tvec, demographic_flows, state1);

ages_and_vacc_at_start = y_state(:, 1);

compare_model_and_y_at_start = [ages_and_vacc_at_start, state1]
ages_and_vacc_at_10 = y_state(:, 10);
compare_model_and_y_at_10 = [ages_and_vacc_at_10, state2]
ages_and_vacc_at_100 = y_state(:, 100);
compare_model_and_y_at_100 = [ages_and_vacc_at_100, state3]
assert(sum(abs(diff(compare_model_and_y_at_start')))<.01, "modelled first time point does not align with data")
assert(sum(abs(diff(compare_model_and_y_at_10')))<.01, "modelled second time point does not align with data")
assert(sum(abs(diff(compare_model_and_y_at_100')))<.01, "modelled third time point does not align with data")
%%
% test that output is as expected
% Create a stacked bar chart using the bar function
% showing the daily values of the states
figure(1)
bar(y_state', 1, 'stack')
% Adjust the axis limits
%axis([0 100 0 1])
set(gca, 'XTick', 1:99)
% Add title and axis labels
title('states by day')
xlabel('day')
ylabel('vaccinated')

% compare baseline values for data and model
figure(2)
bar(compare_model_and_y_at_start', .5, 'stack')
% Adjust the axis limits
%axis([.5 2.5 0 1])
set(gca, 'XTick', 1:6)
% Add title and axis labels
title('states by day')
xlabel('vaccine_status')
ylabel('proportion by age group')

% compare timepoint 2 for data and model

figure(3)
bar(compare_model_and_y_at_10', .5, 'stack')
% Adjust the axis limits
%axis([.5 2.5 0 1])
set(gca, 'XTick', 1:6)
% Add title and axis labels
title('states at 10')
ylabel('proportion by age group')

% compare timepoint 3 for data and model

figure(4)
bar(compare_model_and_y_at_100', .5, 'stack')
% Adjust the axis limits
%axis([.5 2.5 0 1])
set(gca, 'XTick', 1:6)
% Add title and axis labels
title('states at 100')
ylabel('proportion by age group')

