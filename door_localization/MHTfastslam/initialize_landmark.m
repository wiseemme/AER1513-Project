function particle = initialize_landmark(id, particle, robot, g, g_var)
%Set landmark Pose
particle.landmarks(id).mu = robot + g;

%Initialize the variance
particle.landmarks(id).sigma = g_var;

%Set the landmark to viewed for this iteration
particle.landmarks(id).observed = true;

%Set the landmark's log odds existence probability
particle.landmarks(id).lodds = 0;
end