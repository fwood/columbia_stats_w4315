load spambase.data

all_labels = spambase(:,end);
all_data = spambase(:,1:(end-1));

rand_inds = randperm(length(all_labels));
all_labels = all_labels(rand_inds);
all_data = all_data(rand_inds,:);

training_data_inds = 1:100;
test_data_inds = setdiff(1:length(all_labels),training_data_inds);

training_data = all_data(training_data_inds,:);
training_labels = all_labels(training_data_inds);

test_data = all_data(test_data_inds,:);
test_labels = all_labels(test_data_inds);


beta = ones(size(test_data,2),1)/1000;
lik = logistic_likelihood(test_data,test_labels,beta)

lambda = 3;
lik = beta_prior(beta, lambda);

logistic_posterior(test_data,test_labels,beta,lambda)

num_samples = 300;

current_score = logistic_posterior(test_data,test_labels,beta,lambda)
scores = zeros(1,num_samples);
percent_training_correct = zeros(1,num_samples);
percent_test_correct = zeros(1,num_samples);
betas = zeros(length(beta),num_samples);

accepts = 0;

for s = 1:num_samples


    for d = 1:length(beta)
        
        b_current = beta(d);
        b_proposal = beta(d) + randn * .1;
        beta_proposal = beta;
        beta_proposal(d) = b_proposal;
        
        proposal_score = logistic_posterior(training_data,training_labels,beta_proposal,lambda);
        
        if isnan(proposal_score)
            proposal_score = -Inf;
        end
        
        log_accept_probability = min(0,proposal_score-current_score);
        
        % disp(['Accept prob ' num2str(exp(log_accept_probability))]);
        if log(rand) < log_accept_probability %accept
            beta = beta_proposal;
            current_score = proposal_score;
            accepts = accepts +1;
        end
        
    end
    scores(s) = current_score;
    
    %beta
    betas(:,s) = beta;
    
    percent_training_correct(s) = percent_correct(training_labels,logistic_prediction(training_data,beta));
    percent_test_correct(s) = percent_correct(test_labels,logistic_prediction(test_data,beta));
    
    
    acceptance_ratio =accepts / (s*d);
    disp(['Acceptance ratio ' num2str(acceptance_ratio)]);
    figure(1)
    plot(1:s,scores(1:s));
    xlabel('Sample Number');
    ylabel('Posterior Score');
    figure(2)
    plot(1:s,percent_training_correct(1:s));
    xlabel('Sample Number');
    ylabel('Training Classified Correctly');
    figure(3)
    plot(1:s,percent_test_correct(1:s));
    xlabel('Sample Number');
    ylabel('Test Classified Correctly');
    
    drawnow
    
end