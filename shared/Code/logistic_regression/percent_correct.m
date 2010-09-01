function answer = percent_correct(y,y_hat)
answer =sum(y==y_hat) / length(y);