function grad = approximateGradient(func, param) 

grad = zeros(size(param));
step = .00001;

for i = 1:length(param)
    delta = zeros(size(param));
    delta(i) = step;
    grad(i) = (func(param + delta) - func(param)) / step;
end