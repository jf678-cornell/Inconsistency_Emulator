function [M] =  readFromSSP45Daily(var,scaling,run,suffix,years,ensemble_number,p)
var = convertStringsToChars(var);
if strcmp(var,'SST')
    module = '.pop.h.nday1.';
else 
    module = '.cam.h0.';
end

if isempty(ensemble_number)
    M = [];
elseif strcmp(var,'P-E')
    M = readFromSSP45Daily("PRECT",scaling,run,suffix,years,ensemble_number) - readFromSSP45Daily("QFLX",scaling/1000,run,suffix,years,ensemble_number);
elseif strcmp(var,'FSNT-FLNT')
    M = readFromSSP45Daily("FSNT",scaling,run,suffix,years,ensemble_number) - readFromSSP45Daily("FLNT",scaling,run,suffix,years,ensemble_number);
elseif strcmp(var,"PRECT")&&~all(ensemble_number ==1)
    M1 = readFromSSP45Daily('PRECT',scaling,run,suffix,years,ensemble_number(ensemble_number==1));
    set = readFromSSP45Daily('PRECL',scaling,run,suffix,years,ensemble_number(ensemble_number~=1))+readFromSSP45Daily('PRECC',scaling,run,suffix,years,ensemble_number(ensemble_number~=1));
    M = cat(4,M1,set);
else

run_SSP = 'WACCM_MA_1deg';

first = years(1);
last = years(end);

M = [];

if any(ensemble_number==1)
comp_tseries_SSP = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001' module var '.20150101-20650101.nc' ]],var)*scaling;
comp_tseries_SSP2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001' module var '.20650102-20991231.nc' ]],var)*scaling;
comp_tseries_SSP(:,:,601:600+35*365) = comp_tseries_SSP2;
set = comp_tseries_SSP(:,:,((first-2015)*365+1):((last-2015)*365+365));
M = cat(4,M,set);
end
if any(ensemble_number==2)

comp_tseries_SSP = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002' module var '.20150101-20650101.nc' ]],var)*scaling;
comp_tseries_SSP2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002' module var '.20650102-20981231.nc' ]],var)*scaling;
comp_tseries_SSP(:,:,601:600+34*365) = comp_tseries_SSP2;
set = comp_tseries_SSP(:,:,((first-2015)*365+1):((last-2015)*365+365));
M = cat(4,M,set);

end
if any(ensemble_number==3)
comp_tseries_SSP = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003' module var '.20200101-20650101.nc' ]],var)*scaling;
comp_tseries_SSP2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003' module var '.20650102-20991231.nc' ]],var)*scaling;
comp_tseries_SSP(:,:,(65*365+1):(65*365+1)+30*365) = comp_tseries_SSP2;
set = comp_tseries_SSP(:,:,((first-2020)*365+1):((last-2020)*365+365));
M = cat(4,M,set);

end

end
end