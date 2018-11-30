function plot_PHD(particle)
%Plot the PHD of the Map for a given particle
%Initialize Variable
x = -5:0.01:5;
num_landmarks = length(particle.landmarks);
y = zeros(size(x));

%Calculate the PHD distribution
for i = 1: num_landmarks
    mu = particle.landmarks(i).mu;
    sigma = particle.landmarks(i).sigma;
    weight = particle.landmarks(i).weight;
    y = y + weight * normpdf(x, mu, sqrt(sigma));
end
figure
plot(x, y)
xlabel('Position [m]')
ylabel('Density [#landmarks/m]')
end