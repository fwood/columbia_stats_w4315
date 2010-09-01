%show_nonlinear_capability

x_0 = rand(10,1)*10;
y_0 = -3*x_0 +5;
x_1 = rand(10,1)*10 + 10;
y_1 = 3*x_1 -10;

input = [x_0; x_1];
output = [y_0; y_1];

plot(input,output,'o')

regularizationWeight = .01;
M=4;

w_opt = nn_train_approx_gradient(input, output, M, regularizationWeight);
error = nn_error(output, input, M, w_opt);

disp(['Final error = ' num2str(error) ]);

% compare to regular linear regression
b_opt = (pinv([ones(size(input,1),1) input]))*output;
lr_error = output - [ones(size(input,1),1) input]*b_opt;

disp(['Linear regression error = ' num2str(lr_error'*lr_error) ]);

prediction_inputs = linspace(0,20,100)';

nn_prediction_outputs = nn_predict(prediction_inputs,M,1,w_opt);

lr_prediction_outputs = [ones(size(prediction_inputs,1),1) prediction_inputs]*b_opt;

hold on
nn_lh = plot(prediction_inputs,nn_prediction_outputs,'r');
lr_lh = plot(prediction_inputs,lr_prediction_outputs,'g');
hold off
legend([nn_lh lr_lh], 'Neural Net', 'Lin. Reg.','Location','NorthWest');
makeAxisExportReady(gca)

disp(['# NN parameters ' num2str(length(w_opt))])
disp(['# LR parameters ' num2str(length(b_opt))])