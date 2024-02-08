%% Middle
% Jared Farley
% Description: Returns the linearly-interpolated midpoints of the data.
% Useful for going alongside diff(). One shorter in length than data.
function mid_array = middle(array)

mid_array = (array(1:end-1)+array(2:end))/2;
end