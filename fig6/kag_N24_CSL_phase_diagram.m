

% Figure setup
figure('Position', [0 0 800, 600]); % 3 panels
legendfontsize = 17;
ticksize = 12;
linesize = 2.5;
labelsize = 18;
pt_alpha = 0.4;

n_subplots = 3;

N36marker = 'o';

hA = tight_subplot(n_subplots, 1, [0.002 .03], [0.08 0.02], [.1 .1]);
for i = 1:n_subplots
    hA(i).FontSize = ticksize;
end

format = {'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 5};

cmap = colororder();

% -------------------------------
% Subplot 1: N3 for Bowtie
% -------------------------------

axes(hA(1));
hold on;

text(0.42, 0.015,'Abelian Chiral Spin Liquid','FontSize',20,'Interpreter','latex')

text(0.03,0.08 * 0.9,'(a)', 'FontSize',20, 'Interpreter','latex')

load('gmnbowtie_N24.mat')
plot(lamList,gmnList,'LineWidth',linesize,'DisplayName','N=24','Color',cmap(1,:))
xlabel('\lambda','FontSize',labelsize)
ylabel('$\mathcal{N}_3$','FontSize',labelsize,'Interpreter','latex')
set(gca,'FontSize',15)
set(gca, 'XTick', []);
yticks = 0:0.02:0.075;
set(gca,'YTick',yticks)
xlim([0,1])
ylim([0,0.08])
yticks = 0:0.02:0.08;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)

% comparison with N36
load('gmnbowtie_N36.mat')
plot(lamList,gmnList,N36marker,'LineWidth',linesize,'MarkerSize',9,'DisplayName','N=36','Color',cmap(1,:))

legend('fontsize',legendfontsize,'Location','southeast')

% -------------------------------
% Subplot 2: N3 for Hexagon
% -------------------------------

axes(hA(2));
hold on;

text(0.03,0.1 * 0.9,'(b)', 'FontSize',20, 'Interpreter','latex')

load('gmn_plaq222_N24.mat')
plot(lamList,gmnList,'LineWidth',linesize,'Color',cmap(1,:))
xlabel('\lambda','FontSize',labelsize)
ylabel('$\mathcal{N}_3$','FontSize',labelsize,'Interpreter','latex')
set(gca,'FontSize',15)
set(gca, 'XTick', []);
xlim([0,1])
ylim([0,0.1])
yticks = 0:0.02:0.09;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)

% comparison with N36
load('gmn_plaq222_N36.mat')
plot(lamList,gmnList,N36marker,'LineWidth',linesize,'MarkerSize',9,'DisplayName','N=36','Color',cmap(1,:))

% -------------------------------
% Subplot 3: N3 for Triangle
% -------------------------------

axes(hA(3));
hold on;

text(0.03,0.05 * 0.9,'(c)', 'FontSize',20, 'Interpreter','latex')

load('gmn_triangle_N24.mat')
plot(lamList,gmnList,'LineWidth',linesize,'Color',cmap(1,:))
xlabel('Chirality $\lambda$','FontSize',labelsize,'Interpreter','latex')
ylabel('$\mathcal{N}_3$','FontSize',labelsize, 'Interpreter','latex')
xlim([0,1])
ylim([0,0.05])
xticks = 0:0.1:1;
yticks = 0:0.01:0.04;
set(gca,'XTick',xticks)
set(gca,'XTickLabel',xticks)
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
set(gca,'FontSize',15)

% comparison with N36
load('gmn_triangle_N36.mat')
plot(lamList,gmnList,N36marker,'LineWidth',linesize,'MarkerSize',9,'DisplayName','N=36','Color',cmap(1,:))

% -------------------------------
% Subplot critical J2 values
% -------------------------------
% from https://www.nature.com/articles/ncomms6137
lam_c = 0.136;
% Set box
for ax = hA'
    axes(ax);
    a = gca;
    box(a,'on');
    % a.LineWidth = 1;
    xline(lam_c, 'k--', 'LineWidth', 2,'HandleVisibility','off');
end

% -------------------------------
% Save Figure
% -------------------------------
set(gcf, 'Units', 'inches');
screenposition = get(gcf, 'Position');
set(gcf, 'PaperPosition', [0 0 screenposition(3:4)], 'PaperSize', [screenposition(3:4)]);

print(gcf, 'Kagome_Lamscan', '-dpdf');