function [] = graphMap4Comparison(l_colb,colortype,mlimits,i,)

% l_colb = 15;
% fc = brewermap(l_colb,'*RdBu');
fc = brewermap(l_colb,colortype);
fc = brighten(fc,-.5);
% mmin=-3;
% mmax=3;
mmin= mlimits(1);
mmax= mlimits(end);
v = mmin:(mmax-mmin)/l_colb:mmax;

figure
subplot(2,2,1)

colormap(fc)
worldmap('World');
box on
hold on
colormap(fc);
[C,h] = contourfm(lat,lon,array_SSP',v,'LineColor','none');

geoshow(coastlat,coastlon,'Color','k')
hold off 
SSP_average = (mean((sum(array_SSP'.*ww)/sum(ww))'));
title(["SSP (Avg: "+(SSP_average)+" per Dec)"])
caxis([mmin mmax])
hl = colorbar('YTick',v);

subplot(2,2,2)

colormap(fc)

worldmap('World');
box on
hold on
colormap(fc);
[C,h] = contourfm(lat,lon,array_DEFAULT',v,'LineColor','none');
geoshow(coastlat,coastlon,'Color','k')
hold off 
DEFAULT_average = (mean((sum(array_DEFAULT'.*ww)/sum(ww))'));
title(["Default (Avg: "+(DEFAULT_average)+" per Dec)"])
caxis([mmin mmax])
hl = colorbar('YTick',v);

subplot(2,2,3)

colormap(fc)

worldmap('World');
box on
hold on
colormap(fc);
% [C,h] = contourfm(lat,lon,slope_array_OFF(:,:,i)',v,'LineColor','none');
geoshow(coastlat,coastlon,'Color','k')
hold off 
OFF_average = (mean((sum(array_OFF'.*ww)/sum(ww))'));
title(["Termination (Avg: "+(OFF_average)+")"])
caxis([mmin mmax])
hl = colorbar('YTick',v);

subplot(2,2,4)


colormap(fc)

worldmap('World');
box on
hold on
colormap(fc);
[C,h] = contourfm(lat,lon,array_PO',v,'LineColor','none');
geoshow(coastlat,coastlon,'Color','k')
hold off 
PO_average = (mean((sum(array_PO'.*ww)/sum(ww))'));
title(["Phase Out (Avg: "+(PO_average)+")"])

caxis([mmin mmax])
hl = colorbar('YTick',v);

sgtitle(['Normalized Slopes for ' var ', Year ' int2str(2054+i)])
end