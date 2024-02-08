function [lat,lon] = getLatLon(var,scaling,run,suffix,years,ensemble_number)
var = 'TREFHT';
run = 'GAUSS-DEFAULT';
suffix = '203501-206912.nc';
ensemble_number = 1;
lat = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number(1)) '.cam.h0.' var '.' suffix]],'lat');
lon = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number(1)) '.cam.h0.' var '.' suffix]],'lon');

end