function y_sai = fitSAI(params_co2, params_sai,years,co2_injection,sai_injection)
% diffus_wfirst2(beta,alpha,params,t);
beta = 1;
alpha = 1;
for k = 1:length(years)
    f_co2 = diffus_wfirst2(beta,alpha,params_co2,[years(1):years(k)]);
    f_sai = diffus_wfirst2(beta,alpha,params_sai,[years(1):years(k)]);
    for j = 1:k
        y_sai = co2_injection(j)*f_co2(k-j+1)+sai_injection(j)*f_sai(k-j+1);
    end
end

end