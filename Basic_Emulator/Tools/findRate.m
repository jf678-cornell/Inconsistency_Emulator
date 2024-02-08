function slope_array = findRate(nyr,M,p)
eachside = (nyr-1)/2;
M_size = size(M);
slope_size = M_size;
slope_size(3) = slope_size(3) -2*eachside;

slope_array = zeros(slope_size);

% years_comp = 2055:2069;
yrvec = p.year_for_comp';


nlat = length(p.lat);
nlon = length(p.lon);

for i = 1:((length(M_size)==3) + (~(length(M_size)==3))*M_size(end))
for k = 1:slope_size(3)
    A=[ones(nyr,1) yrvec(k:k+2*eachside)];
    best_fit_array = reshape((A\reshape(M(:,:,k:k+2*eachside,i),nlat*nlon,nyr)')',nlon,nlat,2);
    slope_array(:,:,k,i)=best_fit_array(:,:,2);    
end
end


end