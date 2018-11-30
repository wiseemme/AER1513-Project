function particle = phdf_prediction(particle, g, g_mask, g_var)
%Calculate the predicted Map PHD
%Initialize Variables
g_ind = find(g_mask);
num_landmarks = length(particle.landmarks);

%Add the previous measurements as potential birth positions
for j = 1:length(g_ind)
    particle.landmarks(num_landmarks + j).mu = particle.history{end - 1} + g(g_ind(j));
    particle.landmarks(num_landmarks + j).sigma = g_var;
    particle.landmarks(num_landmarks + j).weight = 1/length(g_ind);
end
end