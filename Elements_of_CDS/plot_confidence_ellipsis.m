function plot_confidence_ellipsis(C,mean)
%PLOT_CONFIDENCE_ELLIPSIS  plots confidence ellipsis.
%
%    PLOT_CONFIDENCE_ELLIPSIS(C,MEAN)   Given a 2 x 2 covariance matrix C
%    and vector MEAN of length 2 storing the mean values of the two
%    parameters, a single confidence ellipsis is plotted.

% Author: H. Martin Buecker, buecker@acm.org
% Date: 06/27/2017

% Check on input
if  nargin ~= 2
    error('The number of input arguments is wrong.');
end
if ~ismatrix(C)
    error('The variabel C is not stored as a matrix.');
end
if ~isvector(mean)
    error('The variabel mean is not stored as a vector.');
end
[m,n] = size(C);
if n ~= m
    error('The matrix C is not square.');
end
if any([n m] ~=2)
    error('The matrix C does not have two rows/columns.');
end
n = length(mean);
if n ~= 2
    error('The input vector mean does not have two entries.');
end


% V represents the directions of the semi axes
% S represents the lengths of the semi axes, up to a factor that depends on
% the confidence level

[V,D] = eig(C);
D = diag(D);% D is now a vector
% Sort eigenvalues/eigenvectors in decreasing order
[D,I] = sort(D,'descend');
V = V(:,I);
% Check on input
if any(D<0)
    error('The matrix C is not positive definite. So, it is not a covariance matrix.')
end
S = sqrt(diag(D));

%------- Set layout parameters
% Use the colormap linespecer if available
NrColors = 9;
if exist('linspecer','file')==2
    % Set your colormap to have easily distinguishable
    % colors and a pleasing aesthetic
    %colormap(linspecer);        
    % Force the colors to all be distinguishable (up to 12 colors)
    cmap = linspecer(NrColors,'qualitative'); 
    % Force the colors to vary along a spectrum
    %cmap = linspecer(NrColors,'sequential'); 
else
    cmap = colormap(hsv(NrColors));
    %cmap = colormap(parula(NrColors));
end
% The i-th color is now available as 
% color_i   = cmap(i,:);
ellipsis_color = cmap(2,:);
axis_color     = cmap(1,:);

lw = 1;% LineWidth

transparent_factor = 0.2;


%%confidence_scale = 1.52; % for confidence level 68.3%
confidence_scale = 2.48; % for confidence level 95.4%

phi = linspace(0,2*pi,181);

%------- Plot confidence ellipse
x = confidence_scale*V*S*[cos(phi); sin(phi)];
x = x + repmat(mean,1,length(phi));
shg,plot(x(1,:),x(2,:),'LineStyle','-','LineWidth',lw,'Color',ellipsis_color); 
hold on
fill(x(1,:),x(2,:),ellipsis_color,'FaceAlpha',transparent_factor);

axis equal;
title('Confidence level = 95.4%')
xlabel('$\theta_1$','Interpreter','Latex');
ylabel('$\theta_2$','Interpreter','Latex');

% ax = gca;
% ax.XAxisLocation = 'origin';
% ax.YAxisLocation = 'origin';

%------- Plot center
plot(mean(1),mean(2),'Marker','o',...
    'Color',axis_color,'MarkerFaceColor',axis_color,'MarkerEdgeColor',axis_color);
%xtext = mean + 1.1 * (x(:,1) - mean);
%text(xtext(1),xtext(2),legend_string(i,:));

%------- Plot semi-major axis
phi1 = [0, pi];
x = confidence_scale*V*S*[cos(phi1); sin(phi1)];
x = x + repmat(mean,1,2);
plot(x(1,:),x(2,:),'Color',axis_color,'LineWidth',lw); hold on

%------- Plot semi-minor axis
phi2 = [pi/2, 3*pi/2];
x = confidence_scale*V*S*[cos(phi2); sin(phi2)];
x = x + repmat(mean,1,2);
plot(x(1,:),x(2,:),'Color',axis_color,'LineWidth',lw);



