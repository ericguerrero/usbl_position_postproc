clc;clear;close all;format compact;

i_vo = 0;
i_usbl = 0;
duration = 0;
file = 'ekf_vo';
modem = 'modem_raw';


% GetData
[vo, time0] = getNavOdom(file, i_vo, duration,'map');
usbl = getPose(file, i_usbl, duration,modem, time0);

figure(4);hold on;grid on;
plot(usbl.position.x,usbl.position.y,'o');
plot(usbl.position.x,usbl.position.y);
plot(vo.position.x,vo.position.y);