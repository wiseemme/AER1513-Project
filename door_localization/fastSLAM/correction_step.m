function particles = correction_step(particles, g, g_mask, g_var)
%Apply the correction step to the filter 

%Number of Particles
numParticles = length(particles);

%Find Landmarks that need to be updated
l_ind = find(g_mask);

%Correct Each Particle
for i = 1:numParticles
   robot = particles(i).pose;
   %Correct Each Landmark
   for j = 1:length(l_ind)
       id = l_ind(j);
       %Landmark is viewed for the first time
       if (particles(i).landmarks(id).observed == false)
           %Set landmark Pose
           particles(i).landmarks(id).mu = robot + g(id);
           
           %Initialize the variance
           particles(i).landmarks(id).sigma = g_var;
           
           %Set the landmark to observed
           particles(i).landmarks(id).observed = true;
       else
           %Calculate the expected measurement
           expg = particles(i).landmarks(id).mu - robot;
           
           %Compute the measurement covariance
           Q = particles(i).landmarks(id).sigma + g_var;
           
           %Calculate the Kalman Gain
           K = particles(i).landmarks(id).sigma/Q;
           
           %Update the landmark position
           particles(i).landmarks(id).mu = particles(i).landmarks(id).mu + K * (g(id) - expg);
           
           %Update the Covariance
           particles(i).landmarks(id).sigma = (1 - K) * particles(i).landmarks(id).sigma;
           
           %Update the particle weight
           particles(i).weight = particles(i).weight * normpdf(g(id), expg, sqrt(Q));
       end
   end
end
end