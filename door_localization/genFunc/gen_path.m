function [x, v, t] = gen_path(max_dist, v_noise)
t = transpose(0:0.1:100);
f = 2*pi/(5*max_dist); %5 is to pull the velocity into a nice range
x = max_dist/2 * (sin(f*t) + cos(3*f*t));
v = (max_dist/2 * f) * (cos(f*t) - 3*sin(3*f*t))+ normrnd(0, v_noise, [length(t), 1]);
end