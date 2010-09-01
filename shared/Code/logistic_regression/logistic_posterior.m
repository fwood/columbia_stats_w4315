function lik = logistic_posterior(X,y,beta,lambda)

lik = logistic_likelihood(X,y,beta) + beta_prior(beta,lambda);