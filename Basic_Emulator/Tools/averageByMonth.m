function av = averageByMonth(data,year_dim)
data_size = size(data);
new_data_size = size(data);
new_data_size(year_dim) = 12;
av = zeros(new_data_size);
for i = 1:12
    switch year_dim
        case 1
            av(i,:,:,:) = mean(data(i:12:data_size(1),:,:,:),1);
        case 2
            av(:,i,:,:) = mean(data(:,i:12:data_size(2),:,:),2);
        case 3
            av(:,:,i,:) = mean(data(:,:,i:12:data_size(3),:),3);
        case 4
            av(:,:,:,i) = mean(data(:,:,:,i:12:data_size(4)),4);
    end

end



end