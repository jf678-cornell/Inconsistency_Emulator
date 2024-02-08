function slopes = rollingSlopes(dataset,slope_length)
data_length = length(dataset);
slopes = zeros(data_length-slope_length+1,1);

for i = 1:(data_length-slope_length+1)
    best_fit = polyfit(1:slope_length,dataset(i:(i+slope_length-1)),1);
    slopes(i) = best_fit(1);
end


end