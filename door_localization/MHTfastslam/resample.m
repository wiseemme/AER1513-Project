function new_particles = resample(particles)
    %Number of Particles
    numParticles = length(particles);
    
    %Initialize bins for roulette wheel
    bins = zeros([numParticles + 1, 1]);
    
    %Normalize the weights
    w = [particles.weight];
    w_sum = sum(w);
    bins =[0, cumsum(w)/w_sum];
    w = num2cell(w / w_sum);
    [particles.weight] = w{:};
    
    %Define pointers of the roulette wheel
    ptrs = 0:1/numParticles:(1 - 1/numParticles);
    
    %Bin the wheel
    landed = rand;
    ptrs = ptrs + landed;
    ptrs = mod(ptrs, 1);
    new_ids = discretize(ptrs, bins, 'IncludedEdge', 'right');
    
    %Load the new particles
    new_particles = particles;
    for i = 1: numParticles
        new_particles(i)= particles(new_ids(i));
    end
end