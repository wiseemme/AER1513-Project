%% Generate Door Location Measurements
function [meas, mask] = gen_door(x, l, sigma, r_max)
    %Initialize Variables
    num_land = length(l);
    num_pose = length(x);
    mask = ones([num_pose, num_land]);
    meas = zeros([num_pose, num_land]);
    
    %Calculate the true measurement and add gausian noise
    for i=1:num_pose
        meas_true = l - x(i) * ones([1, num_land]);
        noise = normrnd(0, sigma, [1, num_land]);
        meas(i, :) = meas_true + noise;
   
    %Mask landmarks out of range
        for j=1:num_land(1)
            if abs(meas_true(1,j)) > r_max
                mask(i,j) = 0;
            end
        end
    end
end
