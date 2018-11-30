function particles = negative_prob(particles, r_max)
%Keep track of a log-odds for a landmarks existence
%Initialize Variables
del_lodds = 1; %log odds change per iteration
rmv_thresh = -2; %log odds level to remove a landmark from the map

%Find the number of particles
numParticles = length(particles);

%For each Particle
for i = 1:numParticles
    %Find the unobserved particles
    observed = [particles(i).landmarks(:).observed];
    unobserved = find(not(observed));
    
    %Skip the log odds negative update if all the landmarks are observed
    if isempty(unobserved)
        %Set the particles observed state back to false for next step
        for j = 1:length(particles(i).landmarks)
            particles(i).landmarks(j).observed = false;
        end
    else
        %Find which landmarks should have been observed
        unobserved_landmarks = [particles(i).landmarks(unobserved).mu];
        u_range = unobserved_landmarks - particles(i).pose;
        for j = 1:length(unobserved)
            u_id = unobserved(j);
            if abs(u_range(j)) <= r_max
                %lower the log-odds of the landmark existing if not seen
                particles(i).landmarks(u_id).lodds = particles(i).landmarks(u_id).lodds - del_lodds;
            end
        end
        
        %Remove landmarks from Particle below threshold
        particles(i) = rmvLandmarks(particles(i), rmv_thresh);
        
        %Set the particles observed state back to false for next step
        for j = 1:length(particles(i).landmarks)
            particles(i).landmarks(j).observed = false;
        end
    end
end
end