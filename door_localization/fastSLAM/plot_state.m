function plot_state(particles, landmarks, x_true, f)
    %plot the most likely particle
    numParticles = length(particles);
    m = length(landmarks);
    %Initialize the best weight
    bestw = 0;
    bestid = 0;
    
    %Find the most likely particle
    for i = 1:numParticles
        if particles(i).weight > bestw
            bestw = particles(i).weight;
            bestid = i;
        end
    end
    figure(f)
    plot(landmarks, 2 * ones(length(landmarks)), 'ko')
    hold on
    plot(x_true, 1, 'ro')
    plot(particles(bestid).pose, 1, 'bo')
    for i = 1: m
        if particles(bestid).landmarks(i).observed == true
            error = 3 * sqrt(particles(bestid).landmarks(i).sigma); 
            errorbar(particles(bestid).landmarks(i).mu, 1.5, error, 'horizontal', 'bo')
        end
    end
    axis([-6 6 0 3])
    hold off
end