% demo -- 

% beta distribution -- prior belief factory defect rate

alpha = 2;
beta = 7;

% probability of heads
theta = linspace(0,1,50);

figure(1)
plot(theta,betapdf(theta,alpha,beta))
xlabel('\Theta')
ylabel('P(\Theta)')
legend(['Beta(' num2str(alpha) ',' num2str(beta) ')'])

%% generate factories

num_coins = 1000;
coin_thetas = betarnd(alpha,beta,num_coins,1);

figure(2)
hist(coin_thetas,100)


%% do some posterior computation(s)

outcomes = {'heads', 'tails'};

flips = gen_exampl_data();

num_flips = length(flips);

prior_params = [alpha beta];
num_heads = 0;

figure(3)
plot(theta,betapdf(theta,prior_params(1), prior_params(2)))
pause

for n =1:num_flips
    disp(['Flip outcome : ' outcomes{flips(n)+1}]);
    nth_outcome = flips(n);
    
    if nth_outcome == 0
        num_heads = num_heads + 1;
    end
       
    posterior_params = [num_heads + prior_params(1), n-num_heads + prior_params(2)];
    
    figure(2)
    plot_flips(flips,n)
    
    figure(3)
    prior_h = plot(theta,betapdf(theta,prior_params(1), prior_params(2)),'r');
    hold on
    post_h = plot(theta,betapdf(theta,posterior_params(1), posterior_params(2)),'g');
    
    alpha = .05;
    % approximately normal confidence intervals
    max_p = num_heads/n + norminv((1-alpha))*sqrt(num_heads*(n-num_heads )/(n^2)); % bug?
    min_p = num_heads/n - norminv((1-alpha))*sqrt(num_heads*(n-num_heads )/(n^2));
    
    hold off
    legend([prior_h post_h], 'Prior', ['Posterior after ' num2str(n) ' obs.']);
     xlabel('Defective=0 , Non-defective=1')
     ylabel('P(\Theta)')
     
     lower_lim = betainv(.05,posterior_params(1),posterior_params(2));
upper_lim = betainv(.95,posterior_params(1),posterior_params(2));
    
    line([lower_lim lower_lim],[0 max(betapdf(theta,posterior_params(1), posterior_params(2)))]);
    line([upper_lim upper_lim],[0 max(betapdf(theta,posterior_params(1), posterior_params(2)))]);
    drawnow
    
    figure(4) % posterior predictive
    
    predicted_outcome = 0;
    log_p_heads = gammaln(prior_params(1)+prior_params(2)+n) - gammaln(num_heads + prior_params(1)) - gammaln(n-num_heads + prior_params(2)) + ...
        gammaln(num_heads + prior_params(1) + (1-predicted_outcome)) + gammaln(n+1 -num_heads -(1-predicted_outcome)+ prior_params(2)) - gammaln(prior_params(1)+ prior_params(2)+n+1);
    predicted_outcome = 1;
    log_p_tails = gammaln(prior_params(1)+prior_params(2)+n) - gammaln(num_heads + prior_params(1)) - gammaln(n-num_heads + prior_params(2)) + ...
        gammaln(num_heads + prior_params(1) + (1-predicted_outcome)) + gammaln(n+1 -num_heads -(1-predicted_outcome)+ prior_params(2)) - gammaln(prior_params(1)+ prior_params(2)+n+1);
    
    bar([0 1], exp([log_p_heads log_p_tails]));
    xlabel('Defective=0 , Non-defective=1')
    ylabel('Posterior predictive probability');
    
    if n<10
        pause
    end
end

%% now that we have the posterior let's ask some questions like -- what's
% the probability that theta is below .15

%something like the 95% confidence interval -- here taking into account
% the prior

lower_lim = betainv(.05,posterior_params(1),posterior_params(2))
upper_lim = betainv(.95,posterior_params(1),posterior_params(2))