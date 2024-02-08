function [mean_data,stdev] = averageAcrossEnsemble(data)

mean_data = mean(data,4);
stdev = std(data, 0, 4);

end