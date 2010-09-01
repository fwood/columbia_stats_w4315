function w_guess = init_w(input,output,M)

D = size(input,2);
K = size(output,2);

w_1 = randn(D+1,M);
w_2 = randn(M+1,K);

w_guess = pack(w_1, w_2,D,M,K);
