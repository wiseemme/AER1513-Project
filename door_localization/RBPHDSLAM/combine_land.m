function particles_obs_land = combine_land(particles, particles_obs_land)
%Combine the landmarks into one particle again
%Initialize Variables
numParticles = length(particles);

for i = 1: numParticles
    particles_obs_land(i).landmarks = [particles(i).landmarks, particles_obs_land(i).landmarks];
end
end