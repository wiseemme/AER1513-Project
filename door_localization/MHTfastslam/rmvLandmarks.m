function particle = rmvLandmarks(particle, rmv_thresh)
%Remove landmarks if their probability of existing is below the threshold
%Get the number of landmarks
numLandmarks = length(particle.landmarks);

for i = numLandmarks:-1:1
    if particle.landmarks(i).lodds <= rmv_thresh
        %Remove landmark
        particle.landmarks(i) = [];
    end
end
end