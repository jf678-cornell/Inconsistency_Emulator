function [] = plotMapInTime2(M,fig_dim,number_of_levels,l_colb,map_color,colorbounds,big_title,p)
lat = p.lat;
lon = p.lon;
ww = p.ww;

addpath Tools/cbrewer/
load coastlines
cbmap=flipud(cbrewer('div','RdBu',number_of_levels));

M_size = size(M);
if length(M_size)==2
    M_size = [M_size,1]
end

figure
t = tiledlayout(fig_dim(1),fig_dim(2));
t.TileSpacing = 'compact';
t.Padding = 'compact';
for i = 1:M_size(end)

% subplot(fig_dim(1),fig_dim(end),i)
nexttile

% l_colb = 15;
fc = brewermap(l_colb,map_color);
% fc = brewermap(l_colb,'*RdBu');
fc = brighten(fc,-.5);
mmin=colorbounds(1);
mmax=colorbounds(end);
v = mmin:(mmax-mmin)/l_colb:mmax;
v2 = mmin:(mmax-mmin)/(l_colb/2):mmax;
colormap(fc)

worldmap('World');
box on
hold on
% levels = linspace(-3, 3, number_of_levels);
% [LAT,LON] = meshgrid(lat,lon);
% colormap(cbmap)
colormap(fc);
[C,h] = contourfm(lat,lon,M(:,:,i)',v,'LineColor','none');

% [maxT,maxI] = max(avgd_y_std(:,:,i),[],'all');
% [maxX,maxY]=find(avgd_y_std(:,:,i) == maxT);
T_average = (mean((sum(M(:,:,i)'.*ww)/sum(ww))'));

geoshow(coastlat,coastlon,'Color','k')
hold off 
% view(2)
title([ int2str(2054+i) + ", Avg: " + T_average + " " + p.units])
% title([run ', ' var ', Y' int2str(i) ', >= 2 StDv'])
% colormap(fc1)
% cdd = colorbar('FontSize',16,'YTick',(levels),'Linewidth',2,'Location','westoutside');
% clabel(C,h)
caxis([mmin mmax])
% set(gca,'Linewidth',2)
mlabel off; plabel off; gridm off
end
hl = colorbar('YTick',v2);
hl.Layout.Tile = 'east';
% sgtitle(big_title);
title(t,{big_title;""},'fontweight','bold');
end