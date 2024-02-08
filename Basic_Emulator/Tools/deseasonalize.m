function deseasonalized_data = deseasonalize(monthly_data, monthlies)
time_segments = length(monthlies);
deseasonalized_data = reshape(reshape(monthly_data,[time_segments length(monthly_data)/time_segments])-monthlies,[length(monthly_data) 1]);
end
