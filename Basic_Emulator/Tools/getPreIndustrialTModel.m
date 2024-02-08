function PIT = getPreIndustrialTModel()
%% Variables
% Variable to measure
clear
addpath(genpath('Climate_Data'))
addpath(genpath('Tools'))
var2measure = 2;
run2measure = 2;
year_for_comp = 2055:1:2069;
% year_for_comp = 2055:2056;

ensemble_numbers = 1;
years = [2055 2069];
% years = [2055 2056];

switch var2measure
    case 1
        var = 'PRECT'; scaling=1000*24*60*60;
        units = 'mm/day';
    case 2
        var = 'TREFHT'; scaling=1;
        units = '°C';
    case 3
        var = 'QFLX'; scaling=1000*24*60*60/1000;
        units = 'mm/day';
    case 4
        var = 'ICEFRAC'; scaling=1;
        units = '';
    case 5
        var = 'TS'; scaling=1;
        units = 'K';
    case 6
        var = 'AODVISstdn'; scaling=1;
        units = '';
    case 7
        var = 'TSMX'; scaling=1;
        units = 'K';
    case 8
        var = 'P-E'; scaling=1000*24*60*60;
        units = 'mm/day';
end

switch run2measure
    case 1
        run = 'GAUSS-DEFAULT';
        suffix = '203501-206912.nc';
%         year_for_comp = 2035:1:2069;
    case 2 
        run = 'GAUSS-DEFAULT-OFF-2055';
        suffix = '205501-206912.nc';
%         year_for_comp = 2055:1:2069;
    case 3 
        run = 'GAUSS-DEFAULT-PO-2055';
        suffix = '205501-206912.nc';
%         year_for_comp = 2055:1:2069;

    case 4
        run = 'GAUSS-DEFAULT-RESTART-2055-1y';
        suffix = '205601-206512.nc';
%         year_for_comp = 2056:1:2065;

    case 5
        run = 'GAUSS-DEFAULT-RESTART-2055-2y';
        suffix = '205701-206612.nc';
%         year_for_comp = 2057:1:2066;
end

year_mat=[];
for i = 1:12
    year_mat = [year_mat;year_for_comp];
end

number_of_levels = 6;
addpath Tools/cbrewer/
load coastlines
cbmap=flipud(cbrewer('div','RdBu',number_of_levels));

p = [];
p.var = var;
p.year_for_comp = year_for_comp;
p.ensemble_numbers = ensemble_numbers;
p.units = units;
p.run = run;
p.suffix = suffix;
p.years_of_ss = [2050 2069];
% p.years_of_ss = [2046 2065];

% Longitude and latitude
[lat,lon] = getLatLon(var,scaling,run,suffix,years,ensemble_numbers);
lon = [lon;360];
ww = cos(lat/180*pi);
p.ww = ww;
p.lat = lat;
p.lon = lon;
%% Get
T = readFromSSP45('TREFHT',1,'placeholder','placeholder',[2020 2039],[1]);
% T1 = ncread("Climate_Data\WACCM_MA_1deg\b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.001.cam.h0.TREFHT.185001-189912.nc",'TREFHT');
% T2 = ncread("Climate_Data\WACCM_MA_1deg\b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.002.cam.h0.TREFHT.185001-189912.nc",'TREFHT');
% T3 = ncread("Climate_Data\WACCM_MA_1deg\b.e21.BWmaHIST.f09_g17.release-cesm2.1.3.WACCM-MA-1deg.003.cam.h0.TREFHT.185001-189912.nc",'TREFHT');

% T = T1;
% T(:,:,:,2) = T2;
% T(:,:,:,3) = T2;

Tens = averageAcrossEnsemble(T);
Tens_time_average = mean(Tens,3);
PIT = globalMean(Tens_time_average,p)-1.5;
end