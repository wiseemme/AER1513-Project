function particle = merge_prune(particle, merge_thresh)
%Prune and Merge Gaussian components to limit computational complexity
%Initialize Variables for pruning
prune_thresh = 0.5 * max([particle.landmarks.weight]);

%Prune any particles with a negligable weight
prune_candidates = find([particle.landmarks.weight]<prune_thresh);
if ~isempty(prune_candidates)
    particle.landmarks(prune_candidates) = [];
end

%Initialize variables for merging
num_landmarks = length(particle.landmarks);
mal_dist = zeros([sum([1:num_landmarks - 1]), 1]);
pairs = zeros([sum([1:num_landmarks - 1]), 2]);

%Calculate the mal distance between gaussians
for i = 1: num_landmarks - 1
    for j = i + 1: num_landmarks
        index = sum(num_landmarks - [1:i]) - (num_landmarks - i) + (j - i);
        pairs(index, :) = [i, j];
        mal_dist(index) = (particle.landmarks(i).mu - particle.landmarks(j).mu)^2 / particle.landmarks(i).sigma;
    end
end

%Identify the merge candidates
merge_id = find(mal_dist < merge_thresh);

%Prepare merge id order
if ~isempty(merge_id)
    merge_dict = prep_merge(merge_id, pairs);


%Get the total number of values in the dictionary
merge_dict_num_val = 0;
for i = 1:length(merge_dict)
    merge_dict_num_val = merge_dict_num_val + length(merge_dict(i).pair);
end

%Get the number of landmarks that the should be merged to
num_merged_landmarks = length(merge_dict);

%Merge the merge candidates
for i = merge_dict_num_val: -1: num_merged_landmarks + 1
    %Find which group has the highest merge number
    temp_highest = 0;
    temp_group = 0;
    for j = 1: length(merge_dict)
        M = max(merge_dict(j).pair);
        if M > temp_highest
            temp_highest = M;
            temp_group = j;
        end
    end
    
    %Pop the largest ID out of the group
    id = merge_dict(temp_group).pair(end);
    merge_dict(temp_group).pair(end) = []; 
    
    %Merge the Landmark weights, mus, and sigmas
    new_weight = particle.landmarks(merge_dict(temp_group).pair(1)).weight + particle.landmarks(id).weight;
    new_mu = (particle.landmarks(merge_dict(temp_group).pair(1)).weight * particle.landmarks(merge_dict(temp_group).pair(1)).mu + particle.landmarks(id).weight * particle.landmarks(id).mu)/new_weight;
    new_sigma = (particle.landmarks(merge_dict(temp_group).pair(1)).weight * particle.landmarks(merge_dict(temp_group).pair(1)).sigma + particle.landmarks(id).weight * particle.landmarks(id).sigma)/new_weight;
    new_sigma = new_sigma + (particle.landmarks(merge_dict(temp_group).pair(1)).mu - particle.landmarks(id).mu)^2;

    %Load the merged landmark into the first id and delete the second
    particle.landmarks(merge_dict(temp_group).pair(1)).weight = new_weight;
    particle.landmarks(merge_dict(temp_group).pair(1)).mu = new_mu;
    particle.landmarks(merge_dict(temp_group).pair(1)).sigma = new_sigma;
    particle.landmarks(id) = [];
    
    %Delete the group from the dictionary if it has been fully merged
    if length(merge_dict(temp_group).pair) == 1
        merge_dict(temp_group) = [];
    end
end
end

%Normalize landmark weights to represent the number of landmarks
norm_weight = length(particle.landmarks)*[particle.landmarks.weight]/sum([particle.landmarks.weight]);
for i = 1: length(norm_weight)
    particle.landmarks(i).weight = norm_weight(i);
end
end