function RMSE = calcRMSE(emulation,data)
min_length = min(length(data),length(emulation));
RMSE = sqrt(sum((emulation(1:min_length)-data(1:min_length)).^2)/min_length);

end
