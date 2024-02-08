function [newdata_s,stdev_s] = seasonalAverage(season,data)
if season == 4
    season =0;
end
start_index = 1;
sampling_length = 3;
data_size = size(data);
timetotal = data_size(3);
newset = start_index:sampling_length:timetotal;
newdata_size = data_size;
if newset(end)+sampling_length-1>data_size
    newset = newset(1:end-1);
end


newdata_size(3) = length(newset);



newdata = zeros(newdata_size);
stdev = zeros(newdata_size);

for i = 1:length(newset)
    newdata(:,:,i,:) = mean(data(:,:,newset(i):(newset(i)-1+sampling_length),:),3);
    stdev(:,:,i,:) = std(data(:,:,newset(i):(newset(i)-1+sampling_length),:),0,3);
end

seasonal_size = newdata_size;
seasonal_size(3) = seasonal_size(3)/4;

newdata_s = zeros(seasonal_size);
stdev_s = zeros(seasonal_size);

j = 1;
for i = 1:length(newset)
    if mod(i,4) == season
        newdata_s(:,:,j,:) = newdata(:,:,i,:);
        stdev_s(:,:,j,:) = stdev(:,:,i,:);
        j = j+1;
    end
    
end



end