function err = fitSAI_error(params_co2, params_sai,years,co2_injection,sai_injection,y_actual)

y_fit = fitSAI(params_co2, params_sai,years,co2_injection,sai_injection);

y_err = y_fit-y_actual;

err = sum(y_err.^2);

end