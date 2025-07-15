
% Figure setup
% figure('Position', [0 0 800, 800]); % 4 panels
figure('Position', [0 0 800, 600]); % 3 panels
legendfontsize = 13;
ticksize = 12;
linesize = 2.5;
labelsize = 18;
pt_alpha = 0.4;

n_subplots = 3;

hA = tight_subplot(n_subplots, 1, [0.002 .03], [0.08 0.02], [.1 .1]);
for i = 1:n_subplots
    hA(i).FontSize = ticksize;
end

format = {'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 5};

colors = get(gca,'colororder');
colors = num2cell(colors,2); % cell array containing all the colors

% -------------------------------
% Subplot: N3 for Twin Peaks subregion
% -------------------------------
% 
% axes(hA(1));
% hold on;
% 
% % load('gmn_KagJ2_twinpeaks_N3.mat')
% % plot(J2List,gmnList, '-o', 'DisplayName', 'Twin Peaks 141', format{:},'Color',colors{1})
% 
% load('gmn_KagJ2_twinpeaks_p2_N3.mat')
% plot(J2List,gmnList, '-o', 'DisplayName', 'Twin-Peak', format{:},'Color',colors{1})
% 
% text(-0.14, 0.018 + (0.052 - 0.018) * 0.9,'(a)','FontSize',20)
% 
% xlim([min(J2List) max(J2List)]);
% % ylim([-0.0002 0.08]);
% ylim([0.018 0.052]);
% ylabel('$\mathcal{N}_3$', 'FontSize', labelsize,'Interpreter','latex');
% legend('show', 'FontSize', legendfontsize, 'Location', 'northeast');
% yticks = 0:0.01:0.06;
% set(gca,'YTick',yticks)
% set(gca,'YTickLabel',yticks)
% set(gca, 'XTick', []);

% -------------------------------
% Subplot: N3 for Bowtie and Plaquette
% -------------------------------

axes(hA(1));
hold on;

% [J2List,gmnList] = filter_positive(J2List,gmnList); % hList was named incorrectly

load('gmn_KagJ2_bowtie_N3.mat')
plot(J2List,gmnList, 'DisplayName', '5 spin Bowtie', 'LineWidth', linesize, 'Marker', '^', 'MarkerSize', 7,'Color',colors{1})

text(-0.145,0.055 * 0.9,'(a)','FontSize',20)
text(-0.009,0.055 * 0.77,'MMES','FontSize',16)
text(-0.12,0.055 * 0.7,'$\sqrt{3} \times \sqrt{3}$ order','FontSize',20,'Interpreter','latex')
text(+0.055,0.055 * 0.7,'$q=0$ order','FontSize',20,'Interpreter','latex')

load('gmn_KagJ2_plaq_N3.mat')
plot(J2List,gmnList, 'DisplayName', '6 spin Hexagon', 'LineWidth', linesize, 'Marker', 'o', 'MarkerSize', 7, 'Color',colors{1},'LineStyle','-.')

xlim([min(J2List) max(J2List)]);
ylim([-0.0002 0.055]);
ylabel('$\mathcal{N}_3$', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'southeast');
yticks = 0:0.01:0.06;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
set(gca, 'XTick', []);

% % -------------------------------
% % Subplot 3: N3 for 4 spin subregions
% % -------------------------------
% 
% axes(hA(3));
% hold on;
% 
% load('gmn_KagJ2_4spin_28_57_N3.mat')
% plot(J2List,gmnList, '-o', 'DisplayName', '4 spins (2)(8)(57)', format{:},'Color',colors{1})
% 
% load('gmn_KagJ2_4spin_27_58_N3.mat')
% plot(J2List,gmnList, '-o', 'DisplayName', '4 spins (2)(7)(58)', format{:},'Color',colors{2})
% 
% text(-0.14,0.028 * 0.9,'(c)','FontSize',20)
% 
% xlim([min(J2List) max(J2List)]);
% ylim([-0.0002 0.028]);
% ylabel('$\mathcal{N}_3$', 'FontSize', labelsize,'Interpreter','latex');
% legend('show', 'FontSize', legendfontsize, 'Location', 'southeast');
% % yticks = 0:0.01:0.06;
% set(gca,'YTick',yticks)
% set(gca,'YTickLabel',yticks)

% -------------------------------
% Subplot 3: N3 for linear subregion
% -------------------------------

axes(hA(2));
hold on;

load('gmn_KagJ2_angle_parallel_N3.mat')
plot(J2List,gmnList, 'DisplayName', '5 spin (partition A)', 'LineWidth', linesize, 'Marker', 'o', 'MarkerSize', 7,'Color',colors{2})

load('gmn_KagJ2_angle_cross_N3.mat')
plot(J2List,gmnList, 'DisplayName', '5 spin (partition B)', 'LineWidth', linesize, 'Marker', '^', 'MarkerSize', 7,'Color',colors{2})

text(-0.145,0.028 * 0.9,'(b)','FontSize',20)

xlim([min(J2List) max(J2List)]);
ylim([-0.0002 0.028]);
ylabel('$\mathcal{N}_3$', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'southeast');
% yticks = 0:0.01:0.06;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
set(gca, 'XTick', []);

% -------------------------------
% Subplot 3: N3 for 4 qubit subregions
% -------------------------------

axes(hA(3));

load('gmn_KagJ2_4spin_27_58_N3.mat')
plot(J2List,gmnList, 'DisplayName', '4 spin (partition A)', 'LineWidth', linesize, 'Marker', 'o', 'MarkerSize', 7,'Color',colors{1})
hold on;

load('gmn_KagJ2_4spin_28_57_N3.mat')
plot(J2List,gmnList, 'DisplayName', '4 spin (partition B)', 'LineWidth', linesize, 'Marker', '^', 'MarkerSize', 7,'Color',colors{1})

load('gmn_KagJ2_triangle_N3.mat')
plot(J2List,gmnList, 'DisplayName', '3 spin and 2 spin', 'LineWidth', linesize+0.5, 'Marker', 'none', 'MarkerSize', 7, 'LineStyle', '--', 'Color','Black')
% [colors{4},0.8]

text(-0.145,0.0327 * 0.9,'(c)','FontSize',20)

xlim([min(J2List) max(J2List)]);
ylim([-0.0002 0.0327]);
ylabel('$\mathcal{N}$', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'east');
yticks = 0:0.01:0.03;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)

