function av = stdByMonth(data,year_dim)
data_size = size(data);
new_data_size = size(data);
new_data_size(year_dim) = 12;
av = zeros(new_data_size);
for i = 1:12
    switch year_dim
        case 1
            av(i,:,:,:) = std(data(i:12:data_size(1),:,:,:),0,1);
        case 2
            av(:,i,:,:) = std(data(:,i:12:data_size(2),:,:),0,2);
        case 3
            av(:,:,i,:) = std(data(:,:,i:12:data_size(3),:),0,3);
        case 4
            av(:,:,:,i) = std(data(:,:,:,i:12:data_size(4)),0,4);
    end

end



end