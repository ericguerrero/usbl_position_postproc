function [st] = precision(init, duration,file,modem,odom)

error = {[],[],[],[],[]};

for k=1:length(init)
    % GetData
    [vo, time0] = getNavOdom(file, init(k), duration(k), odom);
    usbl = getPose(file, init(k), duration(k),modem, time0);
    buoy = getPose('ekf_vo',init(k), duration(k),'buoy_ned', time0);

    for i=1:5
        %% VO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Center means for precision analisys
        offset_x = mean(usbl.position.x) - mean(vo.position.x);
        offset_y = mean(usbl.position.y) - mean(vo.position.y);
        vo.position.x = vo.position.x + offset_x;
        vo.position.y = vo.position.y + offset_y;


        %% Get error
        x_error = getTrajError([usbl.time, usbl.position.x],[vo.time, vo.position.x]);
        y_error = getTrajError([usbl.time, usbl.position.y],[vo.time, vo.position.y]);
        dist = sqrt(x_error.^2 + y_error.^2);
        lon =  sqrt(mean(usbl.position.x)^2 + mean(usbl.position.y)^2);

        %% Filter outliers
        outlier = find(dist>4);
        dist(outlier) = [];
        usbl.time(outlier) = [];
        x_error(outlier) = [];
        y_error(outlier) = [];
        usbl.position.x(outlier) = [];
        usbl.position.y(outlier) = [];
    end
    
%     usbl_disper_x = x_error;
%     usbl_disper_y = y_error;
%     
%     for i=1:5
%         %% Buoy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Center means for precision analisys
%         offset_x = mean(usbl_disper_x) - mean(buoy.position.x);
%         offset_y = mean(usbl_disper_y) - mean(buoy.position.y);
%         buoy.position.x = buoy.position.x + offset_x;
%         buoy.position.y = buoy.position.y + offset_y;
% 
% 
%         %% Get error
%         x_error = getTrajError([usbl.time, usbl_disper_x'],[buoy.time, buoy.position.x]);
%         y_error = getTrajError([usbl.time, usbl_disper_y'],[buoy.time, buoy.position.y]);
%         dist = sqrt(x_error.^2 + y_error.^2);
%         lon =  sqrt(mean(usbl.position.x)^2 + mean(usbl.position.y)^2);
% 
%         %% Filter outliers
%         outlier = find(dist>4);
%         dist(outlier) = [];
%         usbl.time(outlier) = [];
%         x_error(outlier) = [];
%         y_error(outlier) = [];
%         usbl.position.x(outlier) = [];
%         usbl.position.y(outlier) = [];
%     end


    %% Plot XY traj
    figure(3);
    subplot(211);hold on;grid on;
    plot(usbl.time - init(k),usbl.position.x,'o');
    plot(vo.time - init(k),vo.position.x);
    legend('USBL','EKF');
    ylabel('East [m]');
    

    subplot(212);hold on;grid on;
    plot(usbl.time - init(k),usbl.position.y,'o');
    plot(vo.time - init(k),vo.position.y);
    legend('USBL','EKF');
    xlabel('Time [s]');ylabel('North [m]');

    figure(4);hold on;grid on;axis equal;
    plot(usbl.position.x,usbl.position.y,'o');
    plot(vo.position.x,vo.position.y);
    legend('USBL','EKF');
    xlabel('North [m]');ylabel('East [m]');

    figure(5);
    subplot(2,5,k);
    hold on;grid on;axis equal; axis([-1 1 -1 1]);
    plot(x_error,y_error,'o');
    %plot(mean(x_error),mean(y_error),'*');
    title([num2str(lon,2),'m']);
    if k==1
        ylabel('North [m]')
    end
    if k==3
        xlabel('East [m]')
    end
    
    
    

    %%
    max_eig(k) = max(eig(cov([x_error',y_error'])));
    min_eig(k) = min(eig(cov([x_error',y_error'])));
    error{k} = dist;
    m(k) = mean(dist);
    s(k) = std(dist);
    long(k) = lon;
    slant(k) = sqrt(max_eig(k))/lon;
end

figure(5);
subplot(2,1,2);hold on;grid on;
% VO
% p = polyfit(long,max_eig_vo,1);
% x = linspace(min(long),max(long));
% y = polyval(p,x);
% plot(x,y);
% plot(long,max_eig_vo,'*');
% Buoy
p = polyfit(long,max_eig,1);
x = linspace(min(long),max(long));
y = polyval(p,x);
plot(x,y);
plot(long,max_eig,'*');


title('');xlabel('Distance [m]');ylabel('{\lambda}_{max} [m]');



st = struct('mean',{m}, 'std', {s}, 'error', {error}, 'long', {long}, 'max_eig', {max_eig}, 'min_eig', {slant}, 'slant', {min_eig});
