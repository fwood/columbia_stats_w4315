function [mse individual_errors] = plot_error_lines(x,y_act,y_est, color, lineStyle)

if nargin < 4
    color = [0 1 0];
end

if nargin < 5
    lineStyle = ':';
end


plot_x = [x;x];
plot_y = [y_act;y_est];

lh = line(plot_x,plot_y);

for i = 1:length(lh)
    set(lh(i),'LineStyle',lineStyle)
    set(lh(i),'Color',color)
end

individual_errors = y_act - y_est;

mse = sum(individual_errors.^2)/length(individual_errors);