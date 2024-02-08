function [M] =  readFromSSP45(var,scaling,run,suffix,years,ensemble_number,p)
var = convertStringsToChars(var);
if isempty(ensemble_number)
    M = [];
elseif strcmp(var,'P-E')
    M = readFromSSP45("PRECT",scaling,run,suffix,years,ensemble_number) - readFromSSP45("QFLX",scaling/1000,run,suffix,years,ensemble_number);
elseif strcmp(var,'FSNT-FLNT')
    M = readFromSSP45("FSNT",scaling,run,suffix,years,ensemble_number) - readFromSSP45("FLNT",scaling,run,suffix,years,ensemble_number);
elseif strcmp(var,'SO4')
    M = readFromSSP45('TMso4_a1',scaling,run,suffix,years,ensemble_number) +readFromSSP45('TMso4_a2',scaling,run,suffix,years,ensemble_number)+readFromSSP45('TMso4_a3',scaling,run,suffix,years,ensemble_number);
elseif strcmp(var,'ALL_SULFUR')
    M = readFromSSP45('TMSO2',scaling,run,suffix,years,ensemble_number)+readFromSSP45('TMso4_a1',scaling,run,suffix,years,ensemble_number)*64.066/96.06*96.06/115 +readFromSSP45('TMso4_a2',scaling,run,suffix,years,ensemble_number)*64.066/96.06*96.06/115+readFromSSP45('TMso4_a3',scaling,run,suffix,years,ensemble_number)*64.066/96.06*96.06/115;
elseif strcmp(var,"PRECT")&&~all(ensemble_number ==1)
    M1 = readFromSSP45('PRECT',scaling,run,suffix,years,ensemble_number(ensemble_number==1));
    set = readFromSSP45('PRECL',scaling,run,suffix,years,ensemble_number(ensemble_number~=1))+readFromSSP45('PRECC',scaling,run,suffix,years,ensemble_number(ensemble_number~=1));
    M = cat(4,M1,set);
else

run_SSP = 'WACCM_MA_1deg';

first = years(1);
last = years(end);

M = [];

old_first = first;

if first == 1850
    M_1850 = [];

    if any(ensemble_number==1)
        comp_tseries_HIST = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.' var '.185001-189912.nc' ]],var)*scaling;
        comp_tseries_HIST2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.' var '.190001-194512.nc' ]],var)*scaling;
        comp_tseries_HIST3 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.' var '.194601-198512.nc' ]],var)*scaling;
        comp_tseries_HIST4 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.' var '.198601-201412.nc' ]],var)*scaling;
%         comp_tseries_HIST(:,:,(length(comp_tseries_HIST(1,1,:))+1):length(comp_tseries_HIST(1,1,:))+length(comp_tseries_HIST2(1,1,:))) = comp_tseries_HIST2;
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST2);
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST3);
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST4);
        M_1850 = cat(4,M_1850,comp_tseries_HIST);
    end
    if any(ensemble_number==2)
        comp_tseries_HIST = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.' var '.185001-189912.nc' ]],var)*scaling;
        comp_tseries_HIST2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.' var '.190001-194912.nc' ]],var)*scaling;
        comp_tseries_HIST3 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.' var '.195001-199912.nc' ]],var)*scaling;
        comp_tseries_HIST4 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.' var '.200001-201412.nc' ]],var)*scaling;
%         comp_tseries_HIST(:,:,(length(comp_tseries_HIST(1,1,:))+1):length(comp_tseries_HIST(1,1,:))+length(comp_tseries_HIST2(1,1,:))) = comp_tseries_HIST2;
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST2);
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST3);
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST4);
        M_1850 = cat(4,M_1850,comp_tseries_HIST);
    end
    if any(ensemble_number==3)
        comp_tseries_HIST = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.185001-189912.nc' ]],var)*scaling;
        comp_tseries_HIST2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.190001-194912.nc' ]],var)*scaling;
        comp_tseries_HIST3 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.195001-199912.nc' ]],var)*scaling;
        comp_tseries_HIST4 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.200001-201412.nc' ]],var)*scaling;
%         comp_tseries_HIST(:,:,(length(comp_tseries_HIST(1,1,:))+1):length(comp_tseries_HIST(1,1,:))+length(comp_tseries_HIST2(1,1,:))) = comp_tseries_HIST2;
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST2);
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST3);
        comp_tseries_HIST = cat(3,comp_tseries_HIST,comp_tseries_HIST4);
        M_1850 = cat(4,M_1850,comp_tseries_HIST);
    end
    first = 2015;
end

if any(ensemble_number==1)
comp_tseries_SSP = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.' var '.201501-206412.nc' ]],var)*scaling;
comp_tseries_SSP2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.' var '.206501-209912.nc' ]],var)*scaling;
comp_tseries_SSP(:,:,601:600+35*12) = comp_tseries_SSP2;
set = comp_tseries_SSP(:,:,((first-2015)*12+1):((last-2015)*12+12));
M = cat(4,M,set);
end
if any(ensemble_number==2)

comp_tseries_SSP = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.' var '.201501-206412.nc' ]],var)*scaling;
comp_tseries_SSP2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.' var '.206501-209812.nc' ]],var)*scaling;
comp_tseries_SSP(:,:,601:600+34*12) = comp_tseries_SSP2;
set = comp_tseries_SSP(:,:,((first-2015)*12+1):((last-2015)*12+12));
M = cat(4,M,set);

end
if any(ensemble_number==3)
comp_tseries_SSP1 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.201501-201912.nc' ]],var)*scaling;
comp_tseries_SSP2 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.202001-206912.nc' ]],var)*scaling;
comp_tseries_SSP3 = ncread(['Climate_Data/' run_SSP '/' [ 'b.e21.BWSSP245.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.' var '.207001-209912.nc' ]],var)*scaling;
comp_tseries_SSP1(:,:,61:660) = comp_tseries_SSP2;
comp_tseries_SSP1(:,:,661:660+30*12) = comp_tseries_SSP3;
set = comp_tseries_SSP1(:,:,((first-2015)*12+1):((last-2015)*12+12));
M = cat(4,M,set);

end
if old_first == 1850
    M = cat(3,M_1850,M);
end
end
end