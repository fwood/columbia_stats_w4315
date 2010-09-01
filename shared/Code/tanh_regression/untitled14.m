n = 100;
x = [rand(n,1) rand(n,1)]*20;
y = x*[-2;4]>2;
y = y+ (y==0)*-1;

scatter3(x(:,1),x(:,2),y)


input = [ones(length(x),1) x];
w_init = rand(size(input(1,:)))';

error = (y - tanh(input*w_init)).^2

gradient = repmat(error .* (1 - tanh(input*w_init).^2),1,size(input,2)) .*input;

gradient = sum(gradient);
w = w_init;
threshold=.5;

analytic_gradient=1;


while sum(abs(error)) > threshold && norm(gradient) > .000001
    w = w - .01 * gradient';
    error = (y - tanh(input*w)).^2;
    
    switch analytic_gradient
        case 1
            gradient = repmat((y - tanh(input*w)) .* (1 - tanh(input*w).^2),1,size(input,2)) .*input;
            gradient = -sum(gradient);
        case 0
            %numeric gradient computation
            error = (y - tanh(input*w)).^2;
            w_grad = zeros(size(w));
            for i = 1:length(w)
                w(i) = w(i) + 1e-8;
                w_grad(i) = .5*sum(((y - tanh(input*w)).^2 - error))/1e-8;
                w(i) = w(i) - 1e-8;
            end
            
            gradient = w_grad';
    end
    display(['Misclassified points ' num2str(sum(abs(error))) ', norm(gradient) ' num2str(norm(gradient)) ])
end

%check gradient computation
error = (y - tanh(input*w)).^2;
w_grad = zeros(size(w));
for i = 1:length(w)
    w(i) = w(i) + 1e-8;
    w_grad(i) = sum(((y - tanh(input*w)).^2 - error))/1e-8;
    w(i) = w(i) - 1e-8;
end


gradient = repmat(error .* (1 - tanh(input*w).^2),1,size(input,2)) .*input;


% automatic gradient search
options = optimset('MaxFunEvals',1e7,'MaxIter',1000, 'Display', 'iter');
w_opt = fminunc(@(param)log_reg_error(input,y,param), w_init, options);

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