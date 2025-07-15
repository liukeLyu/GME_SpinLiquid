
% Combined Data

efac = sqrt(3) / 2; % convert from Pauli to Erik convention

l222dat = load('gmn222_thermal_plaq.mat');
l222 = [l222dat.hList * efac; l222dat.gmnList]';

l111111dat = load('gmn111111_thermal_plaq.mat');
l111111 = [l111111dat.hList * efac; l111111dat.gmnList]';

forkdat = load('gmn222_thermal_largeY.mat');
lfork222 = [forkdat.hList * efac; forkdat.gmnList]';

fork6dat = load('gmn111111_thermal_largeY.mat');
lfork111111 = [fork6dat.hList * efac; fork6dat.gmnList]';

adj111dat = load('gmn111_thermal.mat');
adj111 = [adj111dat.hList * efac; adj111dat.gmnList]';

adj11dat = load('gmn11_thermal.mat');
adj11 = [adj11dat.hList * efac; adj11dat.gmnList]';

EEhexdat = load('EE_thermal_plaq.mat');
EEhex = [EEhexdat.hList * efac; EEhexdat.EEList]';

l222_pert_dat = load('gmn222_chiral.mat');
l222Pert = [l222_pert_dat.hList * efac; l222_pert_dat.gmnList]';

l111111_pert_dat = load('gmn111111_chiral.mat');
l111111Pert = [l111111_pert_dat.hList * efac; l111111_pert_dat.gmnList]';

EE_pert_dat = load('EE.mat');
EEPert = [EE_pert_dat.hList * efac; EE_pert_dat.EEList]';

% Plots

hc1 = 0.2223 * sqrt(3);
hc2 = 0.3695 * sqrt(3);
fillalpha = 0.1;
fillcolor = [0 0.4470 0.7410];
xmax = 1;


% Figure setup
figure('Position', [0 0 800, 800]);
legendfontsize = 14;
ticksize = 12;
linesize = 2.5;
labelsize = 18;
pt_alpha = 0.4;

hA = tight_subplot(4, 1, [0.002 .03], [0.08 0.02], [.1 .1]);
for i = 1:4
    hA(i).FontSize = ticksize;
end

format = {'LineWidth', linesize, 'Marker', '|', 'MarkerSize', 5};

colors = get(gca,'colororder');
colors = num2cell(colors,2); % cell array containing all the colors

% -------------------------------
% Subplot 1: N3 and N6 (Plaquette)
% -------------------------------

axes(hA(1));
hold on;

plot(l222(:,1), l222(:,2), '-', 'DisplayName', '3 party', format{:},'Color',colors{1});
plot(l111111(:,1), l111111(:,2), ':', 'DisplayName', '6 party', format{:},'Color',colors{1});

hmax_chiral = 0.4 * efac;
l222Pert = l222Pert(l222Pert(:,1) < hmax_chiral,:);
plot(l222Pert(:,1),l222Pert(:,2),'LineWidth',linesize,'LineStyle','-','DisplayName', ...
    '3 party, Chiral','Color',[colors{1} pt_alpha],'HandleVisibility','off');

l111111Pert = l111111Pert(l111111Pert(:,1) < hmax_chiral, :);
plot(l111111Pert(:,1),l111111Pert(:,2),'LineWidth',linesize,'LineStyle',':','DisplayName', ...
    '6 party, Chiral','Color',[colors{1} pt_alpha],'HandleVisibility','off');

text(0.01,0.27 * 0.9,'(a)','FontSize',20)

xlim([0 xmax]);
ylim([-0.002 0.27]);
ylabel('$\mathcal{N}$ Plaquette', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'northeast','NumColumns',1);
yticks = 0:0.05:0.25;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
set(gca, 'XTick', []);

% -------------------------------
% Subplot 2: N3 and N6 (Fork)
% -------------------------------

axes(hA(2));
hold on;

plot(lfork222(:,1), lfork222(:,2), '-', 'DisplayName', '3 party', format{:},'Color',colors{2});
plot(lfork111111(:,1), lfork111111(:,2), ':', 'DisplayName', '6 party', format{:},'Color',colors{2});

% x_zero = 0:0.05:0.2*2;
% y_zero = -0 * ones(1,length(x_zero));
% plot(x_zero, y_zero,'DisplayName','3 and 6 party, Chiral','Color',[colors{3} pt_alpha],'LineWidth',linesize, 'Marker','|', 'MarkerSize',10,'HandleVisibility','off')

text(0.01,0.9*0.12,'(b)','FontSize',20)

xlim([0 xmax]);
ylim([-0.001 0.12]);
yticks = 0:0.02:0.10;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
ylabel('$\mathcal{N}$ Fork', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'southwest');
set(gca, 'XTick', []);

% -------------------------------
% Subplot 3: N2 and N3_adj (Adjacent)
% -------------------------------

axes(hA(3));
hold on;

plot(adj11(:,1), adj11(:,2), '-^', 'DisplayName', '2 party', 'LineWidth', linesize, 'MarkerSize', 4.5,'Color',colors{2});
plot(adj111(:,1), adj111(:,2), '-|', 'DisplayName', '3 party', format{:},'Color',colors{2});

text(0.01,0.09,'(c)','FontSize',20)

% plot(x_zero, y_zero,'DisplayName','2 and 3 party, Chiral','Color',[colors{3} pt_alpha],'LineWidth',linesize, 'Marker','|', 'MarkerSize',10,'HandleVisibility','off')

xlim([0 xmax]);
ylim([-0.001 0.1]);
yticks = 0:0.02:0.08;
set(gca,'YTick',yticks)
set(gca,'YTickLabel',yticks)
ylabel('$\mathcal{N}$ Adjacent', 'FontSize', labelsize,'Interpreter','latex');
legend('show', 'FontSize', legendfontsize, 'Location', 'southwest');
set(gca, 'XTick', []);

% -------------------------------
% 5. Subplot 4: Entanglement Entropy
% -------------------------------

axes(hA(4));
hold on;

plot(EEhex(:,1), EEhex(:,2), '-', 'DisplayName', 'Entropy', format{:},'Color',colors{1});

EEPert = EEPert(EEPert(:,1) < hmax_chiral,:);
plot(EEPert(:,1),EEPert(:,2),'LineWidth',linesize,'LineStyle','-','DisplayName','Entropy, Chiral','Color',[colors{1} pt_alpha],'HandleVisibility','off');

text(0.01,4.8*0.9,'(d)','FontSize',20)

xlim([0 xmax]);
ylim([0 4.8]);
xlabel('$h$', 'FontSize', labelsize,'Interpreter','latex');
ylabel('$S^{\mathrm vN}$', 'FontSize', labelsize,'Interpreter','latex');
set(gca,'YTickLabel',[0 1 2 3 4])

% x ticks for the bottom plot
xticks = 0:0.1:xmax;
set(gca,'XTick',xticks)
set(gca,'XTickLabel',xticks)

legend('show', 'FontSize', legendfontsize, 'Location', 'southwest');

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

print(gcf, 'Kitaev_Nauru_N24_hscan', '-dpdf');