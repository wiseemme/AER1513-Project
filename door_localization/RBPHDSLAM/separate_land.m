function [particles_obs_land, particles] = separate_land(particles, r_max)
%Separate the particles landmark's into observed an unobserved
%Initialize Variables
numParticles = length(particles);
particles_obs_land = particles;

for i = 1: numParticles
    robot = particles(i).pose;
    expg = abs([particles(i).landmarks.mu] - robot);
    unobs_ids = find(expg > r_max);
    obs_ids = find(expg < r_max);
    particles_obs_land(i).landmarks(unobs_ids) = [];
    particles(i).landmarks(obs_ids) = [];
end
end