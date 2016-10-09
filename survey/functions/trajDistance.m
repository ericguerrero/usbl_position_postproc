function s = trajDistance(A,B)


error_x = trajDiff([A.time, A.position.x],[B.time, B.position.x]);
error_y = trajDiff([A.time, A.position.y],[B.time, B.position.y]);
dist = sqrt(error_x.^2 + error_y.^2);
m = mean(dist);
s = std(dist);

% Structure
dist_f = 'distance';
dist_v = {dist'};

m_f = 'mean';
m_v = {m};

s_f = 'std';
s_v = {s};

s = struct(dist_f,dist_v,m_f,m_v,s_f,s_v);
end