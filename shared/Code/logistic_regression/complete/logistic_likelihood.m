function log_lik = logistic_likelihood(X,y,beta)

eta = X*beta;
p = 1./(1+exp(-eta));


log_lik = sum(y.*log(p) + (1-y).*log(1-p));

cumsum = 0;

for i=1:length(y)
    cumsum = cumsum + log(p(i))*y(i) + log(1-p(i))*(1-y(i));
end
