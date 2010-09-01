function plot_gpa_fit(input,output,b_1,b_0)

% make up some input points
x_plot = linspace(min(input),max(input),100);
y_plot = b_1*x_plot + b_0;  % vector times scalar plus scalar -- something fancy is going on here

plot(input,output,'ko')
hold on
rh = plot(x_plot,y_plot,'r-');
hold off
legend(rh,'Regression fit');
xlabel('ACT score');
ylabel('Freshman GPA');