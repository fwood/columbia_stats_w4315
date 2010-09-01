% show gradient computation

function w_opt = nn_train_approx_gradient(input, output, M, regularizationWeight)

if nargin<4
    regularizationWeight = 0;
end

learningRate = .001;

threshold = .25;
grad_norm = Inf;

w_init = init_w(input,output,M);

w_opt=w_init;
iter = 1;
while grad_norm > threshold


 gradient = approximateGradient(@(param)nn_error(output, input, M, param, regularizationWeight),w_opt)

 w_opt = w_opt - learningRate *gradient;
 grad_norm = norm(gradient)
 disp(['Iteration ' num2str(iter) ', error ' num2str(nn_error(output, input, M, w_opt, regularizationWeight)) ', grad norm ' num2str(grad_norm)])
 iter = iter +1;
end