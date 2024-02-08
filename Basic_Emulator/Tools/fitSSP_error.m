function err = fitSSP_error(params_co2,years,co2_injection,y_actual)

y_fit = fitSSP(params_co2,years,co2_injection);

y_err = y_fit-y_actual;

err = sum(y_err.^2);



end
