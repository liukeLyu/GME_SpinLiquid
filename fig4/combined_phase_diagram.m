
diagramfolder = '../../2.12 Lattice Diagrams/pngs';

figure('Position',[0 0 500,300]);

cmap = colororder();

linesize = 3;
markersize = 10;
ticksize = 15;
labelfontsize=18;
legendfontsize = 16;
dashedcolor = 'default';
marker = 'none';

% GMN 222
load('gmn222_gscan.mat')
plot(gList, gmnList, 'LineWidth',linesize, 'Marker',marker,'MarkerSize', ...
    markersize,'DisplayName',"3 party",'Color',cmap(1,:))

% annotation('textbox', [.1 .7 .2 .15], 'string', 'Non-abelian Spin Liquid','FontSize',15)
% text(0.10,0.03,{'\textbf{Non-abelian}', '\textbf{Spin Liquid}'}, 'FontSize',15, 'Interpreter','latex')
% text(0.60,0.03,'\textbf{$Z_2$ Spin Liquid}', 'FontSize',15, 'Interpreter','latex')
text(0.10,0.03,'Non-abelian QSL', 'FontSize',15,'Interpreter','latex')
text(0.60,0.03,'$Z_2$ QSL', 'FontSize',15,'Interpreter','latex')

xline([0.5],'LineWidth',2,'LineStyle','--','Color',dashedcolor,'HandleVisibility','off');
ylabel('$\mathcal{N}$','FontSize',labelfontsize, 'Interpreter','latex')
ylim([0,0.28])
% legend('fontsize',legendfontsize)
xlabel('Anisotropy $\gamma$','FontSize',labelfontsize,'Interpreter','latex')
xticks(0:0.1:1)

% create a box around the transition point
dim = [.485 .485 .07 .06];
annotation('rectangle',dim,'Color','black')

% create an arrow pointing to the inset
X = [0.555 0.62];                         % First Point
Y = [0.52 0.56];                         % Second Point
hold on
arrow = annotation('arrow',X,Y,'LineWidth',1,'HeadWidth',8);

% create inset which shows second derivative
axes('Position',[.59 .58 .3 .3])
box on

% General plotting options extracted into opts
opts.LineWidth = 2;               % Line width for the plot lines
opts.FontSize = 10;               % Font size for labels and legend

% load('gmn222_gscan.mat')

span = 7;
gmnList = smooth(gList, gmnList, span);

[dgList, dgmnList] = dydx(gList,gmnList);

span = 10;
dgmnList = smooth(dgList, dgmnList, span);

[ddgList, ddgmnList] = dydx(dgList,dgmnList);

x = ddgList - 1/2;
y = ddgmnList;

x_threshold = 0.504 - 1/2;

x2 = x(x>x_threshold);
y2 = y(x>x_threshold);
logx = log(abs(x2));
logy = log(y2);

% Fix the data
lx_pts = [-3.5,-3.38 -2.46 -2];
mask_out = (logx > lx_pts(1) & logx < lx_pts(2)) | (logx > lx_pts(3) & logx < lx_pts(4));
mask_in = logx > lx_pts(2) & logx < lx_pts(3);

lxout = logx(mask_out);
lyout = logy(mask_out);

pout = polyfit(lxout,lyout,1);
f_pout = @(x) pout(1) * x + pout(2);

lxin = logx(mask_in);
lyin = logy(mask_in);

lyin = f_pout(lxin);

logx(mask_in) = lxin;
logy(mask_in) = lyin;
%

logy = smooth(logx, logy, 7);

% plot(ddgList,ddgmnList)

plot(logx,logy,'-','LineWidth',opts.LineWidth)

hold on

% plot(logxleft,logyleft)
% plot(logx,logy,'.')

% delta_g = 0.005;
% log(2*delta_g) = -4.6

fit_mask = logx > -4.5 & logx < -3.5;

lxfit = logx(fit_mask);
lyfit = logy(fit_mask);

p = polyfit(lxfit,lyfit,1);
fprintf('Exponent = %.5f\n',p(1));

fplot(@(gam) p(2)+ p(1)*gam,[-5.2,-1], '--' ,'LineWidth',opts.LineWidth,'Color','black')

formula = sprintf('%.2f $\log \vert \gamma - 1/2 \vert$ + %.2f',p(1),p(2));
% text(-3.5, 0.2, '$-0.70 \log \vert \gamma - 1/2 \vert - 2.36$ ', 'Interpreter', 'latex', 'FontSize', opts.FontSize, 'Color', 'black');

xlim([-4.5,-1])

xlabel('$\log \vert \gamma - 1/2 \vert $','Interpreter','latex','FontSize', opts.FontSize)
ylabel('$\log{d^2\mathcal{N}}/{d\gamma^2}$','Interpreter','latex','FontSize', opts.FontSize)

set(gca,'FontSize',10)

%
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);

print(gcf, 'Kitaev_gamscan', '-dpdf');
