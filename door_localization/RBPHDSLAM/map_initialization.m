function particle = map_initialization(particle, g, g_mask, g_var, num_landmarks)
%Initialize the Map PHD
%Initialize Variables
g_ind = find(g_mask);

%Initialize map
for j = 1:length(g_ind)
    particle.landmarks(j).mu = particle.history{end - 1} + g(g_ind(j));
    particle.landmarks(j).sigma = g_var;
    particle.landmarks(j).weight = num_landmarks/length(g_ind); %Due to the geometry of the situuation you only expect ever one new landmark
end
end