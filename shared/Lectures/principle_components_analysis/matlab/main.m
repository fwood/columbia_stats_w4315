% given a Gaussian pdf, find the PCA projection of the pdf
Sigma = [  4.5552   -1.5; ...
          -1.5    1.0453]; % true covariance matrix
mu = [2 5]; % mean

% generate sample points and their probability under the model
[X Y] = meshgrid(linspace(-5,10,50),linspace(-5,10,50));
plot_data = [reshape(X,numel(X),1) reshape(Y,numel(Y),1)];
plot_value = mvnpdf(plot_data,mu,Sigma);
Z = reshape(plot_value,size(X));
surf(X,Y,Z)
xlabel('X')
ylabel('Y')
axis('equal')
view([0 89])
%makeAxisExportReady(gca)

% compute the PCA loading matrix
[V,D] = eig(Sigma); % unordered eigenvalues
[A Lambda A_trans] = svd(Sigma); % ordered eigenvalues

% compute percentage of variance accounted for by different pc's
diag(Lambda)/sum(diag(Lambda)) * 100

% plot rotation of cartesian axes 
new_xy = [1 0; 0 1]*A
hold on
qh = quiver3(repmat(mu(1),2,1),repmat(mu(2),2,1),repmat(max(plot_value),2,1),new_xy(1,:), new_xy(2,:),repmat(0,2,1)); 
hold off
set(qh,'Color',[0 0 0 ])
set(qh,'LineWidth',2)
axis('equal')
pause

% A is an orthogonal basis -- 
% should be equal --
Sigma*A
A*Lambda

% show entire field rotated
rotated_plot_data = (plot_data-repmat(mu,size(plot_data,1),1))*A

X_rotated = reshape(rotated_plot_data(:,1),size(X));
Y_rotated = reshape(rotated_plot_data(:,2),size(Y));

surf(X_rotated,Y_rotated,Z)
xlabel('1st PC Projection')
ylabel('2nd PC Projection')
view([0 90])
%makeAxisExportReady(gca)

% PCA comes from dropping low eigenvalue PC's
pause

% before we show this, consider the sample covariance instead
num_samples = 500;
samples = randn(num_samples,2)*chol(Sigma)+repmat(mu,num_samples,1)
sh = scatter(samples(:,1),samples(:,2))
 set(sh,'MarkerFaceColor','flat')
zm_samples = samples-repmat(mean(samples),num_samples,1);
sample_covariance_matrix= 1/(num_samples-1) *zm_samples' * zm_samples;
axis('equal')
[A Lambda A_trans] = svd(sample_covariance_matrix); % ordered eigenvalues of sample covariance matrix
% compute percentage of variance accounted for by different pc's
diag(Lambda)/sum(diag(Lambda)) * 100


% plot rotation of cartesian axes again -- 
new_xy = A*[1 0; 0 1] % obviously unecessary but pedagogically useful
hold on
qh = quiver(repmat(mu(1),2,1),repmat(mu(2),2,1),new_xy(1,:)', new_xy(2,:)'); 
hold off
set(qh,'Color',[0 0 0 ])
set(qh,'LineWidth',2)
%makeAxisExportReady(gca)
xlabel('X')
ylabel('Y')

pause

projected_samples = samples*A
sh = scatter(projected_samples(:,1),projected_samples(:,2))
 set(sh,'MarkerFaceColor','flat')
axis('equal')
xlabel('PC projection #1')
ylabel('PC projection #2')
%makeAxisExportReady(gca)


% PCA helps with multicolinearity 

% set up normal linear regression relationship (noise-free for pedagogical
% purposes
output = samples*[-1; 2] + 5;

sh = scatter3(samples(:,1),samples(:,2),output)
set(sh,'MarkerFaceColor','flat')
xlabel('x_1')
ylabel('x_2')
zlabel('y')
view([-24 62])
pause
view([-46 8])

% linear model parameter estimation 

xx = [samples ones(size(samples,1),1)]
lm_parameters = inv(xx'*xx)*(xx')*output

% add in a colinear input variable
colinear_samples = [ samples  samples(:,1)*.8 + samples(:,2)*.5];

xx_colinear = [colinear_samples ones(size(colinear_samples,1),1)]
lm_parameters = inv(xx_colinear'*xx_colinear)*(xx_colinear')*output


% regularization helps condition the regression matrix
regularization_constant = .25;
lm_parameters = inv(xx_colinear'*xx_colinear +regularization_constant*eye(size(xx_colinear,2)))*(xx_colinear')*output

% but PCA identifies the projection that eliminates the extra variable

zm_samples = colinear_samples-repmat(mean(colinear_samples),num_samples,1);
sample_covariance_matrix= 1/(num_samples-1) *zm_samples' * zm_samples;
axis('equal')
[A Lambda A_trans] = svd(sample_covariance_matrix); % ordered eigenvalues of sample covariance matrix
% compute percentage of variance accounted for by different pc's
diag(Lambda)/sum(diag(Lambda)) * 100
% note first two covariance matrices describe 100% (!) of the variance of
% the variables

% so we can project the data onto the first two columns of the 
% loading matrix
pc_projection = colinear_samples*A(:,1:2)
% which returns us to the kind of distribution we had before introducing
% the colinear input variable
sh = scatter(pc_projection(:,1),pc_projection(:,2))
set(sh,'MarkerFaceColor','flat')
axis('equal')
xlabel('PC projection #1')
ylabel('PC projection #2')

% problems with PCA

poorl_distributed_data = [betarnd(.1,.1,num_samples,2)];
sh = scatter(poorl_distributed_data(:,1),poorl_distributed_data(:,2))
set(sh,'MarkerFaceColor','flat')
axis('equal')
xlabel('X')
ylabel('Y')
mu = mean(poorl_distributed_data);

zm_samples = poorl_distributed_data-repmat(mean(poorl_distributed_data),num_samples,1);
sample_covariance_matrix= 1/(num_samples-1) *zm_samples' * zm_samples;
axis('equal')
[A Lambda A_trans] = svd(sample_covariance_matrix); % ordered eigenvalues of sample covariance matrix
% compute percentage of variance accounted for by different pc's
diag(Lambda)/sum(diag(Lambda)) * 100


% plot rotation of cartesian axes again -- 
new_xy = A*[1 0; 0 1] % obviously unecessary but pedagogically useful
hold on
qh = quiver(repmat(mu(1),2,1),repmat(mu(2),2,1),new_xy(1,:)', new_xy(2,:)'); 
hold off
set(qh,'Color',[0 0 0 ])
set(qh,'LineWidth',2)
%makeAxisExportReady(gca)
xlabel('X')
ylabel('Y')

pause

projected_samples = poorl_distributed_data*A
sh = scatter(projected_samples(:,1),projected_samples(:,2))
 set(sh,'MarkerFaceColor','flat')
axis('equal')
xlabel('PC projection #1')
ylabel('PC projection #2')