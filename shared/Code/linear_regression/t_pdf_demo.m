nu = 2; % degrees of freedom
x = linspace(-10,10,100);
y = tpdf(x,nu);

%%
plot(x,y)
hold on
plot(x,normpdf(x,0,1),'r')
hold off
legend(['PDF \nu = ' num2str(nu)])

%%
c = tcdf(x,nu);
plot(x,c)
legend(['CDF \nu = ' num2str(nu)])

%%
p = linspace(0,1,100);
i = tinv(p,nu);
plot(p,i);
legend(['ICDF \nu = ' num2str(nu)])