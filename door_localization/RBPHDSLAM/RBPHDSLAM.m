function RBPHDSLAM(x_true, v, v_var, t, g, g_mask, g_var, landmarks, r_max)
%A RBPHD Filter to solve the 1D SLAM Problem
%Initialize Variables
numParticles = 200; %Set the number of particles
merge_thresh = 0.5;

%Initialize the particles array
particles = struct;
for i = 1:numParticles
    particles(i).weight = 1. / numParticles;
    particles(i).pose = x_true(1);
    particles(i).history = {x_true(1)};
    
    % Initialize the landmarks aka the map
     particles(i).landmarks = struct;
end
%Initialize figure
f = figure();

%Loop through Time
for i = 2:length(t)
    %Calculate the time that has passed
    T = t(i) - t(i-1);
  
    %Propagate the particles through the motion model with noise
    particles = prediction_step(particles, T, v(i), v_var);
    
    %Seperate out the landmarks into observed and not
    if i > 2
        [particles_obs_land, particles] = separate_land(particles, r_max);
    else
        particles_obs_land = particles;
    end
    
    %Perform the PHD Filter steps
    particles_obs_land = phd_filter(particles_obs_land, g(i - 1:i,:), g_mask(i - 1:i,:), g_var);
    
    %Concatenate the observed landmarks and the unobserved
    if i > 2
        particles = combine_land(particles, particles_obs_land);
    else
        particles = particles_obs_land;
    end
    
end
%Plot the state
plot_state(particles, landmarks, x_true(i), f, merge_thresh)
end