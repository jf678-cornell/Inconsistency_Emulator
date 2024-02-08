function [] = plotHovmoller(data,number_of_levels,l_colb,map_color,colorbounds,big_title,p)

latdata = mean(mean(data,1),4);
latdata = squeeze(latdata);
sizedata = size(latdata);
months = 1:sizedata(2);

[MONTHS,LAT] = meshgrid(months,p.lat);


fc = brewermap(l_colb,map_color);
% fc = brewermap(l_colb,'*RdBu');
fc = brighten(fc,-.5);
mmin=colorbounds(1);
mmax=colorbounds(end);
v = mmin:(mmax-mmin)/l_colb:mmax;
v2 = mmin:(mmax-mmin)/(l_colb/2):mmax;
colormap(fc)


figure
[C,h] = contourf(MONTHS,LAT,latdata,v,'LineColor','none');

end