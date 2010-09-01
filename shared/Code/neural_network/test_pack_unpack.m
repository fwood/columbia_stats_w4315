% test pack / unpack nn weights

D = 2;
M = 4;
K = 3;

w_1 = [-1 -2 -3 -4; -5 -6 -7 -8; -9 -10 -11 -12]
w_2 = [1 2 3; 4 5 6; 7 8 9; 10 11 12; 13 14 15 ]

w= pack(w_1, w_2,D,M,K);

[w_1_new, w_2_new] = unpack(w,D,M,K)