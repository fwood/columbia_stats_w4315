function w_opt = nn_train(input, output, M, regularizationWeight)

if nargin<4
    regularizationWeight = 0;
end


w_init = init_w(input,output,M);
% error = nn_error(output, input, M, w_init);
% 
% disp(['Initial error = ' num2str(error) ]);
options = optimset('MaxFunEvals',1e7,'MaxIter',1000, 'Display', 'iter')
w_opt = fminunc(@(param)nn_error(output, input, M, param, regularizationWeight),w_init,options);

