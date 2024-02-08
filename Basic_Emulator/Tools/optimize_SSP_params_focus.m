function diffs = optimize_SSP_params_focus(arr,SSP_global_ensemble_annual_average_above_2035,f,focus_range)
diffs = 0;

for k = 1:length(SSP_global_ensemble_annual_average_above_2035)
    SUM_hf = 0;
    impulse_p = [];
    impulse_p.tau = arr(1);
    impulse_p.mu = arr(2);
    for j = 1:k
        SUM_hf = SUM_hf + impulse_semiInfDiff(j,impulse_p)*f(k-j+1);
    end

%     z(k) = SUM_hf;
    if k>= focus_range(1)&&k<=focus_range(end)
        diffs = diffs+(SSP_global_ensemble_annual_average_above_2035(k)-SUM_hf)^2;
    end
    if isnan(diffs)
        a = 1;
    end
end
diffs = sqrt(diffs/length(SSP_global_ensemble_annual_average_above_2035(focus_range)));
%     difference_between = SSP_global_ensemble_annual_average_above_2035-z;

end