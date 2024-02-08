function regionalDifference = regionalDifference(data ,region1Lon,region1Lat, region2Lon,region2Lat,p)
ww = p.ww;
p.latbounds = region1Lat;
p.lonbounds = region1Lon;
% p.ww = ww(inside(p.lat,p.latbounds));
av1 = regionalMean(data,p);



p.latbounds = region2Lat;
p.lonbounds = region2Lon;
% p.ww = ww(inside(p.lat,p.latbounds));
av2 = regionalMean(data,p);
if ~isnan(av2(1))
regionalDifference = av1-av2;
else
    regionalDifference = av1;
end
end