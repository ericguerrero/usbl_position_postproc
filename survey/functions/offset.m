function traj = offset(gt, traj)
offset_x = gt.position.x(1) - traj.position.x(1);
offset_y = gt.position.y(1) - traj.position.y(1);

traj.position.x = traj.position.x + offset_x;
traj.position.y = traj.position.y + offset_y;
end