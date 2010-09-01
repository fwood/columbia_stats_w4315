%reset(RandStream.getDefaultStream);

num_samples = 100;
sample = zeros(num_samples,1);

n = 200;

for l=1:num_samples
    
    mu = 5;
    sigma = 2;
    
    x = linspace(0,10,100);
    Y = randn(n,1)*sigma + mu;
    y = normpdf(x,mu,sigma);
    
    theta = mu;
    hat_theta = mean(Y);
    sample(l) = hat_theta;
    
    pdfh = plot(x,y);
    set(pdfh,'LineWidth',2)
    color = [0 1 0];
    lineStyle = '-';
    lh = line([Y Y]', [zeros(size(Y)) .25*max(y)*ones(size(Y))]');
    for i = 1:length(lh)
        set(lh(i),'LineStyle',lineStyle,'Color',color,'LineWidth',2)
    end
    est_line = line([hat_theta; hat_theta],[0 .5*max(y)]);
    set(est_line,'LineStyle','--','Color',[0 0 0],'LineWidth',2)
    act_line = line([theta; theta],[0 .5*max(y)]);
    set(act_line,'LineStyle','-','Color',[1 0 0],'LineWidth',2)
    hold off
    legend([pdfh lh(1) act_line est_line],['\mu = ' num2str(mu,3) ', \sigma = ' num2str(sigma,3)], 'samples', '\theta', 'est. \theta')
    drawnow
end

figure(2)
x = linspace(mu-2, mu+2,100);
y = normpdf(x, mu, sqrt((sigma^2)/n));

[N,X] = hist(sample,x);
N = N/max(N);
N = N*max(y);

bar(X,N);
hold on
ph = plot(x,y);
set(ph,'LineStyle','-','Color',[1 0 0],'LineWidth',2)
hold off