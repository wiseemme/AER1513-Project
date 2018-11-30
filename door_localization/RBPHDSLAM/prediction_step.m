function particles = prediction_step(particles, T, v, v_var)

%Get the number of particles
numParticles = length(particles);

for i = 1:numParticles
  % sample a new pose for the particle
  r1 = normrnd(v, sqrt(v_var));
  particles(i).pose = particles(i).pose(1) + T * r1;
  
  % append the new position to the history of the particle
  particles(i).history{end+1} = particles(i).pose;
end

end