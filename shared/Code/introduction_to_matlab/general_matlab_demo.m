% variables can be scalars, vectors, or matrices in matlab
% -- matrices are first class objects

a = 1

b = [1 2 3]

% transpose
b = b'

% column vector
b = [1; 2; 3]

% a semicolon suppresses output
c = [1 0 ; 0 1];

% there are commands for creating basic datastructures -- think of these as
% building blocks that you can compose to create more complicated
% datastructures
d = eye(2);

% matlab scripts can be thought of as a bunch of calculator inputs strung
% together.  Of course, one can write functions in matlab as well

% matlab has tons and tons of built in commands for doing just about
% everything.  For now we just want to get you used to the language and a
% few basic commands that will be useful for you later on

% to start we need data, we can either specify it by typing it in (like
% before)

output = [1 2 4 5 7 9];

% then we can plot the data
plot(output)

% if we don't specify options we get a line -- try

help plot

% to see what options are available for this or any other command

plot(output,'ko') 

% says plot the data using black circles instead of a line
% the x-axis data is implictly 1:6 (meaning [1 2 3 4 5 6] in this case,
% let's change that

% this tells you the length of a vector
length(output)

% so does 
size(output,2)

% this is a function to produce a linear spacing between a two points
% points where the intervals between the values are computed appropriately
input = linspace(-5,5,length(output))

% notice the x-axis now
plot(input,output,'ko')

% if we want to label ourplot we can add axis labels and a title... for
% instance

xlabel('Input') 
% here, anything contained in a '' is a string
ylabel('Output')
title('Scatter Plot')

% matlab interprets a subset of latex commands and they can be used in 
% figure captions, for instance

ylabel('\alpha, \beta')

% matlab has plenty of routines for reading in data, not only from files,
% but also from databases, spreadsheets, and websites.  We're going to
% stick with files in this class.  For instance
data = importdata('CH01PR19.txt')

% data is a num_rows by num_cols matrix
[num_rows, num_cols] = size(data)

% a subset of the matrix can be selected, : is shorthand for all rows or
% columns
output = data(:,1)
input = data(:,2)

% other subsets, including single elements can be selected
element = data(2,2)

% binary (or set indicator) indexing is more advanced 
indexes_of_interest = zeros(size(data));

% zeros makes a matrix of all zeros of a given size

% we will select two data items
indexes_of_interest(2,2) = 1;
indexes_of_interest(end,1) = 1;

% end is shorthand for the last element of a vector or the last allowable
% index in a particular dimension

% now we can use the binary indexes to grab the data.  logical converts
% real numbers to binary (logical) values
data(logical(indexes_of_interest))

% we can plot the real data now
plot(input,output,'ko')

% histogram
% generate standard normal random variables
a = randn(1, 1000)
hist(a)
% this only gives you count histogram, we need to do
% some tricks to get the density histogram
[n,x] = hist(a, [-3:.2:3]) % -3:.2:3 generate a sequence from -3 to 3 with even intervals of .2
bar = (x, n/(1000*.2))


% now we can start computing some regression stuff

% to compute the mean of the inputs we can write a for loop
X_bar = 0;
n = length(input);
for i=1:n
    X_bar = input(i) + X_bar;
end
X_bar = X_bar / n

% or a while loop
X_bar = 0;
n = length(input);
i = 1;
while i<=n
    X_bar = input(i) + X_bar;
    i=i+1;
end
X_bar = X_bar / n

% of course, it's even easier to write
X_bar = mean(input)

Y_bar = mean(output)

% we can compute the sum of squares of the inputs as well, now that we have the
% mean


SSX = 0;
n = length(input);
for i=1:n
    SSX = SSX+ (input(i) - X_bar)^2; % hat means square
end

SSX

% of course this is just the sample variance times n-1 so we can get this
% quantity this way as well -- be careful about the normalization used by
% matlab

SSX = var(input)*(n-1)

SSXY = 0;
n = length(input);
for i=1:n
    SSXY = SSXY+ (input(i) - X_bar)*(output(i)-Y_bar);
end

SSXY

cov_matrix = cov(input,output)*(n-1);
SSXY = cov_matrix(1,2)

% here we see the first numerical difference arising -- not a big deal

b_1 = SSXY/SSX

b_0 = (Y_bar-b_1*X_bar)

% now we can overlay the regression line

% make up some input points
x_plot = linspace(min(input),max(input),100);
y_plot = b_1*x_plot + b_0;  % vector times scalar plus scalar -- something fancy is going on here


% hold must be used to draw on top of old plots
hold on
rh = plot(x_plot,y_plot,'r-');
hold off
legend(rh,'Regression fit');
xlabel('ACT score');
ylabel('Freshman GPA');

% we can open another window
figure(2)
% function can be defined and used -- functions clean up your code a lot
plot_gpa_fit(input,output,b_1,b_0)

% looking ahead we can write a function that takes an input and an output
% and outputs b_1 and b_0 (functions in matlab can return more than one
% return value.  we will use the matrix linear regression formulation 
% in this demonstration

[b_1 b_0] = my_regress(input,output)

% we can use the statistics toolbox to manually calculate confidence
% intervals for, say, b_1

sum_e_squared = output-(b_1*input + b_0);
sum_e_squared = sum_e_squared.^2;
sum_e_squared = sum(sum_e_squared);

V_b_1_hat = (sum_e_squared/(n-2))/SSX;

alpha = .05;

confidence_interval_for_b_1 = [b_1 - tinv(1-alpha/2,n-2)*sqrt(V_b_1_hat) b_1 + tinv(1-alpha/2,n-2)*sqrt(V_b_1_hat)];
