function [sA,sB] = getCloseloop(experiment)

closeloop = readSLAMedges([experiment,'/graph_edges.txt']);

A = closeloop(:,4:5);
B = closeloop(:,7:8);

% Structure A
x_f = 'x';
x_v = {closeloop(:,4)};
y_f = 'y';
y_v = {closeloop(:,5)};



sA = struct(pos_f,pos_v);

% Structure A
x_f = 'x';
x_v = {closeloop(:,7)};
y_f = 'y';
y_v = {closeloop(:,8)};



sB = struct(pos_f,pos_v);
end