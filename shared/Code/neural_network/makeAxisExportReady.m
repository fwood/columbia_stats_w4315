function makeAxisExportReady(axis)

if get(axis,'Type') == 'axes' 
set(axis,'FontSize',16)
end
set(axis,'LineWidth',2)

children = get(axis,'Children');

for i = 1:length(children)
makeAxisExportReady(children(i))
end