function particle = reweight(particle, g_mask, false_rate)
%Reweight the particles
%Find the number of mesurements
num_measurements = length(find(g_mask(2,:)));
num_pred_measurements = length(find(g_mask(1,:)));

%Calculate the new weight
particle.weight = false_rate^num_measurements * exp(num_measurements - num_pred_measurements - false_rate) * particle.weight;
end