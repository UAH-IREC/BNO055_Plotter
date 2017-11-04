data = csvread('ontable.csv');
pos = data(:, 2:4) ./ 100; % Convert cm to m
time = data(:, 1) ./ 1000; % Convert ms to seconds
x = pos(:, 1); y = pos(:, 2); z = pos(:, 3);
scatter3(x, y, z);
figure()
plot(time, x);