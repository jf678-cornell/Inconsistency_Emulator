function M = buildMatrix(var,scaling,run,suffix,years,ensemble_numbers,p)
% Create a 4d matrix of GAUSS data (lon, lat, time, ensemble member)


M = [];
[~,lon] = getLatLon(var,scaling,run,suffix,years,ensemble_numbers(1));

for i = ensemble_numbers
tseries = readFromGAUSS(var,scaling,run,suffix,years,i);

%     if strcmp(var, 'Pa-E')
%         tseries = readAndSubtract('PRECT',1000*24*60*60,'QFLX',1,run,suffix,years,i);
%     else
%         tseries = readFromGAUSS(var,scaling,run,suffix,years,i);
%     end
if p.wraparound ==1
    tseries = [tseries; tseries(lon == 0,:,:)];
end
M = cat(4,M,tseries);
end



end