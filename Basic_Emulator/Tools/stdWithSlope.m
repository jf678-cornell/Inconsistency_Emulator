%% Calculate standard deviation about some best fit curve/mean
% Jared Farley 
% Feb. 6, 2024

function standard_deviation = stdWithSlope(time, data, degree)

% Technically unnessisary, but handle ensembles differently than individual
% members
size_of_data = size(data);
if size_of_data(2) == 1 % if one member, or mean
    polydata = polyfit(time,data,degree); % Least-squares best fit
    our_mean = 0*data; % Initialize array

    % Build our curve / line / mean of best fit
    for i = 0:degree
        our_mean = our_mean + polydata(degree-i+1)*time.^i;
    end

    % Calculate standard deviation. One could put autocorrelation here if
    % one wanted
    standard_deviation = sqrt(sum((data - our_mean).^2)./(length(data)-degree-1));
else 
    % if multi-member
    polydata = polyfit(time,mean(data,2),degree); % Least-squares best fit
    our_mean = 0*data(:,1); % Initialize array

    % Build our curve / line / mean of best fit
    for i = 0:degree
        our_mean = our_mean + polydata(degree-i+1)*time.^i;
    end

    % Compare all of our datapoints against the best fit - this would be
    % easy if the mean but lines/curves require this
    sum_inside_sqrt = 0;
    for i = 1:size_of_data(2)
        sum_inside_sqrt = sum_inside_sqrt + sum((data(:,i) - our_mean).^2)./((size_of_data(1)*size_of_data(2))-degree-1);
    end

    % Calculate standard deviation. One could put autocorrelation here if
    % one wanted
    standard_deviation = sqrt(sum_inside_sqrt);
end

end