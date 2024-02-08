function output_array = processSSP245(var,scaling,run_name,suffix,years,members,p)
output_array = [];
SSP_time = (years(1):years(end))';
SSP_M = readFromSSP45(var,scaling,run_name,suffix,years,members,p);
SSP_annual_average = averageEvery(12,1,SSP_M);
SSP_ensemble_monthly_average = averageAcrossEnsemble(SSP_M);
SSP_ensemble_annual_average = averageAcrossEnsemble(SSP_annual_average);
SSP_global_individual_annual_average = globalMean(SSP_annual_average,p);
SSP_global_individual_monthly_average = globalMean(SSP_M,p);
SSP_global_ensemble_annual_average = globalMean(SSP_ensemble_annual_average,p);
SSP_global_ensemble_monthly_average = globalMean(SSP_ensemble_monthly_average,p);
SSP_global_individual_annual_sum = globalSum(SSP_annual_average,p);
SSP_global_ensemble_annual_sum = globalSum(SSP_ensemble_annual_average,p);
SSP_global_ensemble_monthly_sum = globalSum(SSP_ensemble_monthly_average,p);
run_global_individual_monthly_sum = globalSum(SSP_M,p);


output_array.years = SSP_time;
output_array.months = annualToMonthly(SSP_time);
output_array.individual_monthly_matrix = SSP_M;
output_array.individual_annual_matrix = SSP_annual_average;
output_array.ensemble_monthly_matrix = SSP_ensemble_monthly_average;
output_array.ensemble_annual_matrix = SSP_ensemble_annual_average;
output_array.individual_annual_average = SSP_global_individual_annual_average;
output_array.individual_monthly_average = SSP_global_individual_monthly_average;
output_array.ensemble_annual_average = SSP_global_ensemble_annual_average;
output_array.ensemble_monthly_average = SSP_global_ensemble_monthly_average;
output_array.individual_annual_sum = SSP_global_individual_annual_sum;
output_array.ensemble_annual_sum = SSP_global_ensemble_annual_sum;
output_array.ensemble_monthly_sum = SSP_global_ensemble_monthly_sum;
output_array.individual_monthly_sum = run_global_individual_monthly_sum;

end