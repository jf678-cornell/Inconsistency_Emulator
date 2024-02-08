function filtered_data = regionalFilter(data,p)
lon = p.lon;
lat = p.lat;
lonbounds = p.lonbounds;
latbounds = p.latbounds;

filtered_data = data(inside(lon,lonbounds),inside(lat,latbounds),:,:);

end