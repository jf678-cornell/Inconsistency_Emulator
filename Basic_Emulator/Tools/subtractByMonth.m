function newdata = subtractByMonth(data,baseline,dim)
data_size = size(data);
for i = 1:12
switch dim
    case 1
        data(i:12:data_size(1),:,:,:) = data(i:12:data_size(1),:,:,:)-baseline(i,:,:,:);
    case 2
        data(:,i:12:data_size(1),:,:) = data(:,i:12:data_size(1),:,:)-baseline(:,i,:,:);
    case 3
        data(:,:,i:12:data_size(1),:) = data(:,:,i:12:data_size(1),:)-baseline(:,:,i,:);
    case 4
        data(:,:,:,i:12:data_size(1)) = data(:,:,:,i:12:data_size(1))-baseline(:,:,:,i);
end
    
    
end

newdata = data;
end