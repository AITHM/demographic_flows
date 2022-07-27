function [t_daily, y_daily] = change_to_daily_specify_time_dimension(t, y,  time_dimension)
% input is a typical ODE output, with a time vector and y-array. time
% demension can be either 1, or length(size(y)) - ie the last dimension

% set up t_return vector
days=[floor(t(1)):floor(t(end))];
t_daily=days;
length_days = length(t_daily);
% set up yreturn array
y_size = size(y);
y_daily_size = y_size;
y_daily_size(time_dimension) = length_days;
y_daily = zeros(y_daily_size);

% set up a vector to capture the place of y values required
ftot=[];

for a = days
    f=find(t<=a);
    if length(f)>0, 
    ftot=[ftot, f(end)]; % find the highest t that is <= a
    end
end

dims_y = length(y_size);
% consider time dimension is at the end
if time_dimension == dims_y,
    if dims_y == 2,
        y_daily = y(:, ftot);
    elseif dims_y == 3
        y_daily = y(:, :, ftot);
    elseif dims_y == 4
        y_daily = y(:, :, :, ftot);
    elseif dims_y == 5
        y_daily = y(:, :, :, :,ftot);
    end
end
% consider time dimension is at the start
if time_dimension == 1,
    if dims_y == 2,
        y_daily = y(ftot, :);
    elseif dims_y == 3
        y_daily = y(ftot, :, :);
    elseif dims_y == 4
        y_daily = y(ftot, :, :, :);
    elseif dims_y == 5
        y_daily = y(ftot, :, :, :, :);
    end
end

