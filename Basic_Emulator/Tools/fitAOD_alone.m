function y_sai = fitAOD_alone(y_ssp, params_sai,years,sai_injection)
% diffus_wfirst2(beta,alpha,params,t);
y_sai = 0*y_ssp;
alpha = params_sai(1);
beta = params_sai(2);
for k = 1:length(years)
%     f_co2 = diffus_wfirst2(beta,alpha,params_co2,[years(1):years(k)]);
    f_sai = diffus_wfirst_AOD(beta,alpha,[years(1):years(k)]);
    for j = 1:k
        y_sai(k) = y_sai(k)+ sai_injection(j)*f_sai(k-j+1);
    end
end
y_sai = y_sai+y_ssp;
end