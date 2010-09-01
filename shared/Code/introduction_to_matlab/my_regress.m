function [b_1 b_0] = my_regress(input,output)

% output = [b_1 b_0] * [input 1] -> [b_1 b_0] = pinv([pinput 1])*output

M = [input ones(size(input))];
A = pinv(M)*output;
% or A = M\output;
b_1 = A(1);
b_0 = A(2);

