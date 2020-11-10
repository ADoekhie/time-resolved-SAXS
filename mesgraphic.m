% Title: Small Angle X-ray Scattering 3D plot Matlab code
% Author: github/adoekhie
% Description:	Matlab function to generate a smoothed 3D surface plot based on time-resolved SAXS data
% Graphic example: doi: 10.1038/s41598-020-65876-3
% Usage: create a cell data structure 'sample' containing the q vector as X and the intensity I(q) as Y, no header row!
% call the function by specifying X column and Y columns e.g. converting them into a matrix vector (cell2mat function)
% --> mesgraphic(cell2mat(sample(1:end,1)),cell2mat(sample(1:end,2:end)))

function mesgraphic(xData,yData) %load X and Y data

[a,b] = size(yData);	% size number of columns for Z-axis (seconds or in minutes)

z = 0; % create variable

minx = min(log10(xData)); % set automatic limits based on xData - xmin
maxx = max(log10(xData)); % set automatic limits based on xData - xmax

y2Data(1:a,1) = 0; % create empty matrix to store smoothed data

for i = 1:b % for each y-column/timepoint smooth the data
    xData(1:a,i) = xData(1:a,1);
    z(1:a,i) = i;
    y2Data(1:end,i) = smooth(yData(1:end,i));
end
xq = 0; % create empty surface matrix
yq = 0; % create empty surface matrix
vq = 0; % create empty surface matrix

[xq,yq] = meshgrid(min(real(log10(xData))):.1:max(real(log10(xData))),1:1:a); % create linear (from log) meshgrid based on smoothed data

P = real(log10(xData)); %convert log numbers to linear 

Q = real(log10(y2Data)); %convert log numbers to linear 

vq = griddata(P,z,Q,xq,yq,'natural'); % compute cartesian griddata using mesh

% Create figure
figure1 = figure('Color',[1 1 1],'rend','painters','pos',[10 10 500 500]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create surf
surfc(xq,yq,vq,'Parent',axes1,'EdgeAlpha',0.45);

% Create light - amend this to personal preferences
light('Parent',axes1,'Position',[47.94 8.23999999999998 -2],'Style','infinite');

% Create xlabel - or change to your settings
xlabel('Q _{log10} (Å^{-1})');
 
% Create ylabel - or change to your settings
ylabel('Time (seconds)');
 zlim(axes1,[-3.65 -.1]);  % play with these for specific values
  ylim(axes1,[1 b]);	% play with these for specific values
  xlim(axes1,[-2.5 -0]);	% play with these for specific values
  
% Create zlabel - or change to your settings
zlabel({'','I(q)_{log10}',''});

%set viewing angles 
view(axes1,[47.94 8.23999999999998]);
box(axes1,'on');
grid(axes1,'on');
axis(axes1,'square');

% Set the remaining axes properties - or change to your settings
set(axes1,'CLim',[-2.75 -.25],'Projection','perspective');
colormap jet % colormap only works with linear data which is why all data was converted to real integers