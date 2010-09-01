%% sample a bunch of data from a normal distribution with known mean and
% variance

mean_ground_truth = 120;
variance_ground_truth = 5^2;
y = randn(1000,1)*sqrt(variance_ground_truth)+ mean_ground_truth;

figure(1)
[n,x] = hist(y,100);
hist(y,100)
ylabel('Counts')
xlabel('x')

pause;

%% compute the posterior distribution given some prior

tau_0_squared = 10;
mu_0 = 100;
    clf
    hold on
    ax = plotyy(x,zeros(size(x)),x,normpdf(x,mu_0,tau_0_squared));
         

    set(get(ax(2),'YLabel'),'String','P(\mu = x | y, \sigma^2)');
    hold off
        title(['Posterior Distribution of \mu (ground truth = ' num2str(mean_ground_truth) ') after 0 obs'])
    pause

for n = 2:10:1000
    tau_n_squared = 1/(1/tau_0_squared + n/variance_ground_truth);
    y_bar = mean(y(1:n));
    mu_n = ((1/tau_0_squared) * mu_0 + (n / variance_ground_truth) * y_bar) / (1/tau_n_squared + n/variance_ground_truth);
    
    s_squared = 1/(n-1) * sum((y(1:n) - y_bar).^2);
    
    
    hist(y(1:n),100)
    title(['Posterior Distribution of \mu (ground truth = ' num2str(mean_ground_truth) ') after ' num2str(n) ' obs'])
    ylabel('Counts')
    xlabel('x')
    hold on
    ax = plotyy(x,zeros(size(x)),x,normpdf(x,mu_n,tau_n_squared));
        set(get(ax(2),'YLabel'),'String','P(\mu = x | y, \sigma^2)');
        
        
        
    bx = plotyy(x,zeros(size(x)),x,tpdf((x-y_bar)/((1+1/n)^(1/2) * sqrt(s_squared)),n-1));
     set(get(bx(2),'Children'),'Color',[0 1 1])
    hold off

    pause
end