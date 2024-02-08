function err = fitSAI_alone_error3(y_ssp, params_sai,years,sai_injection,y_actual)
err = 0;
for i = 1:3
y_fit = fitSAI_alone(y_ssp, params_sai,years,sai_injection(:,i));

y_err = y_fit-y_actual(:,i);

err = err + sum(y_err.^2);
end
end