clc;clear;close all;format compact;
%% Parameters

% experiment = 'field';
experiment = 'simulation';
filter = 'ekf_usbl';
duration = 1080;
if strcmp(experiment,'field')
    init = 4; 
    bins = linspace(0,6,100);
    deg = -5;
else
    init = 80;
    bins = linspace(0,4,100);
    deg = 0;
end
    

colors = [0.3010,0.7450,0.9330;  0.6350,0.0780,0.1840]; % blue,red
linewidth = 1.5;
name = {'Filter Odometry','Filter USBL','Measurement USBL','Measurement USBL Delayed'};
color = {'r','g','b','c','y','m'};
plotXY = true;

%% Data
% Ground truth
[gt, t0] = getGT(init, duration,experiment);

% Filter
filter_usbl = getNavOdom(init,duration,experiment,filter,'map', t0);
filter_odom = getNavOdom(init,duration,experiment,filter,'odom', t0);

% Measurements
usbl_raw = getPose(init,duration,experiment,filter,'modem_raw', t0);
usbl_del = getPose(init,duration,experiment,filter,'modem_delayed_acoustic', t0);
% closeloop = readSLAMedges([experiment,'/graph_edges.txt']);

% Offset
filter_usbl = offset(gt,filter_usbl);
filter_odom = offset(gt,filter_odom);
usbl_raw = offset(gt,usbl_raw);
usbl_del = offset(gt,usbl_del);
traj = {filter_odom,filter_usbl,usbl_raw,usbl_del};

% Rotate 
gt = rotate(deg, gt);

%% Trajectory error
close all;
for k = 1:4
    T = traj{k};
    error = trajDistance(T,gt);
    if k<=3
        % Plot Error
        figure(3);hold on;grid on;
        plot(T.time,error.distance,color{k},'LineWidth',linewidth);
        p = polyfit(T.time,error.distance,1);
        fitted = polyval(p,T.time);
        plot(T.time,fitted,color{k});
    end

    %  Plot Error Histogram
    figure(4);
    subplot(4,1,k);hold on;
    histogram(error.distance,bins,'FaceColor',color{k},'FaceAlpha',0.3)
    x = 0:0.1:max(bins);
    f = exp(-(x-error.mean).^2./(2*error.std^2))./(error.std*sqrt(2*pi));
    plot(x,f*length(error.distance)/22,color{k},'LineWidth',1.5)
    title([name{k}, ': {\mu}= ', num2str(error.mean,2), '  {\sigma}= ', num2str(error.std,2), '  n= ', num2str(length(error.distance),5)])
end




% Plot trajectories

% Plot XY gt
figure(1);hold on;grid on;axis equal;
plot(gt.position.y,gt.position.x,'k','LineWidth',linewidth);
for k = 1:2
    T = traj{k};
    plot(T.position.y,T.position.x,color{k},'LineWidth',linewidth);
end

% Plot Time gt
figure(2);
subplot(211);hold on;grid on;
plot(gt.time,gt.position.x,'k','LineWidth',linewidth);
subplot(212);hold on;grid on;
plot(gt.time,gt.position.y,'k','LineWidth',linewidth);
for k = 1:3
    T = traj{k};
    subplot(211);hold on;grid on;
    plot(T.time,T.position.x,color{k},'LineWidth',linewidth);
    subplot(212);hold on;grid on;
    plot(T.time,T.position.y,color{k},'LineWidth',linewidth);  
end



% Plot details
% Plot XY 
figure(1);hold on;grid on;axis equal;
xlabel('East [m]');ylabel('North [m]');
legend('Ground Truth','Filter Odometry','Filter USBL','Measurement USBL');

% Plot Time 
figure(2);
subplot(211);hold on;grid on;
legend('Ground Truth','Filter Odometry','Filter USBL','Measurement USBL');
ylabel('North [m]');
subplot(212);hold on;grid on;
xlabel('Time [s]');ylabel('East [m]');        

% Plot Error
figure(3);hold on;grid on;
xlabel('Time [s]');ylabel('Euclidean Distance Error [m]'); 
legend('Filter Odometry','','Filter USBL','','Measurement USBL','');

%% Plot accumulated Mean error and dispersion
if false
    dur=20:10:1100;
    mu = zeros(3,length(dur));
    sigma = zeros(3,length(dur));
    for i=1:length(dur)
        duration = dur(i);
        % Ground truth
        [gt, t0] = getGT(init, duration,experiment);

        % Filter
        filter_usbl = getNavOdom(init,duration,experiment,filter,'map', t0);
        filter_odom = getNavOdom(init,duration,experiment,filter,'odom', t0);

        % Measurements
        usbl_raw = getPose(init,duration,experiment,filter,'modem_raw', t0);
        usbl_del = getPose(init,duration,experiment,filter,'modem_delayed_acoustic', t0);

        % Offset
        filter_usbl = offset(gt,filter_usbl);
        filter_odom = offset(gt,filter_odom);
        usbl_raw = offset(gt,usbl_raw);
        usbl_del = offset(gt,usbl_del);
        traj = {filter_odom,filter_usbl,usbl_raw,usbl_del};

        for k = 1:3
            T = traj{k};
            error = trajDistance(T,gt);
            mu(k,i)= error.mean;
            sigma(k,i)= error.std;
        end
        i
    end   
end

load([experiment,'/dur.mat']);
for k = 1:3
    figure(7);hold on;grid on;axis([min(dur), max(dur), 0,3.5]);
    plot(dur,mu(k,:),color{k});

    % CI
    ci_u = mu(k,:) + sigma(k,:);
    ci_d = mu(k,:) - sigma(k,:);
    fill_between_lines(dur,ci_u,ci_d,color{k},0.3 )
    legend('Filter Odometry','','Filter USBL','','Measurement USBL','');
    xlabel('Time [s]');ylabel('Euclidean Distance Error [m]'); 
end

%%
% if strcmp(experiment,'field')
%     edges = readSLAMedges([experiment,'/graph_edges.txt']);
%     n_cl = size(edges,1);
%     mean_inaliers = mean(edges(:,3));
%     for i=1:n_cl
%         pair = edges(i,:);
%         figure(1);hold on;grid on;axis equal;
%         line = [pair(4:5);pair(7:8)];
%         plot(line(:,1),line(:,2),'k','LineWidth',3);
%     end
% end
