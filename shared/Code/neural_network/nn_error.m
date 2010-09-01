function error = nn_error(output, input, M, w, regularizationWeight)

if nargin<5
    regularizationWeight = 0;
end

D = size(input,2);
K = size(output,2);
[w_1, w_2] = unpack(w,D,M,K);

input = [ones(size(input,1),1) input];

hl_activations = input*w_1; % hidden layer activations
%sigmoid nonlinearity

z = tanh(hl_activations);

z= [ones(size(z,1),1) z];

ol_activations = z*w_2;

error = output-ol_activations;
error = (error')*error + regularizationWeight*w'*w;



