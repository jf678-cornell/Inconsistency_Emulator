function land = landAverage(data,p)
data_size = size(data);
AREA = getArea();
landfrac = getLandfrac();
if data_size(1) == 289
    AREA = [AREA;AREA(1,:)];
    landfrac = [landfrac;landfrac(1,:)];
end
AREA = regionalFilter(AREA,p);
landfrac = regionalFilter(landfrac,p);
data = regionalFilter(data,p);
land = squeeze(sum(sum(AREA.*landfrac.*data))/sum(sum(AREA.*landfrac)));

end