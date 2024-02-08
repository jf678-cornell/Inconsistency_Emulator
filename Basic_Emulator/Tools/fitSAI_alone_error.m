function err = fitSAI_alone_error(y_ssp, params_sai,years,sai_injection,y_actual)

y_fit = fitSAI_alone(y_ssp, params_sai,years,sai_injection);

y_err = y_fit-y_actual;

err = sum(y_err.^2);

end