function M_default = getDefault(var,scaling,run,suffix,years,ensemble_numbers)
% Create a 4d matrix of GAUSS defalut data (lon, lat, time, ensemble member)

M_default = buildMatrix(var,scaling,'GAUSS-DEFAULT','203501-206912.nc',years,ensemble_numbers);


end