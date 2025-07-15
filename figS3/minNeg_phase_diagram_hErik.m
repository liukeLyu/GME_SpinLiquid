% GMN_PhaseDiagram_Dynamic.m
% This script generates a phase diagram with 4 rows, dynamically skipping missing data.
% It handles separate h_values for Erik and Andrea.

clear; clc;

hc1 = 0.2223 * sqrt(3);
hc2 = 0.3695 * sqrt(3);
fillalpha = 0.1;
fillcolor = [0 0.4470 0.7410];
xmax = 1;

% Figure setup
figure('Position', [0 0 800, 400]);
legendfontsize = 14;
ticksize = 12;
linesize = 2.5;
labelsize = 18;
pt_alpha = 0.4;

hA = tight_subplot(2, 1, [0.002 .03], [0.08 0.02], [.1 .1]);
for i = 1:2
    hA(i).FontSize = ticksize;
end

format = {'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 5};

colors = get(gca,'colororder');
colors = num2cell(colors,2); % cell array containing all the colors
linestyle_chiral = '-';

xb = 0.4;

% -------------------------------
% 2. Subplot 1: N3 and N6 (Plaquette)
% -------------------------------

load('minNeg3_plaq_results.mat')
load('minNeg6_plaq_results.mat')


axes(hA(1));
hold on;

plot(dat_n3_plaq(:,1), dat_n3_plaq(:,2), '-o', 'DisplayName', '3 party', format{:},'Color',colors{1});
plot(dat_n6_plaq(:,1), dat_n6_plaq(:,2), ':d', 'DisplayName', '6 party', format{:},'Color',colors{1});

text(0.01,0.1 * 0.5,'(a)','FontSize',20)

xlim([0 xmax]);
ylim([-0.002 0.5]);
ylabel('$N^{min}$ Plaquette', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'northeast');
yticks = 0:0.1:0.5;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
set(gca, 'XTick', []);

% -------------------------------
% 3. Subplot 2: N3 and N6 (Fork)
% -------------------------------

load('minNeg3_fork_results.mat')
load('minNeg6_fork_results.mat')

axes(hA(2));
hold on;

plot(dat_n3_fork(:,1), dat_n3_fork(:,2), '-o', 'DisplayName', '3 party', format{:},'Color',colors{2});
plot(dat_n6_fork(:,1), dat_n6_fork(:,2), ':d', 'DisplayName', '6 party', format{:},'Color',colors{2});

text(0.01,0.1 * 0.2,'(b)','FontSize',20)

xlim([0 xmax]);
ylim([-0.001 0.2]);
yticks = 0:0.05:0.15;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
ylabel('$N^{min}$ Fork', 'FontSize', labelsize,'Interpreter','latex');
% legend('show', 'FontSize', legendfontsize, 'Location', 'west');


% x ticks for the bottom plot
xticks = 0:0.1:xmax;
set(gca,'XTick',xticks)
set(gca,'XTickLabel',xticks)

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

print(gcf, 'Kitaev_minNeg_hscan', '-dpdf');

function h_erik = h_pauli2Erik(h)
h_erik = h * sqrt(3) / 2;
end