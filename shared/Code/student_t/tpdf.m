function [y lny] = tpdf(x,v,mu,sigma)
% TPDF  Probability density function (pdf) for Student's T distribution
%   Y = TPDF(X,V) returns the pdf (and log pdf) of Student's T distribution with
%   b degrees of freedom, 
%   mu location,
%   sigma scale > 0, at the values in X.
%
%   The size of Y is the size of X. 
%
%   References:
%      [1] Bayesian Data Analysis pg 576

lny = gammaln((v+1)/2) - gammaln(v/2) - log(sqrt(v*pi)*sigma) -((v+1)/2) *...
    log(1+(1/v)*(((x-mu)/sigma)^2));
y = exp(lny);