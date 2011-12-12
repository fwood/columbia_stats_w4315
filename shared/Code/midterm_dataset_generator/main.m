% this script generates a large number of datasets on which the 
% w4315 midterm is based -- it generates one dataset for each student which
% is a row and column permutation of a single regression dataset
%
% an answer key is also generated based on the the permutation of the data
% used for each student

% a spreadsheet containing a single column of unis is required as input in
% a particular base directory.  All outputfiles will be saved into this
% director
basedir = '/Users/fwood/Projects/columbia_stats_w4315/sections/wood_2011_fall/src/Midterm/';
unicsv = [basedir 'gradebook-STATW4315_003_2011_3-2011-11-18.csv'];
studentdatafilesuffix = '_data.csv';
answer_key = 'answer_key.csv';
dataset_assignment_page_filename = 'assignments.page';
unis = importdata(unicsv);
numstudents = length(unis);

stream = RandStream('mt19937ar','Seed',5489); % MATLAB's start-up settings
RandStream.setDefaultStream(stream);

%rng(54321);

% true regression function

n = 100;
x_2 = repmat([0 1],1,n/2)'; %zeros(n,1);
%x_2((n/2+1):end) = 1;
x_3 = ~(x_2);%x_2(end:-1:1);
%x_2 = ones(n,1);
%x_3 = zeros(n,1);

x_0 = -1000;
v_x_f = 120;
v_x_s = 100;
g = -5;
t = linspace(0,10,100);%rand(100,1)*10;
v_y = -g*10;
f_s_switch = 1;
v_x = (v_x_f^f_s_switch + v_x_s^(1-f_s_switch));

y_t = v_y * t +g * t.^2;
x = v_x * t +x_0;
plot(x,y_t);

x_1 = linspace(-1000,0,100)';

y_t_2 = g/(v_x^2)*x_1.^2 + (v_y/v_x - 2*x_0*g/(v_x^2))*x_1 - ((v_y/v_x)*x_0 -g * (x_0^2)/(v_x^2));

hold on
plot(x_1,y_t_2,'r');
hold off

b_2 = g/(v_x_f^2);
b_3 = g/(v_x_s^2);
b_4 = v_y/v_x_f - 2*x_0*g/(v_x_f^2);
b_5 = v_y/v_x_s - 2*x_0*g/(v_x_s^2);
b_6 = -v_y*x_0 / v_x_f +g * (x_0^2)/(v_x_f^2);
b_7 = -v_y*x_0 / v_x_s +g * (x_0^2)/(v_x_s^2);


Phi = [x_2.*(x_1.^2) x_3.*(x_1.^2) x_2.*x_1 x_3.*x_1 x_2 x_3];

y = Phi*[b_2; b_3; b_4; b_5; b_6; b_7];

sigma_squared=20;

noise =  randn(size(y))*sqrt(sigma_squared);

y = y + noise;

hold on
scatter(x_1,y,[],x_2)
hold off

true_beta_vector = [b_2; b_3; b_4; b_5; b_6; b_7]
% easy phi is matrix as it is now
% only need to provide x_1, everything else is an interaction term

% the only terms necessary to do the regression are
% x_1 and x_2, the rest should be "learnable from x_1 and x_2
% so, the hard problem can be to embed x_1 and x_2 alone into a matrix of
% garbage and then give different permutations to each kid in the class

% create garbage columns
% binary garbage columns
x_bin_garb = round(rand(n,49));
x_real_garb = randn(n,49)*500;

X = [x_1 x_2 x_real_garb x_bin_garb];

fakid = fopen([basedir answer_key],'w');
apid = fopen([basedir dataset_assignment_page_filename], 'w');


for i = 1:numstudents
    datafid = fopen([basedir num2str(i) studentdatafilesuffix], 'w');
    row_perm = randperm(size(X,1));
    X_stud_i = X(row_perm,:);
    y_stud_i = y(row_perm);
    column_perm = randperm(size(X,2));
    X_stud_i = X_stud_i(:,column_perm);
    fprintf(fakid, [unis{i} ', ' num2str(i) ', ' num2str(find(column_perm==1)) ', ' num2str(find(column_perm==2)) '\n']);
    
    for j = 1:size(X,1);
        fprintf(datafid, [num2str(y(row_perm(j))) ', ']);
        for m = 1:size(X,2);
            fprintf(datafid, [num2str(X(row_perm(j), column_perm(m))) ', ']);
        end
        fprintf(datafid, '\n');
    end
    
    
    fprintf(apid,[ '[' unis{i} '](' num2str(i) studentdatafilesuffix ')\n']);
    fclose(datafid);
    
end
fclose(fakid);
fclose(apid);

    
