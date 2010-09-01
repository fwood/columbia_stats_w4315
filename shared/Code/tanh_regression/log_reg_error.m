function error = log_reg_error(input,output, w)

error = (output - tanh(input*w)).^2;
error = sum(error);