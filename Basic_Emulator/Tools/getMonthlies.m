function monthlies = getMonthlies(data_with_ss, ss_year_start, ss_year_end)
data_to_fit = data_with_ss.ensemble_monthly_average(data_with_ss.months>=ss_year_start&data_with_ss.months<(ss_year_end+1));
time_to_fit = data_with_ss.months(data_with_ss.months>=ss_year_start&data_with_ss.months<(ss_year_end+1));
pfit = polyfit(time_to_fit,data_to_fit,1);
best_fit_line = pfit(1)*time_to_fit + pfit(2);
deviation = data_to_fit-best_fit_line;
deviation_by_month = reshape(deviation,[12 length(deviation)/12]);

steady_state_months = reshape(data_with_ss.ensemble_monthly_average(data_with_ss.months>=ss_year_start&data_with_ss.months<(ss_year_end+1)),[12 length(data_with_ss.ensemble_monthly_average(data_with_ss.months>=ss_year_start&data_with_ss.months<(ss_year_end+1)))/12]);
monthlies = mean(steady_state_months,2)-mean(data_with_ss.ensemble_monthly_average);
end