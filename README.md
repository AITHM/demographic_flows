# demographic_flows
matlab code to generate demographic flows from state and time data

to run the code, 

open matlab
open test_demographic_flow
keep all scripts in the parent folder and ensure parent folder is on the path
run test_demographic flow

description of scripts and their functions
test_demographic_flow is the parent script that calls all other scripts: it takes dummy time and state vectors, generates flows and tests if flows make new states that look like the required states in the initial state vectors
demography_rates_proportional6 generates the transition matrices given a set of time steps and states
return_epi takes the initial state, the time steps and the transition matrices and returns a daily profile for the states
change to daily_specify_time_dimension takes a t,y combination and returns the values in discrete days

