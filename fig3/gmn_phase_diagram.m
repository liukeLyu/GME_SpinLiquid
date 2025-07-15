% GMN_PhaseDiagram_Dynamic.m
% This script generates a phase diagram with 4 rows, dynamically skipping missing data.
% It handles separate h_values for Erik and Andrea.

clear; clc;

% -------------------------------
% 1. Configuration
% -------------------------------

hc1 = 0.2223 * sqrt(3);
hc2 = 0.3695 * sqrt(3);
fillalpha = 0.1;
fillcolor = [0 0.4470 0.7410];
xmax = 1;

% Figure setup
figure('Position', [0 0 800, 600]);
legendfontsize = 14;
ticksize = 12;
linesize = 2.5;
labelsize = 18;
pt_alpha = 0.4;

hA = tight_subplot(3, 1, [0.002 .03], [0.08 0.02], [.1 .1]);
for i = 1:3
    hA(i).FontSize = ticksize;
end

format = {'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 5};

colors = get(gca,'colororder');
colors = num2cell(colors,2); % cell array containing all the colors
linestyle_chiral = '-';

selectErik = [1 2 3 4 5 9 13 14 15 16 18 19 20 21 22];
selectAndrea = 4:17;

% -------------------------------
% 2. Subplot 1: N3 and N6 (Plaquette)
% -------------------------------

load('n3_plaq_results.mat')
load('n6_plaq_results.mat')

axes(hA(1));
hold on;

plot(dat_n3_plaq(:,1), dat_n3_plaq(:,2), '-o', 'DisplayName', '3 party', format{:},'Color',colors{1});
plot(dat_n6_plaq(:,1), dat_n6_plaq(:,2), ':d', 'DisplayName', '6 party', format{:},'Color',colors{1});

load('n3_plaq_chiral_results.mat')
plot(dat_n3_plaq_chiral(:,1),dat_n3_plaq_chiral(:,2),'LineWidth',linesize,'LineStyle','-','DisplayName', ...
    '3 party, Chiral','Color',[colors{1} pt_alpha],'HandleVisibility','off');

load('n6_plaq_chiral_results.mat')
plot(dat_n6_plaq_chiral(:,1),dat_n6_plaq_chiral(:,2),'LineWidth',linesize,'LineStyle',':','DisplayName', ...
    '6 party, Chiral','Color',[colors{1} pt_alpha],'HandleVisibility','off');

text(0.01,0.27 * 0.9,'(a)','FontSize',20)
text(0.1,0.27 * 0.9,'Non-abelian QSL','FontSize',20,'Interpreter','latex')
text(0.425,0.27 * 0.9,'Intermediate','FontSize',20,'Interpreter','latex')
text(0.7,0.27 * 0.9,'Paramagnet','FontSize',20,'Interpreter','latex')

xlim([0 xmax]);
ylim([-0.002 0.27]);
ylabel('$\mathcal{N}$', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'southeast','NumColumns',1);
yticks = 0:0.05:0.25;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
set(gca, 'XTick', []);

% -------------------------------
% 3. Subplot 2: N3 and N6 (Fork)
% -------------------------------

load('n3_fork_results.mat')
load('n6_fork_results.mat')

axes(hA(2));
hold on;

plot(dat_n3_fork(:,1), dat_n3_fork(:,2), '-o', 'DisplayName', '3 party', format{:},'Color',colors{2});
plot(dat_n6_fork(:,1), dat_n6_fork(:,2), ':d', 'DisplayName', '6 party', format{:},'Color',colors{2});

text(0.01,0.9 * 0.12,'(b)','FontSize',20)

xlim([0 xmax]);
ylim([-0.001 0.12]);
yticks = 0:0.02:0.10;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
ylabel('$\mathcal{N}$', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'west');
set(gca, 'XTick', []);
hold off

% -------------------------------
% 4. Subplot 3: N2 and N3_adj (Adjacent)
% -------------------------------

load('n3_adj_results.mat')
load('n2_results.mat')

hold off

axes(hA(3));
hold on;

plot(dat_n2(:,1), dat_n2(:,2), ':o', 'DisplayName', '2 party', format{:},'Color',colors{2},'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 7);
plot(dat_n3_adj(:,1), dat_n3_adj(:,2), '-d', 'DisplayName', '3 party', format{:},'Color',colors{2});

text(0.01,0.09,'(c)','FontSize',20)

% plot(x_zero, y_zero,'DisplayName','2 and 3 party, Chiral','Color',[colors{3} pt_alpha],'LineWidth',linesize,'LineStyle',linestyle_chiral, 'Marker','|', 'MarkerSize',10);

xlim([0 xmax]);
ylim([-0.001 0.1]);
yticks = 0:0.02:0.08;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
ylabel('$\mathcal{N}$', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'west');

% x ticks for the bottom plot
xlabel('$h \parallel$ [111]', 'FontSize', labelsize,'Interpreter','latex');
xticks = 0:0.1:xmax;
set(gca,'XTick',xticks)
set(gca,'XTickLabel',xticks)
hold off

% -------------------------------
% 6. Shaded Critical Regions
% -------------------------------
for ax = hA'
    axes(ax);
    a = gca;
    box(a,'on');
    % a.LineWidth = 1;
    hold on;
    xline(hc1, 'k--', 'LineWidth', 2,'HandleVisibility','off');
    xline(hc2, 'k--', 'LineWidth', 2,'HandleVisibility','off');
end

% -------------------------------
% 7. Save Figure
% -------------------------------
set(gcf, 'Units', 'inches');
screenposition = get(gcf, 'Position');
set(gcf, 'PaperPosition', [0 0 screenposition(3:4)], 'PaperSize', [screenposition(3:4)]);

print(gcf, 'Kitaev_hscan', '-dpdf');
