x = mvnrnd(ones(10,1)*10,eye(10)*50,20);


for i = 1:50
    inds = randperm(10);
    inds = inds(1:5);
    
    weights = mvnrnd(ones(5,1),eye(5),1);
    
    x = [x x(:,inds)*(weights')];
end

x = [ones(size(x,1),1) x];