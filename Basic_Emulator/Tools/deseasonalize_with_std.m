function deseasonalized_data = deseasonalize_with_std(monthly_data, monthlies, monthly_std)
time_segments = length(monthlies);
deseasonalized_data = reshape((reshape(monthly_data,[time_segments length(monthly_data)/time_segments])-monthlies)./monthly_std,[length(monthly_data) 1]);
end
