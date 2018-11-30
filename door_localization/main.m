%Using PHD Filters to Localize doors
close all
clear
clc

addpath('genFunc')

%Initialize Variables
landmarks = [-5, -4, -3, 0, 1, 2, 5];
meas_var =  0.05;
v_var = 0.5;
r_max = 2;
max_dist = max(abs(landmarks));

%Generate the data
[x_true, v, t, g, g_mask] = gen_data(landmarks, max_dist, r_max, v_var, meas_var);

%Plot the generator error
plot_berr(landmarks, x_true, v, t, g, g_mask)

%Run FastSLAM
%addpath('fastSLAM')
%fastslam(x_true, v, v_var, t, g, g_mask, meas_var, landmarks);
%rmpath('fastSLAM')

%Run MHTfastSLAM
%addpath('MHTfastslam')
%MHTfastslam(x_true, v, v_var, t, g, g_mask, meas_var, landmarks, r_max);
%rmpath('MHTfastslam')

%Run RBPHDSLAM
addpath('RBPHDSLAM')
RBPHDSLAM(x_true, v, v_var, t, g, g_mask, meas_var, landmarks, r_max);
rmpath('RBPHDSLAM')