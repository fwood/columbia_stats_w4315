data = importdata('./uci_boston_housing/housing.data.txt');

output = data(:,end);
input = data(:,1:(end-1));
M = 10;

% run PCA for purposes of understanding multicolinearity, etc.
zminput = input - repmat(mean(input),size(input,1),1);
[u,s,v] = svd(cov(zminput));
variance_per_dimension = diag(s)/sum(diag(s));
dims_to_retain = 3;
percent_variance_accounted_for = sum(variance_per_dimension(1:dims_to_retain))
reduced_input = zminput*u(:,1:dims_to_retain);

w_opt = nn_train(input, output, M);
error = nn_error(output, input, M, w_opt);

disp(['Final error = ' num2str(error) ]);

% compare to regular linear regression
lr_error = output - input*(pinv(input))*output;

disp(['Linear regression error = ' num2str(lr_error'*lr_error) ]);


w_guess = init_w(input,output,M);
approx_grad = approximateGradient(@(param)nn_error(output, input, M, param),w_guess)

backprop_grad = nn_backprop_gradient(output, input, M, w_guess);