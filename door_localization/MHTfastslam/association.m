function id = association(particles, g, g_var)
%Find the data association between a measurement and the viewed landmarks
%Get the robot pose
robot = particles.pose;

%Get the landmark information
landmark_observed = [particles.landmarks(:).observed];
landmark_mu = [particles.landmarks(:).mu];
landmark_sigma = [particles.landmarks(:).sigma];

%Find the particles that have not been observed yet
unobserved = find(landmark_observed == 0);

%Collect the unobserved landmarks
ulandmark_mu = landmark_mu(unobserved);
ulandmark_sigma = landmark_sigma(unobserved);

%Calculate the expected measurement and measurement covariance for
%unobserved landmarks
expg = ulandmark_mu - robot * ones(size(ulandmark_mu));
Q = ulandmark_sigma + g_var * ones(size(ulandmark_mu));

%Calculate the likelihood
likelihood = normpdf(g*ones(size(ulandmark_mu)), expg, sqrt(Q));
[M, I] = max(likelihood);

%Assign the ID for the Particle
if M<0.2 || isempty(unobserved)
    %If the likelihood is too low or all of the landmarks have already been
    %observed create a new landmark
    id = length(landmark_mu) + 1;
else
    %Randomly select association
    likelihood_sum = sum(likelihood);
    likelihood_norm = cumsum(likelihood)/likelihood_sum;
    bin = [0, likelihood_norm];
    ptr = mod(rand, 1);
    id = discretize(ptr, bin, 'IncludedEdge', 'right');
end
end