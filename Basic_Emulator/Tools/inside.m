function bounded = inside(data,bounds)
bounds0centered = bounds;
bounds0centered(bounds0centered>180) = bounds0centered(bounds0centered>180)-360;
if length(data) == 192
    % Latitude
    bounded = data>=bounds(1)&data<=bounds(end);

elseif length(data) == 288
    % Longitude
%     if bounds(1) <0
%         bounds(1) = bounds(1)+360;
%     end
%     if bounds(2) <0
%         bounds(2) = bounds(2)+360;
%     end
%     if bounds(1)> bounds(2)
%         temp_bound = bounds(1);
%         bounds(1) = bounds(2);
%         bounds(2) = temp_bound;
%     end
    if bounds(1) <0 && bounds(2) <0
        bounds = bounds + 360;
        bounded = data>=bounds(1)&data<=bounds(end);
    elseif bounds(1) <0 && bounds(2) >0
%         temp_bound = bounds(1);
%         bounds(1) = bounds(2);
%         bounds(2) = temp_bound;
        bounds(1) = bounds(1)+360;
        bounded = data>=bounds(1)|data<=bounds(2);

    elseif bounds(1) >0 && bounds(2) <0
    
    else
        bounded = data>=bounds(1)&data<=bounds(end);
    end

end
end