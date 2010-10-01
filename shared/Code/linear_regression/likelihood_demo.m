reset(RandStream.getDefaultStream);

% the likelihood function is a function of both the data and of the
% parameters. different data (i.e. changing the data or resampling from a 
% population) will change the likelihood.  Changing a model's parameters to
% try to maximimize the likelihood of some data under a particular
% parametric model will also change the likelihood.  

% true model parameters
mu = 10;
sigma = 3;
num_samples = 10;

%% likelihood of data under true model

samples = randn(num_samples,1) * sigma + mu;

figure(1)
sph =plot(samples,zeros(size(samples)),'ko');
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
% better to look at log likelihood
likelihood_of_data_under_true_model = exp(-normlike(params,samples))
log_likliehood_of_data_under_true_model = -normlike(params,samples)

%% likelihood of model given data
mu_hat = 12;
sigma_hat = 2;

figure(1)
hold on
plot_x = linspace(mu_hat-3*sigma_hat,mu_hat+3*sigma_hat,100);
plot_y = 1/(sqrt(2*pi)*sigma_hat) * exp(-(plot_x - mu_hat).^2 ./ (2* (sigma_hat^2)));
qh = plot(plot_x,plot_y,'g-');
hold off
legend([sph dh qh],'Samples',['N(' num2str(mu,2) ', ' num2str(sigma,2) ') Density'], ['N(' num2str(mu_hat,2) ', ' num2str(sigma_hat,2) ') Density']);
hold off

params(1) = mu_hat;
params(2) = sigma_hat;
likelihood_of_data_under_fitted_model = exp(-normlike(params,samples))
log_likelihood_of_data_under_fitted_model = -normlike(params,samples)