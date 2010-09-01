%reset(RandStream.getDefaultStream);

mu = 10;
sigma = 3;

num_samples = 1;


samples = randn(num_samples,1) * sigma + mu;

figure(1)
sph =plot(samples,zeros(size(samples)),'co');
hold on
plot_x = linspace(mu-3*sigma,mu+3*sigma,100);
plot_y = 1/(sqrt(2*pi)*sigma) * exp(-(plot_x - mu).^2 ./ (2* (sigma^2)));
dh = plot(plot_x,plot_y,'r-');
hold off
legend([sph dh],'Samples',['N(' num2str(mu,2) ', ' num2str(sigma,2) ') Density']);
hold off
% figure(2)
% hist(samples,10);

likelihood = 1/(sqrt(2*pi)*sigma) * exp(-(samples - mu).^2 ./ (2* (sigma^2)));
-log(prod(likelihood))



params(1) = mu;
params(2) = sigma;
matlab_likelihood = normlike(params,samples)