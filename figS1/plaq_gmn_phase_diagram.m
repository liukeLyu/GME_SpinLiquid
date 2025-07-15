
clear; clc;

fillalpha = 0.1;
fillcolor = [0 0.4470 0.7410];
xmax = 1.2;

% Figure setup
figure('Position', [0 0 800, 400]);
legendfontsize = 14;
ticksize = 12;
linesize = 2.5;
labelsize = 18;
pt_alpha = 0.4;

format = {'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 5};

% colors = get(gca,'colororder');
% colors = num2cell(colors,2); % cell array containing all the colors
colors = {'#C95C2E','#C95C6D','#A3644C','#3170B7'};
linestyle_chiral = '-';

% Load Data
selectErik = [1 2 3 4 5 9 13 14 15 16 18 19 20 21 22];
selectAndrea = 4:17;

load('n3_plaq_results.mat')
load('n3_plaq5_results.mat')
load('n3_plaq4_results.mat')
load('n3_adj_results.mat')

hold on 

plot(dat_n3_plaq(:,1), dat_n3_plaq(:,2), '-o', 'DisplayName', '6 spin', format{:},'Color',colors{4});
plot(dat_n3_plaq5(:,1), dat_n3_plaq5(:,2), '-o', 'DisplayName', '5 spin', format{:},'Color',colors{3});
plot(dat_n3_plaq4(:,1), dat_n3_plaq4(:,2), '-o', 'DisplayName', '4 spin', format{:},'Color',colors{2});
plot(dat_n3_adj(:,1), dat_n3_adj(:,2), '-o', 'DisplayName', '3 spin', format{:},'Color',colors{1});

text(0.100,0.24 * 0.9,'Non-abelian QSL','FontSize',20,'Interpreter','latex')
text(0.425,0.24 * 0.9,'Intermediate','FontSize',20,'Interpreter','latex')
text(0.700,0.24 * 0.9,'Paramagnet','FontSize',20,'Interpreter','latex')

legend('show', 'FontSize', legendfontsize, 'Location', 'southwest','NumColumns',1);

xlim([0,1])
ylim([-0.001,0.24])
xlabel('$h \parallel$ [111]', 'FontSize', labelsize,'Interpreter','latex');
ylabel('$\mathcal{N}$', 'FontSize', labelsize,'Interpreter','latex');
box on

% phase transition dashed lines
hc1 = 0.2223 * sqrt(3);
hc2 = 0.3695 * sqrt(3);
xline(hc1, 'k--', 'LineWidth', 1.7,'HandleVisibility','off');
xline(hc2, 'k--', 'LineWidth', 1.7,'HandleVisibility','off');

set(gcf, 'Units', 'inches');
screenposition = get(gcf, 'Position');
set(gcf, 'PaperPosition', [0 0 screenposition(3:4)], 'PaperSize', [screenposition(3:4)]);
print(gcf, 'hex-phase-diagram', '-dpdf');

function h_erik = h_pauli2Erik(h)
h_erik = h * sqrt(3) / 2;
end