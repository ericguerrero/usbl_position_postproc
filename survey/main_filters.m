clc;clear;close all;format compact;
%% Parameters

experiment = 'field';

filter = 'ekf_usbl';
duration = 1080; init = 4; 
bins = linspace(0,6,100);
deg = -5;

colors = [0.3010,0.7450,0.9330;  0.6350,0.0780,0.1840]; % blue,red
linewidth = 1.5;
name = {'EKF','UKF'};
color = [[0    1    0];[0.4940    0.1840    0.5560]*1.1];


%% Data
% Ground truth
[gt, t0] = getGT(init, duration,experiment);
gt = rotate(deg, gt);

% Filter
ekf = getNavOdom(init,duration,experiment,'ekf_usbl','map', t0);
ukf = getNavOdom(init,duration,experiment,'ukf_usbl','map', t0);

% Offset
ekf = offset(gt,ekf);
ukf = offset(gt,ukf);
traj = {ekf,ukf};



%% Trajectory error
close all;
for k = 1:2
    T = traj{k};
    error = trajDistance(T,gt);
    if k<=3
        % Plot Error
        figure(3);hold on;grid on;
        plot(T.time,error.distance,'Color',color(k,:),'LineWidth',linewidth);
        p = polyfit(T.time,error.distance,1);
        fitted = polyval(p,T.time);
        plot(T.time,fitted,'Color',color(k,:));
    end

    %  Plot Error Histogram
    figure(4);
    subplot(2,1,k);hold on;
    histogram(error.distance,bins,'FaceColor',color(k,:),'FaceAlpha',0.3)
    x = 0:0.1:max(bins);
    f = exp(-(x-error.mean).^2./(2*error.std^2))./(error.std*sqrt(2*pi));
    plot(x,f*length(error.distance)/22,'Color',color(k,:),'LineWidth',1.5)
    title([name{k}, ': {\mu}= ', num2str(error.mean,2), '  {\sigma}= ', num2str(error.std,2), '  n= ', num2str(length(error.distance),5)])
end




% Plot trajectories

% Plot XY gt
figure(1);hold on;grid on;axis equal;
plot(gt.position.y,gt.position.x,'k','LineWidth',linewidth);
for k = 1:2
    T = traj{k};
    plot(T.position.y,T.position.x,'Color',color(k,:),'LineWidth',linewidth);
end

% Plot Time gt
figure(2);
subplot(211);hold on;grid on;
plot(gt.time,gt.position.x,'k','LineWidth',linewidth);
subplot(212);hold on;grid on;
plot(gt.time,gt.position.y,'k','LineWidth',linewidth);
for k = 1:2
    T = traj{k};
    subplot(211);hold on;grid on;
    plot(T.time,T.position.x,'Color',color(k,:),'LineWidth',linewidth);
    subplot(212);hold on;grid on;
    plot(T.time,T.position.y,'Color',color(k,:),'LineWidth',linewidth);  
end



% Plot details
% Plot XY 
figure(1);hold on;grid on;axis equal;
xlabel('East [m]');ylabel('North [m]');
legend('Ground Truth','EKF','UKF');

% Plot Time 
figure(2);
subplot(211);hold on;grid on;
legend('Ground Truth','EKF','UKF');
ylabel('North [m]');
subplot(212);hold on;grid on;
xlabel('Time [s]');ylabel('East [m]');        

% Plot Error
figure(3);hold on;grid on;
xlabel('Time [s]');ylabel('Euclidean Distance Error [m]'); 
legend('EKF','','UKF','');

%% Plot accumulated Mean error and dispersion
if false
    dur=20:10:1100;
    mu = zeros(3,length(dur));
    sigma = zeros(3,length(dur));
    for i=1:length(dur)
        duration = dur(i);
        % Ground truth
        [gt, t0] = getGT(init, duration,experiment);
        gt = rotate(deg, gt);

        % Filter
        ekf = getNavOdom(init,duration,experiment,'ekf_usbl','map', t0);
        ukf = getNavOdom(init,duration,experiment,'ukf_usbl','map', t0);

        % Offset
        ekf = offset(gt,ekf);
        ukf = offset(gt,ukf);
        traj = {ekf,ukf};


        for k = 1:2
            T = traj{k};
            error = trajDistance(T,gt);
            mu(k,i)= error.mean;
            sigma(k,i)= error.std;
        end
        i
    end   
end

load([experiment,'/dur_filters.mat']);
for k = 1:2
    figure(7);hold on;grid on;axis([min(dur), max(dur), 0,2]);
    plot(dur,mu(k,:),'Color',color(k,:));

    % CI
    ci_u = mu(k,:) + sigma(k,:);
    ci_d = mu(k,:) - sigma(k,:);
    fill_between_lines(dur,ci_u,ci_d,color(k,:),0.3 )
    legend('EKF','','UKF','');
    xlabel('Time [s]');ylabel('Euclidean Distance Error [m]'); 
end

