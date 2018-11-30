function particles = phd_filter(particles, g, g_mask, g_var)
%Perform PHD filtering
%Initialize Variables
numParticles = length(particles); %number of particles
init_num_land = 2; % The initial number of landmarks viewed
merge_thresh = 0.5;
false_rate = 0.1;
Pd = 0.5; %Probability of detection

for i = 1: numParticles
    if length(particles(i).history) == 2
        %Initialize the PHD for each particle
        particles(i) = map_initialization(particles(i), g(1,:), g_mask(1,:), g_var, init_num_land);
    else
        %Perform the PHD predictor step
        particles(i) = phdf_prediction(particles(i), g(1, :), g_mask(1, :), g_var);
    end
    
    %Perform the PHD corrector equation
    particles(i) = phdf_corrector(particles(i), g(2,:), g_mask(2,:), g_var, false_rate, Pd);
    
    %Merge and cut Gaussians for the PHD
    particles(i) = merge_prune(particles(i), merge_thresh);
    
    %Calculate the particles new weight
    particles(i) = reweight(particles(i), g_mask, false_rate);
end

%Resample the particles
particles = resample(particles);
end