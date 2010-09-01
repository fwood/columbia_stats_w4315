function log_lik = logistic_likelihood(X,y,beta)
mu = exp(-X*beta);
p = 1./(1+mu);

log_lik = sum ( y.* log(p) + (1-y).* log(1-p));