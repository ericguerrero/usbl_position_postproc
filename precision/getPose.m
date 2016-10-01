function s = getPose(name,init, duration,file, time0)
% Load
t0 = init;
tf = init + duration;
filtered = readPose([name,'/data/',file,'.txt']);

% Regularize time
time = filtered(:,3);
time1 = (time - time0)*1e-9;

if init ~= 0
    for i=1:length(time1)
        if (time1(i)>=t0)
            break
        end
    end
    filtered(1:i-1,:)=[];
    time1(1:i-1)=[];
    %time = (time1(:,1) - t0);
end


if duration ~= 0
    for i=1:length(time1)
        if (time1(i)>=tf)
            break
        end
    end
    filtered(i+1:end,:)=[];
    time1(i+1:end)=[];
end


% Structure
t_f = 'time';
t_v = {time1};

x_f = 'x';
x_v = {filtered(:,4)};
y_f = 'y';
y_v = {filtered(:,5)};
z_f = 'z';
z_v = {filtered(:,6)};

pos_f = 'position';
pos_v = struct(x_f,x_v,y_f,y_v,z_f,z_v);
cov_f = 'covariance';
cov_v = {filtered(:,11:end)};


s = struct(t_f,t_v,pos_f,pos_v,cov_f,cov_v);
end