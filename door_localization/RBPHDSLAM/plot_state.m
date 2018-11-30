function plot_state(particles, landmarks, x_true, f, merge_thresh)
%plot the most likely particle
numParticles = length(particles);

%Initialize the best weight
EAPParticle = particles(1);

%Combine the Particles into a EAP estimate
EAPParticle.pose = [particles.pose] * [particles.weight]' / sum([particles.weight]);
for i = 1:numParticles
    temp_weights = particles(i).weight * [particles(i).landmarks.weight];
    for j = 1: length(temp_weights)
        particle(i).landmarks(j).weight = temp_weights(j);
    end
    EAPParticle = merge_prune(EAPParticle, merge_thresh);
end


%Grab the number of landmarks for the particle
m = length(EAPParticle.landmarks);

%Plot
figure(f)
plot(landmarks, 2 * ones(length(landmarks)), 'ko')
hold on
plot(x_true, 1, 'ro')
plot(EAPParticle.pose, 1, 'bo')
for i = 1: m
    error = 3 * sqrt(EAPParticle.landmarks(i).sigma);
    errorbar(EAPParticle.landmarks(i).mu, 1.5, error, 'horizontal', 'bo')
end
axis([-6 6 0 3])
hold off
end