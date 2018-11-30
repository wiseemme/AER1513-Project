function particle = phdf_corrector(particle, g, g_mask, g_var, false_rate, Pd)
%Perform the PHD corrector
%Initialize variables
g_ind = find(g_mask);
num_landmarks = length(particle.landmarks); %Get the total number of landmarks


for i = 1: length(particle.landmarks)
    %Update the predictor weights for non-detection
    particle.landmarks(i).weight = particle.landmarks(i).weight * (1 - Pd);
    
    %Calculate the expected measurement
    particle.landmarks(i).expg = particle.landmarks(i).mu - particle.pose;
    
    %Compute the measurement covariance
    particle.landmarks(i).Q = particle.landmarks(i).sigma + g_var;
    
    %Calculate the Kalman Gain
    particle.landmarks(i).K = particle.landmarks(i).sigma/particle.landmarks(i).Q;  
end

for i = 1: length(g_ind)
    for j = 1: num_landmarks
        index = num_landmarks + num_landmarks*(i-1) + j;
        %Add the measurements to the landmark position PHD
        particle.landmarks(index).mu = particle.landmarks(j).mu + particle.landmarks(j).K * (g(g_ind(i)) - particle.landmarks(j).expg);
        particle.landmarks(index).sigma = (1 - particle.landmarks(j).K) * particle.landmarks(j).sigma;
        particle.landmarks(index).weight = particle.landmarks(j).weight * Pd * normpdf(g(g_ind(i)), particle.landmarks(j).expg, sqrt(particle.landmarks(j).Q));
    end
    %Normalize the weights
    weights = [particle.landmarks.weight];
    for j = 1: num_landmarks
        index = num_landmarks + num_landmarks * (i - 1) + j;
        particle.landmarks(index).weight = particle.landmarks(index).weight/(false_rate + sum(weights));
    end
end
end