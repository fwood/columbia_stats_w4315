function backprop_grad = nn_backprop_gradient(output, input, M, w)

D = size(input,2);
K = size(output,2);
[w_1, w_2] = unpack(w,D,M,K);

input = [ones(size(input,1),1) input];

hl_activations = input*w_1; % hidden layer activations
%sigmoid nonlinearity

z = tanh(hl_activations);

z= [ones(size(z,1),1) z];

ol_activations = z*w_2;

delta_1 = output-ol_activations;

dEn_dwkj2 = sum(repmat(delta_1,1,(M+1)).*z,1)

dEn_dwji1 = (-z.^2 +1)



