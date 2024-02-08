function y_SSP = fitSSP(params_co2,years,co2_injection)
beta = 1;
alpha = 1;
% diffus_wfirst2(beta,alpha,params,t);
for k = 1:length(years)
    f_co2 = diffus_wfirst2(beta,alpha,params_co2,[years(1):years(k)]);
    for j = 1:k
        y_SSP = co2_injection(j)*f_co2(k-j+1);
    end
end

end