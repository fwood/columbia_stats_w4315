function log_prior = beta_prior(beta,lambda)
log_prior = -1/lambda * beta'*beta;