function arr = readAndAverageSinglePointLat(lat,NS,ens,var,p)
M = readSinglePoint(lat,NS,ens,var);
arr_annual = averageEvery(12,1,M);
arr = squeeze(mean(arr_annual,1));
end