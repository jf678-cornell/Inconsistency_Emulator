function arr = readAndAverageSinglePoint(lat,NS,ens,var,p)
M = readSinglePoint(lat,NS,ens,var);
arr_annual = averageEvery(12,1,M);
arr = globalMean(arr_annual,p);
end
