function D = getAllDefaultData(var,scaling,run,suffix,years,ensemble_numbers,p)
% Create a 4d matrix of GAUSS defalut data (lon, lat, time, ensemble member)
D = [];
M_default = buildMatrix(var,scaling,'GAUSS-DEFAULT','203501-206912.nc',years,ensemble_numbers,p);
years_array = years(1):years(end);
D.raw_matrix = M_default;
[annual_average,stdev] = averageEvery(12,1,M_default);
D.annual_average = annual_average;
D.stdev = stdev;

[seasonal_average,seasonal_stdev] = seasonalAverage(1,M_default);
[seasonal_average(:,:,:,:,2),seasonal_stdev(:,:,:,:,2)] = seasonalAverage(2,M_default);
[seasonal_average(:,:,:,:,3),seasonal_stdev(:,:,:,:,3)] = seasonalAverage(3,M_default);
[seasonal_average(:,:,:,:,4),seasonal_stdev(:,:,:,:,4)] = seasonalAverage(4,M_default);
D.seasonal_average = seasonal_average;
D.seasonal_stdev = seasonal_stdev;

% five_year_rate = findRate(5,annual_average,p);
% D.five_year_rate = five_year_rate;
% three_year_rate = findRate(3,annual_average,p);
% D.three_year_rate = three_year_rate;

yearbounds = p.years_of_ss;
year1 = max(years_array(1),yearbounds(1));
year2 = min(yearbounds(end),years_array(end));

M_size = size(annual_average);
if length(M_size)==3
    M_size = [M_size,1];
end
M_in_a_row = [];
for i = 1:M_size(end)
    M_in_a_row(:,:,((i-1)*(year2-year1+1)+1):i*(year2-year1+1)) = annual_average(:,:,years_array>=year1 & years_array<=year2,i);
end
ss_mean = mean(M_in_a_row,3);
ss_month_mean = mean(averageByMonth(M_default,3),4);
ss_month_global_mean = globalMean(mean(averageByMonth(M_default,3),4),p);

ss_std = std(M_in_a_row,0,3);
ss_std_global = std(globalMean(M_in_a_row,p),0,1);
ss_se= std(M_in_a_row,0,3)/sqrt(12);

D.ss_mean = ss_mean;
D.ss_global_mean = globalMean(ss_mean,p);
D.ss_month_mean = ss_month_mean;
D.ss_month_global_mean = ss_month_global_mean;
D.ss_std = ss_std;
D.ss_std_global = ss_std_global;
D.ss_se = ss_se;

end