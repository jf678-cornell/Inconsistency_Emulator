function output_array = repeatElements(input_array, N)

matrix_for_reshaping = ones(N,length(input_array)).*input_array';

output_array = squeeze(reshape(matrix_for_reshaping,N*length(input_array),1));



end