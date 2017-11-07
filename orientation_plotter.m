instrreset;
s = serial('COM41');
s.baudrate = 115200;
fopen(s);

tstep = 0.1;
position = [0, 0, 0];
orientations = [position];
fig = figure();
lastq = [0 0 0 0];
last_time = 0;
while ishandle(fig)
    % Format is w, x, y, z, X, Y, Z
    % Where w, x, y, z are the components of the quaternion
    % And X, Y, Z are the accelerations along the x, y, and z axes

    line = sscanf(fgets(s), '%g,', [11, 1]).';

    %disp(line);
    if length(line) < 8 || all(line(5:8) == 0) || line(1) < last_time 
        %disp('Incomplete line');
        continue
    end
    last_time = line(1);
    
    quat = line(5:8);
    quat = quatinv(quat);
    %disp(quat)
    if norm(quat - lastq) > 0.000025 && any(lastq ~= [0 0 0 0])
        disp(line)
    end
    lastq = quat;
    varied = 0:0.05:1;
    empty = zeros([1, length(varied)]);
    xp = quatrotate(quat, [varied; empty; empty]');
    yp = quatrotate(quat, [empty; varied; empty]');
    zp = quatrotate(quat, [empty; empty; varied]');
    allx = [xp(:, 1); yp(:, 1); zp(:, 1)];
    ally = [xp(:, 2); yp(:, 2); zp(:, 2)];
    allz = [xp(:, 3); yp(:, 3); zp(:, 3)];
    sizes = 20 * ones([1, length(xp) * 3])';
    colors = zeros([3, length(xp) * 3])';
    colors(1:length(xp), 1) = 1;
    colors(length(xp)+1:2*length(xp), 2) = 1;
    colors(2*length(xp)+1:3*length(xp), 3) = 1;
    scatter3(allx, ally, allz, sizes, colors);
%     hold on
%     scatter3(yp(:, 1), yp(:, 2), yp(:, 3), 'go');
%     scatter3(zp(:, 1), zp(:, 2), zp(:, 3), 'bo');
%     hold off
    %scatter3(orientations(:, 1), orientations(:, 2), orientations(:, 3));
    xlabel('X (cm)'); ylabel('Y (cm)'); zlabel('Z (cm)');
    axis([-1 1 -1 1 -1 1]);
    axis vis3d
    drawnow;
    flushinput(s);
    pause(0.002);
end

fclose(s);
delete(s);
clear s;