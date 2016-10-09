clc;clear;close all;format compact;
% Analize the USBL system accuracy in simulation


name = {'EKF  USBL','EKF  ODOM','UKF  USBL','UKF  ODOM'};
bins_filter = linspace(0,1.5,100);
bins_usbl = linspace(0,5,100);
 
init = 10; duration = 1100;
dur=20:10:1100;
mu = zeros(4,length(dur));
sigma = zeros(4,length(dur));
window = 150;

for k=1:length(dur)
    duration = dur(k);
%     init = duration - window;
    
    % Get Sim data
    [gt, t0] = getGT('ekf_usbl',init,duration, 'SLAM.mat'); % Same GT, trajectories from the same simulation
    usbl = getPose('ekf_usbl',init,duration,'modem_delayed_acoustic', t0);

    % Get Estimated Trajectory
    ekf_usbl = getNavOdom('ekf_usbl',init,duration, 'map',t0 ); 
    ekf_odom = getNavOdom('ekf_usbl',init,duration, 'odom',t0 ); 
    ukf_usbl = getNavOdom('ukf_usbl',init,duration, 'map',t0 ); 
    ukf_odom = getNavOdom('ukf_usbl',init,duration, 'odom',t0 ); 
    traj = {ekf_usbl,ekf_odom,ukf_usbl,ukf_odom};

    % Get SLAM Offset
    if k==1
        offset_usbl_x = ekf_odom.position.x(1) - gt.position.x(1); % TODO: Improve the offset precision
        offset_usbl_y = ekf_odom.position.y(1) - gt.position.y(1);
    end
    gt.position.x = gt.position.x + offset_usbl_x;
    gt.position.y = gt.position.y + offset_usbl_y;
    

    for i = 1:size(traj,2)
        filter = traj{i};

        % Trajectory Error
        traj_error_x = getTrajError([filter.time, filter.position.x],[gt.time, gt.position.x]);
        traj_error_y = getTrajError([filter.time, filter.position.y],[gt.time, gt.position.y]);
        traj_dist = sqrt(traj_error_x.^2 + traj_error_y.^2);
        traj_m = mean(traj_dist);
        traj_s = std(traj_dist);
        mu(i,k)= traj_m;
        sigma(i,k)= traj_s;
        i
    end
    k
end   
%%
color = {'r','g','b','c'};
for k = 1:size(traj,2)
    figure(7);hold on;grid on;axis([min(dur), max(dur), 0,3.5]);
    plot(dur,mu(k,:),color{k});
    
    % CI
    ci_u = mu(k,:) + sigma(k,:)/4;
    ci_d = mu(k,:) - sigma(k,:)/4;
    fill_between_lines(dur,ci_u,ci_d,color{k},0.3 )
    legend('ekf usbl', '', 'ekf odom', '','ukf usbl', '', 'ukf odom', '');

end
