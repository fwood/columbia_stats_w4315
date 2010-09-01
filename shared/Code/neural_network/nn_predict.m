function output = nn_predict(input, M, K, w)
D = size(input,2);
[w_1, w_2] = unpack(w,D,M,K);

input = [ones(size(input,1),1) input];

hl_activations = input*w_1; % hidden layer activations
%sigmoid nonlinearity

z = tanh(hl_activations);

z= [ones(size(z,1),1) z];

output = z*w_2;

