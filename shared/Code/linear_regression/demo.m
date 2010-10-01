
%% generate data
reset(RandStream.getDefaultStream);

num_x = 25;
x = linspace(1,10,num_x) + rand(1,num_x);


b_0 = 9;
b_1 = 2;
noise_var = 4;

y = b_1*x + b_0 + randn(1,num_x)*sqrt(noise_var);

plot(x,y,'ko')
xlabel('Predictor/Input')
ylabel('Response/Output')
ylim([10 40])

true_mse = y-b_1*x - b_0;
true_mse = sum(true_mse.^2)/num_x;

%% try some values for b_0 and b_1

b_0_hat = mean(y);
b_1_hat = 0;

plot(x,y,'ko')
xlabel('Predictor/Input')
ylabel('Response/Output')
ylim([10 40])
hold on
x_plot = linspace(1,10+1,2);
y_plot = b_1_hat*x_plot + b_0_hat;
eh = plot(x_plot,y_plot,'k-');
y_true = b_1*x_plot + b_0;
th = plot(x_plot,y_true,'r-');
mse = plot_error_lines(x,y,polyval([b_1_hat b_0_hat],x),[0 0 1]);
hold off
legend([eh th],['Guess, y = ' num2str(b_1_hat,3) 'x + ' num2str(b_0_hat,3) ', mse: ' num2str(mse,3)],['True, y = ' num2str(b_1,3) 'x + ' num2str(b_0,3) ', mse: ' num2str(true_mse,3)])

%%

b_0_hat = 13;
b_1_hat = 1.5;

plot(x,y,'ko')
xlabel('Predictor/Input')
ylabel('Response/Output')
ylim([10 40])
hold on
x_plot = linspace(1,10+1,2);
y_plot = b_1_hat*x_plot + b_0_hat;
eh = plot(x_plot,y_plot,'k-');
y_true = b_1*x_plot + b_0;
th = plot(x_plot,y_true,'r-');
mse = plot_error_lines(x,y,polyval([b_1_hat b_0_hat],x),[0 0 1]);
hold off
legend([eh th],['Guess, y = ' num2str(b_1_hat,3) 'x + ' num2str(b_0_hat,3) ', mse: ' num2str(mse,3)],['True, y = ' num2str(b_1,3) 'x + ' num2str(b_0,3) ', mse: ' num2str(true_mse,3)])



%% Estimate regression parameters
plot(x,y,'ko')
xlabel('Predictor/Input')
ylabel('Response/Output')
ylim([10 40])

x_augmented = [x; ones(size(x))];
results = y*pinv(x_augmented);

b_1_hat = results(1);
b_0_hat = results(2);

hold on
x_plot = linspace(1,10+1,2);
y_plot = b_1_hat*x_plot + b_0_hat;
eh = plot(x_plot,y_plot,'k-');
y_true = b_1*x_plot + b_0;
th = plot(x_plot,y_true,'r-');
[mse ind_errors] = plot_error_lines(x,y,polyval([b_1_hat b_0_hat],x),[0 0 1]);
hold off
legend([eh th],['Estimate, y = ' num2str(b_1_hat,3) 'x + ' num2str(b_0_hat,3) ', mse: ' num2str(mse,3)],['True, y = ' num2str(b_1,3) 'x + ' num2str(b_0,3) ', mse: ' num2str(true_mse,3)])


%% distribution of b_1 and b_0 due to sampling errors (with b fixed)
num_samples = 1000;
b_1_samples = zeros(num_samples,1);
b_0_samples = zeros(num_samples,1);

for i = 1:num_samples
    y = b_1*x + b_0 + randn(1,num_x)*sqrt(noise_var);
    
    x_augmented = [x; ones(size(x))];
    % solve regression problem in advanced way
    results = y*pinv(x_augmented);
    
    b_1_samples(i) = results(1);
    b_0_samples(i)  = results(2);
end

% plot b_1 empirical and theoretical distribution
b_1_plot_range = linspace(-10, 10,100);
b_1_plot_y = tpdf(b_1_plot_range,num_x-2);
ph = plot(b_1_plot_range,b_1_plot_y,'r');
set(ph,'LineStyle','-','Color',[1 0 0],'LineWidth',2)

normalized_statistic = (b_1_samples-b_1)/std(b_1_samples);
[N X] = hist(normalized_statistic,50);
N=N/max(N);
N=N*max(b_1_plot_y);
hold on
bar(X,N)
hold off
xlabel('( \beta est. - \beta) / \sigma_{\beta} est.')

% compute the 1-alpha confidence interval given the _single_ last sample of X and Y

alpha = .05;

right_interval = tinv(1-alpha/2,num_x-2);
left_interval = tinv(alpha/2,num_x-2);

