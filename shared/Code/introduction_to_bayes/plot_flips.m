function plot_flips(flips,visibility)
clf
hdls = scatter(1:visibility,flips(1:visibility),'ko');
for i=1:length(hdls)
    set(hdls,'LineWidth',1)
end
flips(1:visibility);
xlim([0 length(flips)])
xlabel('Part Number')
ylabel('Outcome -- 0 = defective, 1 = not defective')