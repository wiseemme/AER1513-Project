function particles = correction_step(particles, g, g_mask, g_var)
%Apply the correction step to the filter
%Set Variables
del_lodds = 0.5; %The change in the log odds of the particle existing

%Number of Particles
numParticles = length(particles);

%Find how many features were observed
l= length(find(g_mask));

%Find which features were observed
g_id = find(g_mask);

%Correct Each Particle
for i = 1:numParticles
    robot = particles(i).pose;
    %Correct Each Landmark
    for j = 1:l
        %Landmarks are viewed for the first time
        if (length(particles(i).history) == 2)
            particles(i) = initialize_landmark(j, particles(i), robot, g(g_id(j)), g_var);
        else
            %Calculate the association probability
            id = association(particles(i), g(g_id(j)), g_var);
            
            %If new landmark initialize
            if id>length(particles(i).landmarks)
                particles(i) = initialize_landmark(id, particles(i), robot, g(g_id(j)), g_var);
            else
                %Calculate the expected measurement
                expg = particles(i).landmarks(id).mu - robot;
                
                %Compute the measurement covariance
                Q = particles(i).landmarks(id).sigma + g_var;
                
                %Calculate the Kalman Gain
                K = particles(i).landmarks(id).sigma/Q;
                
                %Update the landmark position
                particles(i).landmarks(id).mu = particles(i).landmarks(id).mu + K * (g(g_id(j)) - expg);
                
                %Update the Covariance
                particles(i).landmarks(id).sigma = (1 - K) * particles(i).landmarks(id).sigma;
                
                %Update the log odds of the landmark existing
                particles(i).landmarks(id).lodds = particles(i).landmarks(id).lodds + del_lodds;
                
                %Set the landmark id to observed
                particles(i).landmarks(id).observed = true;
                
                %Update the particle weight
                particles(i).weight = particles(i).weight * normpdf(g(g_id(j)), expg, sqrt(Q));
            end %landmark update and initialization
        end %Initialize first landmark
    end
end
end