function flips = gen_exampl_data

%% set random number generator seed
reset(RandStream.getDefaultStream,0);

theta = .85; % prob heads

flips = rand(200,1) < .85;

visibility = 10;

% plot_flips(flips,visibility)
% pause
% plot_flips(flips,100)

