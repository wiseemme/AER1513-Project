function plot_berr(landmarks, x_true, v, t, g, g_mask)
%Plot the base positional error
%Initialize variables
T = t(2) - t(1);
time = length(t);
o_state = zeros(time, 1);
o_state(1, 1) = x_true(1, 1);

%Calculate the odometry plot 
for k=2:time
    o_state(k, 1) = o_state(k - 1, 1) + T * v(k, 1);
end

%Calculate the measurement plot
m_state = sum((repmat(landmarks, time, 1) - g) .* g_mask, 2) ./ sum(g_mask, 2);

%Plot the error
o_error = o_state - x_true;
m_error = m_state - x_true;
figure
hold on
plot(t, o_error, 'b')
plot(t, m_error, 'r')
title('Localization Error')
xlabel('Time [s]')
ylabel('Error [m]')
legend('Odometry Only', 'Measurement Only')
hold off

%Plot distribution of landmarks seen
num_l = sum(g_mask, 2);
figure
histogram(num_l, [0,1,2,3,4])
title('Number of Landmarks Observed')
xlabel('Number of Landmarks Observed')
ylabel('Frequency')

end