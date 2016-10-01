clc;clear;close all;format compact;
% Analize the precision of the USBL system
% The data base consists in 5 sets of hovering data
% USBL measurements are compared with the odometry of the filter

%% Get precision (buoy)
buoy_ned = getPose('ekf_vo',0, 0,'buoy_ned', 0);
altitude_ned = getPose('ekf_vo',0, 0,'dvl_altitude', 0);
cov_buoy_ned = cov([buoy_ned.position.x,buoy_ned.position.y,buoy_ned.position.z]);
eig_buoy_ned = eig(cov_buoy_ned);

figure(11);hold on;title(['Buoy dispersion, {\lambda}_max = ', num2str(eig_buoy_ned(3),3)]);
plot(buoy_ned.position.y,buoy_ned.position.x,'o');
xlabel('N [m]');ylabel('E [m]');

plot(altitude_ned.time,altitude_ned.position.z,'o');

%% Get precision (modem_delayed -vo)
close all;
init = [100, 273, 415, 540, 692];
duration = [95, 82, 73, 81, 73];

file = 'ekf_vo';
modem = 'modem_delayed';
odom = 'map';
del_ekf = precision(init, duration,file,modem,odom);

%% Plot