% -------------------------------
% Set x ticks for the bottom graph
% -------------------------------
xlabel('$J_2$', 'FontSize', labelsize,'Interpreter','latex');
% x ticks for the bottom plot
xticks = -0.15:0.05:0.25;
xticklabels = cell(1,length(xticks));
for i=1:length(xticks)
    x = xticks(i);
    if abs(x) < 1e-10
        xticklabels{i} = 0;
    else
        xticklabels{i} = num2str(xticks(i));
    end
end
set(gca,'XTick',xticks,'XTickLabel',xticklabels)


% -------------------------------
% Subplot critical J2 values
% -------------------------------
% from http://dx.doi.org/10.1103/PhysRevLett.118.137202, DMRG
J2c1 = -0.03;
J2c2 = 0.045;
% From DOI: 10.1103/PhysRevB.104.144406, this uses variational method
% J2c1 = -0.065;
% J2c2 = 0.11;
% Set box

% loopy GME boundaries
% J2c1 = ((-0.05) + (-0.07))/2;
% J2c2 = 0;

for ax = hA'
    axes(ax);
    a = gca;
    box(a,'on');
    % a.LineWidth = 1;
    xline(J2c1, 'k--', 'LineWidth', 2,'HandleVisibility','off');
    xline(J2c2, 'k--', 'LineWidth', 2,'HandleVisibility','off');
    % x_points = [0.045-0.01, 0.045-0.01, 0.045+0.01, 0.045+0.01];  
    % y_points = [0, 10, 10, 0];
    % color = [0, 0, 1];
    % a = fill(x_points, y_points, color, 'HandleVisibility','off');
    % a.FaceAlpha = 0.1;
end

% -------------------------------
% Save Figure
% -------------------------------
set(gcf, 'Units', 'inches');
screenposition = get(gcf, 'Position');
set(gcf, 'PaperPosition', [0 0 screenposition(3:4)], 'PaperSize', [screenposition(3:4)]);

print(gcf, 'Kagome_J2scan', '-dpdf');