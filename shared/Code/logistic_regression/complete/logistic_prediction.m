function out = logistic_prediction(X,beta)

p = 1./(1+exp(-X*beta));

out = round(p);