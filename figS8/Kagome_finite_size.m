
load('kagome_GMN_finite_size_data.mat','Nlist','gmn212','gmn222')

% new
groupOrder = [48 48 96 20 144];

cmap = colororder();

figure;

plot(Nlist,gmn212,'LineStyle','-','LineWidth',3, ...
    'Marker','^','MarkerSize',10,'Color',cmap(1,:));
hold on
plot(Nlist,gmn222,'LineStyle','-.','LineWidth',3, ...
    'Marker','o','MarkerSize',10,'Color',cmap(1,:));

ax=gca;
ax.FontSize = 16;

legend('Bowtie','Hexagon','FontSize',20)
xlim([10 40])
ylim([0 0.06])
% xticks(10:5:40)
% yticks(0:0.01:0.06)
xlabel('$N$', 'fontsize', 20, 'Interpreter','latex');
ylabel('$\mathcal{N}_3$', 'fontsize', 20, 'Interpreter','latex');

set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);

print(gcf, 'Kagome_gmn_Nscan', '-dpdf');