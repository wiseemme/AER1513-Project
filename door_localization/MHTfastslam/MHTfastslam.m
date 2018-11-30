function MHTfastslam(x_true, v, v_var, t, g, g_mask, g_var, landmarks, r_max)
%A FastSLAM algorithm for the 1D door localization problem
%Set the number of particles
numParticles = 100;

%Initialize the particles array
particles = struct;
for i = 1:numParticles
    particles(i).weight = 1. / numParticles;
    particles(i).pose = x_true(1);
    particles(i).history = {x_true(1)};
    
    % Initialize the landmarks aka the map
     particles(i).landmarks = struct;
%     particles(i).landmarks(1).mu = double.empty;    % 2D position of the landmark
%     particles(i).landmarks(1).sigma = double.empty; % Covariance of the landmark
end

%Initialize Figure
f = figure();

for i = 2: length(t)
    %Print time step
    sprintf('timestep = %d\n', t);
    
    %Perform the prediction step of the Particle Filter
    T = t(i) - t(i-1);
    particles = prediction_step(particles, T, v(i), v_var);
    
    %Perform the correction step of the Particle Filter
    particles = correction_step(particles, g(i, :), g_mask(i,:), g_var);
    
    %Evaluate negative landmarks and cull them
    particles = negative_prob(particles, r_max);
    
    %Plot the current state of the particle filter
    plot_state(particles, landmarks, x_true(i), f)
    
    %Resample the particles
    particles = resample(particles);
end
[M, I] = max([particles.weight]);
path_est = [particles(I).history{:}];
error = x_true - path_est';
figure
plot(t, error)
xlabel('Time [s]')
ylabel('Error [m]')

end