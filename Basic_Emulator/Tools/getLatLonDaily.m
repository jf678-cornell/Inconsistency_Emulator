function [lat,lon] = getLatLonDaily(var,scaling,run,suffix,years,ensemble_number)
var = 'SST';
if strcmp(var,'SST')
    module = '.pop.h.nday1.';
else 
    module = '.cam.h0.';
end
lat = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number(1)) module var '.' suffix]],'lat');
lon = ncread(['Climate_Data/' run '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.SSP245-MA-' run '.00' int2str(ensemble_number(1)) module var '.' suffix]],'lon');

end