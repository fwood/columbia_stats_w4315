%generate data

n = 100;
x = [rand(n,1) rand(n,1)]*20;
y = x*[-2;4]>2;
y = y+ (y==0)*-1;

% introduce noisy labels if you're feeling nasty
%y([5 9 89]) = -1*y([5 9 89]);

scatter3(x(:,1),x(:,2),y)


% add bias 
input = [ones(length(x),1) x];

% initialize weight vector
w_init = rand(size(input(1,:)))';


% set threshold for gradient learning stoppage (in absolute error terms)
threshold=.5;

% if 1 use analytic gradient, if 0 use numerical gradient
analytic_gradient=1;

% set up stoppage criteria 
gradient_norm = Inf;
abs_error = Inf;
w = w_init;

while  abs_error> threshold &&  gradient_norm> .0001
    
    switch analytic_gradient
        case 1
            gradient = repmat((y - tanh(input*w)) .* (1 - tanh(input*w).^2),1,size(input,2)) .*input;
            gradient = -sum(gradient);
        case 0
            %numeric gradient computation
            
            %step 
            step = 1e-8;
            
            error = (y - tanh(input*w)).^2;
            w_grad = zeros(size(w));
            for i = 1:length(w)
                w(i) = w(i) + step;
                w_grad(i) = .5*sum(((y - tanh(input*w)).^2 - error))/step;
                w(i) = w(i) - step;
            end
            
            gradient = w_grad';
    end
    
    w = w - .01 * gradient';
    error = (y - tanh(input*w)).^2;
    abs_error = sum(abs(error));
    gradient_norm = norm(gradient);
    display(['Misclassified points ' num2str(sum(abs(error))) ', norm(gradient) ' num2str(norm(gradient)) ])
end

% automatic numeric gradient search with hessian approximation, etc.
options = optimset('MaxFunEvals',1e7,'MaxIter',1000, 'Display', 'iter');
w_opt = fminunc(@(param)log_reg_error(input,y,param), w_init, options);


% display regression function
[X,Y] = meshgrid(linspace(0,20,100),linspace(0,20,100));

pred_input = [reshape(X,prod(size(X)),1) reshape(Y,prod(size(Y)),1)];
pred_input = [ones(size(pred_input(:,1))) pred_input];

Z = tanh(pred_input*w);

Z = reshape(Z,size(X));

lh = surf(X,Y,Z)
set(lh,'EdgeAlpha',0)
set(lh,'FaceAlpha',.5)
hold on
scatter3(x(:,1),x(:,2),y)
hold off