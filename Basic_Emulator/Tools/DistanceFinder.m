function d = DistanceFinder(a,b)
d = [];
a = a/180*pi;
b = b/180*pi;
av_lat = (a(2)+b(2))/2;
lon_diff = b(1)-a(1);
lat_diff = b(2)-a(2);
dx = earthRadius*cos(av_lat)*lon_diff;
dy = earthRadius*lat_diff;
d.vect = [dx;dy];
d.dist = norm(d.vect);
d.angle = atan(dy/dx);
end
