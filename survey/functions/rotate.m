function traj = rotate(deg, traj)
theta = deg*pi/180;

R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
x = traj.position.x';
y = traj.position.y';
v = [x;y];

x_center = x(1);
y_center = y(1);

center = repmat([x_center; y_center], 1, length(x));

s = v - center;     % shift points in the plane so that the center of rotation is at the origin

so = R*s;           % apply the rotation about the origin

vo = so + center;   % shift again so the origin goes back to the desired center of rotation

traj.position.x = vo(1,:)';

traj.position.y = vo(2,:)';
end