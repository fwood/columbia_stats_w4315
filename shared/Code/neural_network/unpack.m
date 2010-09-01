function [w_1, w_2] = unpack(w,D,M,K)

D = D+1; % to account for bias
M = M+1; % to account for bias

w_1 = w(1:D*(M-1));
w_2 = w((D*(M-1)+1):end);
w_1 = reshape(w_1,D,M-1);
w_2 = reshape(w_2,M,K);