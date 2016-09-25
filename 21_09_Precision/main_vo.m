clc;clear;close all;format compact;
% Analize the precision of the USBL system
% The data base consists in 5 sets of hovering data
% USBL measurements are compared with the odometry of the filter

%% Raw VO
close all;
init = [100, 273, 408, 540, 692];
duration = [95, 82, 73, 81, 73];

error = {[],[],[],[],[]};
for i=1:length(init)
    [dist, lon(i)] = precision(init(i), duration(i),'orb_odometry','modem_raw');
    figure(5);hold on;
    plot(dist)
    error{i} = dist
    m(i) = mean(dist);
    s(i) = std(dist);
end
raw_vo = struct('mean',{m}, 'std', {s}, 'error', {error}, 'long', {lon} );

%% Del VO
close all;
init = [100, 273, 408, 540, 692];
duration = [95, 82, 73, 81, 73];

error = {[],[],[],[],[]};
for i=1:length(init)
    [dist, lon(i)] = precision(init(i), duration(i),'orb_odometry','modem_delayed');
    figure(5);hold on;
    plot(dist)
    error{i} = dist;
    m(i) = mean(dist);
    s(i) = std(dist);
end
del_vo = struct('mean',{m}, 'std', {s}, 'error', {error}, 'long', {lon} );

%% Raw UKF
close all;
init = [100, 273, 408, 540, 692];
duration = [95, 82, 73, 81, 73];

error = {[],[],[],[],[]};
for i=1:length(init)
    [dist, lon(i)] = precision(init(i), duration(i),'ukf_vo','modem_raw');
    figure(5);hold on;
    plot(dist)
    error{i} = dist
    m(i) = mean(dist);
    s(i) = std(dist);
end
raw_ukf = struct('mean',{m}, 'std', {s}, 'error', {error}, 'long', {lon} );

%% Del UKF
close all;
init = [100, 273, 408, 540, 692];
duration = [95, 82, 73, 81, 73];

error = {[],[],[],[],[]};
for i=1:length(init)
    [dist, lon(i)] = precision(init(i), duration(i),'ukf_vo','modem_delayed');
    figure(5);hold on;
    plot(dist)
    error{i} = dist;
    m(i) = mean(dist);
    s(i) = std(dist);
end
del_ukf = struct('mean',{m}, 'std', {s}, 'error', {error}, 'long', {lon} );

%%

figure(10);
subplot(211); hold on; grid on; title('Mean and Std.Deviation');
plot(raw_ekf.long,raw_ekf.mean,'b')
plot(del_ekf.long,del_ekf.mean,'r')
plot(raw_ukf.long,raw_ukf.mean,'b')
plot(del_ukf.long,del_ukf.mean,'r')
xlabel('Longitude [m]');ylabel('Mean [m]');

subplot(212); hold on; grid on;
plot(raw_ekf.long,raw_ekf.std,'b')
plot(del_ekf.long,del_ekf.std,'r')
plot(raw_ukf.long,raw_ukf.std,'b')
plot(del_ukf.long,del_ukf.std,'r')
xlabel('Longitude [m]');ylabel('Std [m]');


