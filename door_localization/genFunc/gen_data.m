function [x_true, v, t, g, g_mask] = gen_data(landmarks, max_dist, r_max, v_var, meas_var)
%Generate the data for the simulation
%Generate the path
[x_true, v, t] = gen_path(max_dist, sqrt(v_var));

%Make measurement
[g, g_mask] = gen_door(x_true, landmarks, sqrt(meas_var), r_max);
end