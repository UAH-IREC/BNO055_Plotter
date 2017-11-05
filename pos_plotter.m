instrreset;
s = serial('COM41');
s.baudrate = 115200;
fopen(s);

tstep = 0.1;
position = [0, 0, 0];
positions = [position];
fig = figure();
while ishandle(fig)
    % Format is w, x, y, z, X, Y, Z
    % Where w, x, y, z are the components of the quaternion
    % And X, Y, Z are the accelerations along the x, y, and z axes
    line = sscanf(fgets(s), '%g,', [7, 1]).';
    %disp(line);
    if length(line) < 7 || all(line(1:4) == 0) 
        disp('Incomplete line');
        continue
    end
    
    pos = line(2:4);
    positions = [positions; pos];
    [rows, ~] = size(positions);
    scatter3(positions(:, 1), positions(:, 2), positions(:, 3));
    xlabel('X (cm)'); ylabel('Y (cm)'); zlabel('Z (cm)');
    axis vis3d
    drawnow;
    pause(0.001);
end

fclose(s);
delete(s);
clear s;