% plot the interval boundaries
cils = line([left_interval right_interval; left_interval right_interval], [0 max(b_1_plot_y); 0 max(b_1_plot_y)]');
set(cils,'Color',[0 1 0],'LineWidth',2)
%hist(b_0_samples,50)

% compute the 1-alpha confidence interval given the _single_ last sample of
% X and Y

% estimate the sampling distribution of b_1 from the last X,Y sample
hat_v_b_1 = sqrt(sum((y-b_1*x - b_0).^2 / (num_x-2))/sum((x-mean(x)).^2))

% compute the upper and lower 1-alpha confidence interval for \beta_1
upper_limit_confidence = b_1_samples(i) + tinv(1-alpha/2, num_x -2)* hat_v_b_1
lower_limit_confidence = b_1_samples(i) - tinv(1-alpha/2, num_x -2)* hat_v_b_1

% do two-sided hypothesis test, H_0 = slope zero, H_a = some other slope

t_star = b_1_samples(end)/hat_v_b_1;

if t_star < tinv(1-alpha/2,num_x-2)
    disp('Null hypothesis holds - \beta_1 = 0');
else
    disp('Null hypothesis rejected - \beta_1 \neq 0');
end

% report p value

two_sided_p_value = 2*(1-tcdf(t_star,num_x-2));

disp(['Two sided p-value : ' num2str(two_sided_p_value)]) 

%% Polyfit

polynomial_order = 2;

coeffs = polyfit(x,y,polynomial_order);
poly_x = linspace(1,10+1,100);
poly_y = polyval(coeffs,poly_x);

plot(x,y,'ko')
xlabel('Predictor/Input')
ylabel('Response/Output')
hold on
eh = plot(poly_x,poly_y,'k--');
mse = plot_error_lines(x,y,polyval(coeffs,x),[0 0 1]);
hold off
ylim([10 40])
legend(eh,[num2str(polynomial_order) ' Order, mse:  ' num2str(mse,3)])

%% regularized least squares

polynomial_order = 10;
lambda = linspace(0,10,5);
legend_text = {'Data'};

for i = 1:length(lambda)
    legend_text = {legend_text{:} ['\lambda =' num2str(lambda(i))]};
end

phi = ones(size(x'));

for M = 1:polynomial_order
    phi = [phi x.^M'];
end



w = zeros(polynomial_order+1,length(lambda));
estimates = zeros(length(lambda),length(poly_x));

for l = 1:length(lambda)
    w(:,l) = (phi'*phi + lambda(l)*eye(polynomial_order+1))\(phi'*y');
    estimates(l,:) = polyval(w(end:-1:1,l)',poly_x);
end

plot(x,y,'ko')
hold on
plot(repmat(poly_x,length(lambda),1)',estimates')
hold off
legend(legend_text)
xlabel('Predictor/Input')
ylabel('Response/Output')
%xlim([2 10])

out = '';
for j = 1:size(w,2)
    out = [out  '|c'];
end
out = [out  '|'];
disp(out);

out = '';
for j = 1:size(w,2)
out =[ out  num2str(lambda(j)) ];
if j ~= size(w,2)
            out = [out ' &'];
        else
            out = [out ' \\'];
        end
end

disp(out);

for i = 1:size(w,1)
    out = ['$w_{' num2str(polynomial_order+1-i) '}$ &'];
    for j = 1:size(w,2)
        out = [out num2str(w(i,j),5) ];
        if j ~= size(w,2)
            out = [out ' &'];
        else
            out = [out ' \\'];
        end
    end
    disp(out);
end


%%
num_draws = 70;
reset(RandStream.getDefaultStream);
lambda = 5 ;
W = mvnrnd(zeros(2,1)+[9 0 ]',lambda*eye(2),num_draws);


figure(2)
clf

hold on
for ell = 1:size(W,1)
poly_y = polyval(W(ell,end:-1:1),poly_x);
plot(poly_x,poly_y)
end
plot(x,y,'ko');
hold off
title([ num2str(num_draws) ' random draws from prior'])
xlabel('Input')
ylabel('Output')

X= [ones(size(x')) x'];% (x.*x)']

likelihoods = -sum((repmat(y',1,num_draws)-X*W').*(repmat(y',1,num_draws)-X*W'))/2;

likelihoods = exp(likelihoods);
likelihoods = likelihoods / sum(likelihoods);

figure(1)
clf
ltxt = {'data'};
hpmi = likelihoods~=0;
inds = find(hpmi~=0);
plot_ys = zeros(sum(hpmi),length(poly_y));
hold on
for ell = 1:sum(hpmi)
poly_y = polyval(W(inds(ell),end:-1:1),poly_x);
ltxt = {ltxt{:} num2str(likelihoods(inds(ell)),5)};
plot_ys(ell,:) = poly_y;

end
plot(x,y,'ko');
plot(repmat(poly_x,sum(hpmi),1)',plot_ys')
hold off
legend(ltxt);
title('Regression functions with non-zero posterior probability')
xlabel('Input')
ylabel('Output')

figure(3)
clf
lh = plot(poly_x,likelihoods(inds)*plot_ys);
hold on
dh = plot(x,y,'ko');
hold off
legend([dh lh], 'Data', 'Posterior Mean')
hold off