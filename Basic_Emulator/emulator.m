%% Emulator for Inconsistencies in SAI Deployment
%   Base form of emulator as appears in paper. To conserve file sizes, all
%       values that would be opimized in the base code are instead set to their 
%       final optimized values.

%   Code by Jared Farley. 
%       - Aerosol segment of emulator modified from Aubry et al (2020)
%       - Semi-infinite diffusion segmemt modified from Hansen et al (1984)
%           and MacMartin and Kravitz (2016).

%% Main
% Emulation is from 2035 to 2099.

% (1) Set your background CO2 forcing as a string
%   Available:
%       SSP2-4.5
%       SSP1-2.6
background_co2_forcing = "SSP2-4.5";


% (2) Generate your inconsistency.
%   Format is: Inconsistency_Name = createEasyInconsistentInj(base_injection,[year_start month_start year_end month_end],inconsistency_formula,color)
%   Available base injections (put as a string)
%       - default: SAI for 1.5, SSP2-4.5
%       - default_126: SAI for 1.5, SSP1-2.6
%       - default_slow: SAI for 1.5, SSP2-4.5, decadally updated
%       - delayed_2045: SAI for 1.5, SSP2-4.5, delayed 10 years
%       - lower_1: SAI for 0.5, SSP2-4.5
%       - lower_05: SAI for 1.0, SSP2-4.5 
%       - no_sai: No SAI injection
%   inconsistency_formula takes in (year,last_base_inj,curr_base_inj)
%       - year: the current year (e.g. 2035)
%       - last_base_inj: the injection amount for the last consistent year.
%             This one is useful for phase-outs.
%       - curr_base_inj: what the consistent deployment would have injected
%             in the current year
Sample_Inconsistency = createEasyInconsistentInj("default",[2055 0 2059 11],@(year,last_base_inj,curr_base_inj) 0.5*curr_base_inj, 'm');

% (3) Copy-paste your inconsistency variable name into the array active_injection_names
active_injection_names = ["no_sai","default","Sample_Inconsistency"];

% (4) Put 1 if you want to see the rate of temperature change, 0 if not.
plot_slopes = 1;

% (5) Run the code!

%% Sample Inconsistencies
Stochastic_Fantastic = createEasyInconsistentInj("default",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) (2*rand)*curr_base_inj,'#dd7b00');
Democracy = createEasyInconsistentInj("default",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) rem(floor(year/4),2)*curr_base_inj,'#dd7b00');
Interrupt_1y_in_2055 = createEasyInconsistentInj("default",[2055 0 2055 11],@(year,last_base_inj,curr_base_inj) 0,'#da9800');
Phase_Out_30y_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) max(1-floor(year-2054)/30,0)*last_base_inj,'#dd6c00');
Termination_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dd7b00');


%% Code
% Here be dragons. Comments are currently not great. Scroll back up to save yourself. 
addpath(genpath('Tools'))
addpath Tools/cbrewer/
tic
figure % Generate Figure
tiley = tiledlayout(1,1+plot_slopes); % Generate tile layout
% tiledlayout(1,1); % Generate tile layout
set(gcf, 'Position', [200, 200, 1200+300*plot_slopes,800]) % Set figure size
tiley.Padding = 'tight';
% Cycle through all the tiles
% for current_tile = [4 7 6 5]
% for current_tile = [5]
for current_tile = [1]

p = [];
p.var = 'TREFHT';
p.year_for_comp = [2055 2069];
p.ensemble_numbers = [1 2 3];
p.units = '°C';
% p.suffix = suffix;
p.years_of_ss = [2050 2069];
p.wraparound = 0;

% Longitude and latitude
% [lat,lon] = getLatLon('TREFHT',1,'GAUSS-DEFAULT','203501-206912.nc',[2055 2069],[1 2 3]);
load get_lat_and_lon.mat
if p.wraparound ==1
lon = [lon;360];
end
ww = cos(lat/180*pi);
p.ww = ww;
p.lat = lat;
p.lon = lon;
p.latbounds = [-inf inf];
p.lonbounds = [-inf inf];
p.latbounds = [-inf inf];
p.lonbounds = [-inf inf];
% end
%% Load in years
start_year = 2035; % The year of emulation start
end_year = 2069; % The year of simulation start
prelude = 5; % A small period of time to allow the dynamics of the emulator to stabilize
start_year_w_prelude = start_year-prelude; % Generate the first year to load in
all_years = start_year_w_prelude:end_year; % Generate a range of all years
PIT = 287.0052;

%% Load in CO2
% Load CO2 concentrations and put into usable arrays
load CO2_concentrations.mat

% Naming convention is year start _ year end _ scenario
CO2levels_2020_2100_ssp245 = CO2_SSP245(6:86);
CO2levels_2035_2070_ssp245 = CO2_SSP245(6+15:86-31);
CO2levels_2035_2100_ssp245 = CO2_SSP245(6+15:86);

CO2levels_2020_2100_ssp126 = CO2_SSP126(6:86);
CO2levels_2035_2070_ssp126 = CO2_SSP126(6+15:86-31);
CO2levels_2035_2100_ssp126 = CO2_SSP126(6+15:86);

% A constant CO2 of 2020 for 1000 years
CO2levels_2035_2100_constant = zeros(1000,1)+ CO2_SSP245(6);

% CO2 levels of 2055 held for 1000 years
CO2levels_2035_2100_held = [CO2levels_2035_2100_ssp245;zeros(1000,1)];
CO2levels_2035_2100_held(21:end) = CO2levels_2035_2100_held(20);

% Generate CO2 forcing using Myhre et al. (1998)
CO2_ref = CO2levels_2035_2070_ssp245(1);
CO2_forcing_SSP245 = 5.35*log((CO2levels_2035_2070_ssp245)/CO2_ref);

% Repeat the year's elements to put it in terms of month
CO2_forcing_SSP245_month = repeatElements(CO2_forcing_SSP245,12);
%% Load In Injections

% Load in Injections from Control Logs
% L_DEFAULT = readLog('GAUSS-DEFAULT',[1 2 3]); % SAI for 1.5°C
% L_DELAYED_2045 = readLog('GAUSS-DEFAULT-DELAYED.2045',[1]); % SAI for 1.5°C in 2045
% L_LOWER_1 = readLog('GAUSS-LOWER-1.0',[1 3]); % SAI for 0.5°C
% L_LOWER_1_2 = readLog('GAUSS-LOWER-1.0',[2]); % SAI for 0.5°C
% 
% L_LOWER_05 = readLog('GAUSS-LOWER-0.5',[1]); % SAI for 0.5°C
% L_LOWER_05_2 = readLog('GAUSS-LOWER-0.5',[2 3]); % SAI for 0.5°C

load all_inj_logs.mat;

L_CONSTANT = L_DEFAULT;
L_HELD = L_DEFAULT;


L_DEFAULT_slow = L_DEFAULT;
for i = ["S30" "S15" "N15", "N30"]
    for j = 1:3
        eval("L_DEFAULT_slow."+i+"(1:10,j) = repeatElements(mean(L_DEFAULT."+i+"(1:10,j),1),10);")
        eval("L_DEFAULT_slow."+i+"(11:20,j) = repeatElements(mean(L_DEFAULT."+i+"(11:20,j),1),10);")
        eval("L_DEFAULT_slow."+i+"(21:30,j) = repeatElements(mean(L_DEFAULT."+i+"(21:30,j),1),10);")
        eval("L_DEFAULT_slow."+i+"(31:end,j) = repeatElements(mean(L_DEFAULT."+i+"(31:end,j),1),6);")
        eval("L_CONSTANT."+i+"(1:end,j) = repeatElements(mean(L_DEFAULT."+i+"(1:end,j),1),36);")
        eval("L_HELD."+i+"(21:end,j) = repeatElements(mean(L_DEFAULT."+i+"(20,j),1),16);")

    end
end
% L_DEFAULT = L_DEFAULT_slow;
default_proportions = mean([mean(L_DEFAULT.S30,2) mean(L_DEFAULT.S15+L_DEFAULT.N15,2) mean(L_DEFAULT.N30,2)]./sum([L_DEFAULT.S30 L_DEFAULT.S15+L_DEFAULT.N15 L_DEFAULT.N30]/3,2),1);
% ssp126_scalars = 12*[0.0800  0.0800  0.0800  0.1300    0.0900    0.0900    0.0900    0.0900    0.1200 0.1200    0.1200    0.1300    0.1400    0.1400    0.1500    0.1500    0.1600    0.1600    0.1600    0.1700    0.1700    0.1700    0.1800 0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1800    0.1700 0.1700    0.1600    0.1600    0.1500    0.1500    0.1400    0.1400    0.1200    0.1200    0.1200    0.1000    0.1000    0.0900    0.0800 0.0700    0.0600    0.0500    0.0400    0.0300    0.0300    0.0000    0.0000    0.0000         0         0         0         0         0]';
ssp126_scalars = 12*[0.0800    0.0800    0.0800    0.1400    0.0800    0.0800    0.0900    0.1100    0.1100 0.1100    0.1200    0.1300    0.1300    0.1400    0.1400    0.1500    0.1500    0.1500    0.1600    0.1600    0.1600    0.1700    0.1700  0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1700    0.1600    0.1600 0.1600    0.1500    0.1500    0.1400    0.1400    0.1300    0.1300    0.1100    0.1100    0.1100    0.1000    0.0800    0.0800    0.0800 0.0600    0.0600    0.0400    0.0400    0.0300    0.0100    0.0100         0         0         0         0         0         0         0]';
L_DEFAULT_126 = [];
L_DEFAULT_126.S30 = default_proportions(1)*ssp126_scalars;
L_DEFAULT_126.S15 = default_proportions(2)*ssp126_scalars/2;
L_DEFAULT_126.N15 = default_proportions(2)*ssp126_scalars/2;
L_DEFAULT_126.N30 = default_proportions(3)*ssp126_scalars;
post2070_245 = 12*[1.0000    1.0100    1.0600    1.0600    1.1000    1.1100    1.1600    1.1600    1.1900    1.2100    1.2300    1.2500    1.2700 1.2900    1.3000    1.3300    1.3300    1.3400    1.3600    1.3700    1.3800    1.3800    1.3900    1.4100    1.4100    1.4100 1.4100    1.4300    1.4300    1.4400]';

post2070_245 = [post2070_245 post2070_245 post2070_245];
L_DEFAULT.S30 = [L_DEFAULT.S30;default_proportions(1)*post2070_245];
L_DEFAULT.S15 = [L_DEFAULT.S15;default_proportions(2)*post2070_245/2];
L_DEFAULT.N15 = [L_DEFAULT.N15;default_proportions(2)*post2070_245/2];
L_DEFAULT.N30 = [L_DEFAULT.N30;default_proportions(3)*post2070_245];


% Combine the lower temp because the runs are a little weird
L_LOWER_1.S30 = [L_LOWER_1.S30 L_LOWER_1_2.S30(1:end-1)];
L_LOWER_1.S15 = [L_LOWER_1.S15 L_LOWER_1_2.S15(1:end-1)];
L_LOWER_1.N15 = [L_LOWER_1.N15 L_LOWER_1_2.N15(1:end-1)];
L_LOWER_1.N30 = [L_LOWER_1.N30 L_LOWER_1_2.N30(1:end-1)];

L_LOWER_05.S30 = [L_LOWER_05.S30(1:end-1) L_LOWER_05_2.S30];
L_LOWER_05.S15 = [L_LOWER_05.S15(1:end-1) L_LOWER_05_2.S15];
L_LOWER_05.N15 = [L_LOWER_05.N15(1:end-1) L_LOWER_05_2.N15];
L_LOWER_05.N30 = [L_LOWER_05.N30(1:end-1) L_LOWER_05_2.N30];

AOD_base = 0.0115;
%% Make a Baseline and Subtract
T_base = 288.6302;
T_base_above_PIT = T_base-PIT;
PRECT_base = 2.9406;
PRECT_base_above_PI = PRECT_base;
param_final = [259.9547    2.0393/259.9547  -14.6159/259.9547];
%% Set/Optimize Sulfur Dymamics Parameters (TODO - Actually Optimize)

SO2_background = [0; 0; 0; 0; 0.048; 0; 0; 0; 0.0536; 0.1723; 0.3262]; % Gets SO2 pretty right with no mixing
SO4_background = 0*0.006*[1; 1; 1; 1; 1; 1; 1; 1];

t_prod = 1;
t_m = 10.7;
multiplier = 1.25;
t_13 = multiplier*2.3;
t_46 = multiplier*2.7;
t_78 = multiplier*3.8;
t_910 = .8;
t_5 = multiplier*14.5;
t_2 = multiplier*9.5;

MIXING = [-1/t_m 1/t_m 0 0 0 0 0 0 ;
          1/t_m -2/t_m 1/t_m 0 0 0 0 0 ;
          0 1/t_m -1/t_m 0 0 0 0 0 ;
          0 0 0 -1/t_m 1/t_m 0 0 0 ;
          0 0 0 1/t_m -4/t_m 1/t_m 1/t_m 1/t_m ;
          0 0 0 0 1/t_m -1/t_m 0 0 ;
          0 0 0 0 1/t_m 0 -1/t_m 0 ;
          0 0 0 0 1/t_m 0 0 -1/t_m ];

LOSS_dep = [-1/t_13 0 0 0 0 0 0 0 ;
             0 0 0 0 0 0 0 0 ;
             0 0 -1/t_13 0 0 0 0 0 ;
             1/t_13 0 0 -1/t_46 0 0 0 0 ;
             0 0 0 0 0 0 0 0 ;
             0 0 1/t_13 0 0 -1/t_46 0 0 ;
             0 0 0 1/t_46 0 0 -1/t_78 0 ;
             0 0 0 0 0 1/t_46 0 -1/t_78 ];

LOSS_side = [0 1/t_2 0 0 0 0 0 0 ;
             0 -2/t_2 0 0 0 0 0 0 ;
             0 1/t_2 0 0 0 0 0 0 ;
             0 0 0 0 1/t_5 0 0 0 ;
             0 0 0 0 -2/t_5 0 0 0 ;
             0 0 0 0 1/t_5 0 0 0 ;
             0 0 0 0 0 0 0 0 ;
             0 0 0 0 0 0 0 0 ];

LOSS = LOSS_side + LOSS_dep;

sulfur_dynamics_params = [];
sulfur_dynamics_params.t_prod = t_prod;
sulfur_dynamics_params.MIXING = MIXING;
sulfur_dynamics_params.LOSS = LOSS;
sulfur_dynamics_params.LOSS_dep = LOSS_dep;
sulfur_dynamics_params.LOSS_side = LOSS_side;
sulfur_dynamics_params.SO2_background = SO2_background;
sulfur_dynamics_params.SO4_background = SO4_background;
% end
%% Reference

% Functions
% On-Off every X: rem(floor(year/X),2)*curr_base_inj

%% Give Injection Commands (USER GO HERE)
ssp245_color = '#4A4A4A';
default_color = [0 0.4470 0.7410];
off_color = '#ff0000';
po_color = '#EDB120';
int1_color = '#b34700';
int2_color = '#ff7b24';
% start_year = 2035;
% end_year = 2069; % Figure out how to extend
% Possible (rn): ["SSP2-4.5","DEFAULT","Termination","Phase Out","1y Interruption","2y Interruption","Delayed 2045","LOWER-1.0"];
% runs_to_plot = ["SSP2-4.5","DEFAULT","Termination","Phase Out","1y Interruption","2y Interruption"];
runs_to_plot = [];
runs_to_plot_again = []; % For pretty plots
end_year = 2099;

potential_base_injections = ["no_sai","default","lower_1","delayed_2045"];

% Sample_Inconsistency = createEasyInconsistentInj("default",[2055 0 2059 11],@(year,last_base_inj,curr_base_inj) 0.5*curr_base_inj, 'm');
% Termination_in_2045 = createEasyInconsistentInj("default",[2045 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d6b300');
% Termination_in_2050 = createEasyInconsistentInj("default",[2050 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#da9800');
% Termination_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dd7b00');
% Termination_in_2055_to_SSP126 = createEasyInconsistentInj("default_126",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dd7b00');
% Termination_in_2070_to_SSP126 = createEasyInconsistentInj("default_126",[2070 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#db3000');
% Termination_in_2060 = createEasyInconsistentInj("default",[2060 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dd5b00');
% Termination_in_2065 = createEasyInconsistentInj("default",[2065 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#db3000');
% Termination_after_20_years = createEasyInconsistentInj("held",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d6b300');
% Termination_after_50_years = createEasyInconsistentInj("held",[2085 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d99f00');
% Termination_after_100_years = createEasyInconsistentInj("held",[2135 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dd7400');
% Termination_after_150_years = createEasyInconsistentInj("held",[2185 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dd7400');
% Termination_after_200_years = createEasyInconsistentInj("held",[2235 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d90000');
% Termination_after_250_years = createEasyInconsistentInj("held",[2285 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#dc3d00');
% Termination_after_300_years = createEasyInconsistentInj("held",[2335 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d90000');
% Termination_after_400_years = createEasyInconsistentInj("held",[2435 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d90000');
% Termination_after_500_years = createEasyInconsistentInj("held",[2535 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d90000');
% Interrupt_1m_in_2055 = createEasyInconsistentInj("default",[2055 0 2055 1],@(year,last_base_inj,curr_base_inj) 0,'#d6b300');
% Interrupt_1y_in_2055 = createEasyInconsistentInj("default",[2055 0 2055 11],@(year,last_base_inj,curr_base_inj) 0,'#da9800');
% Interrupt_2y_in_2055 = createEasyInconsistentInj("default",[2055 0 2056 11],@(year,last_base_inj,curr_base_inj) 0,'#dd7b00');
% Stochastic_Fantastic = createEasyInconsistentInj("default",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) (2*rand)*curr_base_inj,'#dd7b00');
% Democracy = createEasyInconsistentInj("default",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) rem(floor(year/4),2)*curr_base_inj,'#dd7b00');
% Interrupt_3y_in_2055 = createEasyInconsistentInj("default",[2055 0 2057 11],@(year,last_base_inj,curr_base_inj) 0,'#dd6c00');
% Interrupt_4y_in_2055 = createEasyInconsistentInj("default",[2055 0 2058 11],@(year,last_base_inj,curr_base_inj) 0,'#dc4800');
% Interrupt_5y_in_2055 = createEasyInconsistentInj("default",[2055 0 2059 11],@(year,last_base_inj,curr_base_inj) 0,'#d90000');
% Phase_Out_10y_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) max(1-floor(year-2054)/10,0)*last_base_inj,'#d6b300');
% Phase_Out_20y_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) max(1-floor(year-2054)/20,0)*last_base_inj,'#da9800');
% Phase_Out_30y_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) max(1-floor(year-2054)/30,0)*last_base_inj,'#dd6c00');
% Phase_Out_40y_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) max(1-floor(year-2054)/40,0)*last_base_inj,'#dd5b00');
% Phase_Out_50y_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) max(1-floor(year-2054)/50,0)*last_base_inj,'#db3000');
Volcano_1m_in_2055 = createEasyInconsistentInj("no_sai",[2055 0 2055 1],@(year,last_base_inj,curr_base_inj) 2.5,'#b34700');
default_frontload = createEasyInconsistentInj("default",[2035 0 inf 11],@(year,last_base_inj,curr_base_inj) curr_base_inj,'r');
default_slow = createEasyInconsistentInj("default",[2035 0 inf 11],@(year,last_base_inj,curr_base_inj) curr_base_inj,'#d6b300');



% if current_tile == 7
%     Termination_in_2055 = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#d6b300');
%     Interrupt_1y_in_2055 = createEasyInconsistentInj("default",[2055 0 2055 11],@(year,last_base_inj,curr_base_inj) 0,'#da9b00');
%     Interrupt_2y_in_2055 = createEasyInconsistentInj("default",[2055 0 2056 11],@(year,last_base_inj,curr_base_inj) 0,'#dc8100');
%     Termination_in_2055_instant = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) curr_base_inj,'#dd6500');
%     Interrupt_1y_in_2055_instant = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) curr_base_inj,'#dc4300');
%     Interrupt_2y_in_2055_instant = createEasyInconsistentInj("default",[2055 0 inf 11],@(year,last_base_inj,curr_base_inj) curr_base_inj,'#d90000');
% end
% active_injection_names = ["ssp245","DEFAULT","Termination_in_2055","Phase_Out_over_10y_in_2055","Interrupt_1y_in_2055","Interrupt_2y_in_2055"];




% Available: SSP2-4.5, SSP1-2.6
% Note: if other than SSP2-4.5 chosen, then base control will adapt to the
% new scenario (e.g. default will control to 1.5, not keep the injections
% from the model run.
% background_co2_forcing = "SSP2-4.5";
% background_co2_forcing = "constant";
% overwrite = 1;
extend_to_2099 = 0; % Will construct AOD needed to extend control to 2099
%% Reformat injection names
active_injection_names = strrep(active_injection_names," ","_");
active_injection_names_w_spaces = strrep(active_injection_names,"_"," ");
for i = 1:length(active_injection_names_w_spaces)
    if strcmp(active_injection_names_w_spaces(i),"ssp245")&&current_tile~=6
        active_injection_names_w_spaces(i) = "SSP2-4.5";
    elseif strcmp(active_injection_names_w_spaces(i),"DEFAULT")||strcmp(active_injection_names_w_spaces(i),"default")
        active_injection_names_w_spaces(i) = "SAI for 1.5°C";
    elseif strcmp(active_injection_names_w_spaces(i),"default 126")
        active_injection_names_w_spaces(i) = "SAI for 1.5°C";
    elseif strcmp(active_injection_names_w_spaces(i),"lower 1")
        active_injection_names_w_spaces(i) = "SAI for 0.5°C";
    elseif strcmp(active_injection_names_w_spaces(i),"lower 05")
        active_injection_names_w_spaces(i) = "SAI for 1.0°C";
    elseif strcmp(active_injection_names_w_spaces(i),"no sai")
        active_injection_names_w_spaces(i) = background_co2_forcing;
    elseif strcmp(active_injection_names_w_spaces(i),"default slow")
        active_injection_names_w_spaces(i) = "SAI for 1.5°C, decadally updated";
    elseif strcmp(active_injection_names_w_spaces(i),"delayed 2045")
        active_injection_names_w_spaces(i) = "SAI for 1.5°C, delayed to 2045";
    elseif strcmp(active_injection_names_w_spaces(i),"default frontload")
        active_injection_names_w_spaces(i) = "SAI for 1.5°C, all injection in Jan.";
    elseif strcmp(active_injection_names_w_spaces(i),"held")
        active_injection_names_w_spaces(i) = "100%";
    elseif strcmp(active_injection_names_w_spaces(i),"ssp245")&&current_tile==6
        active_injection_names_w_spaces(i) = "0%";
    end
end

active_injection_names_lower = lower(active_injection_names);
for i = 1:length(active_injection_names_lower)
    if strcmp(active_injection_names_lower(i),"default")
        active_injection_names(i) = "default";
    end
    if strcmp(active_injection_names_lower(i),"lower_1")
        active_injection_names(i) = "lower_1";
    end
    if strcmp(active_injection_names_lower(i),"delayed_2045")
        active_injection_names(i) = "delayed_2045";
    end
    if strcmp(active_injection_names_lower(i),"no_sai")
        active_injection_names(i) = "no_sai";
    end
end

background_co2_forcing = strrep(strrep(lower(background_co2_forcing),"-",""),".","");
CO2_forcing = eval("5.35*log((CO2levels_2035_2100_"+background_co2_forcing+")/CO2_ref)");
CO2_forcing_month = repeatElements(CO2_forcing,12);
% emulations_to_plot_again = [];
% emulations_to_plot_again = strrep(emulations_to_plot_again," ","_");
% emulations_to_plot_again_w_spaces = strrep(emulations_to_plot_again,"_"," ");
% emulations_to_plot_again_lower = lower(emulations_to_plot_again);
% for i = 1:length(emulations_to_plot_again_lower)
%     if strcmp(emulations_to_plot_again_lower(i),"default")
%         emulations_to_plot_again(i) = "default";
%     end
%     if strcmp(emulations_to_plot_again_lower(i),"lower_1")
%         emulations_to_plot_again(i) = "lower_1";
%     end
%     if strcmp(emulations_to_plot_again_lower(i),"delayed_2045")
%         emulations_to_plot_again(i) = "delayed_2045";
%     end
% end

ssp245 = createEasyInconsistentInj("ssp245",[2035 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#4A4A4A');
ssp126 = createEasyInconsistentInj("ssp126",[2035 0 inf 11],@(year,last_base_inj,curr_base_inj) 0,'#4A4A4A');
if strcmp(background_co2_forcing,'SSP1-2.6')
    no_sai = ssp126;
else
    no_sai = ssp245;
end
default = createEasyInconsistentInj("default",[2035 0 2099 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, [0 0.4470 0.7410]);
default_126 = createEasyInconsistentInj("default_126",[2035 0 2099 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, [0 0.4470 0.7410]);
lower_1 = createEasyInconsistentInj("lower_1",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, 'g');
lower_05 = createEasyInconsistentInj("lower_05",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, 'g');
delayed_2045 = createEasyInconsistentInj("delayed_2045",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, 'm');
constant = createEasyInconsistentInj("constant",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, 'm');
held = createEasyInconsistentInj("held",[2035 0 2069 11],@(year,last_base_inj,curr_base_inj) curr_base_inj, 'm');




%% Build Injections 
injection_default = [mean(L_DEFAULT.S30,2) mean(L_DEFAULT.S15,2) mean(L_DEFAULT.N15,2) mean(L_DEFAULT.N30,2)];
injection_default_126 = [mean(L_DEFAULT_126.S30,2) mean(L_DEFAULT_126.S15,2) mean(L_DEFAULT_126.N15,2) mean(L_DEFAULT_126.N30,2)];
injection_default_slow = [mean(L_DEFAULT_slow.S30,2) mean(L_DEFAULT_slow.S15,2) mean(L_DEFAULT_slow.N15,2) mean(L_DEFAULT_slow.N30,2)];
injection_delayed_2045 = [mean(L_DELAYED_2045.S30,2) mean(L_DELAYED_2045.S15,2) mean(L_DELAYED_2045.N15,2) mean(L_DELAYED_2045.N30,2)];
injection_lower_1 = [mean(L_LOWER_1.S30,2) mean(L_LOWER_1.S15,2) mean(L_LOWER_1.N15,2) mean(L_LOWER_1.N30,2)];
injection_lower_05 = [mean(L_LOWER_05.S30,2) mean(L_LOWER_05.S15,2) mean(L_LOWER_05.N15,2) mean(L_LOWER_05.N30,2)];
injection_off = [zeros(5,4);injection_default.*[ones(20,1);zeros(46,1)]]/12;
injection_constant = [mean(L_CONSTANT.S30,2) mean(L_CONSTANT.S15,2) mean(L_CONSTANT.N15,2) mean(L_CONSTANT.N30,2)];
injection_held = [mean(L_HELD.S30,2) mean(L_HELD.S15,2) mean(L_HELD.N15,2) mean(L_HELD.N30,2)];


if end_year >2069
    injection_default_with_prelude = [zeros(prelude+2035-start_year,4);injection_default;zeros(end_year-2069,4)];
    injection_default_126_with_prelude = [zeros(prelude+2035-start_year,4);injection_default_126;zeros(end_year-2069,4)];
    injection_delayed_2045_with_prelude = [zeros(prelude+2045-start_year,4);injection_delayed_2045;zeros(end_year-2069,4)];
    injection_lower_1_with_prelude = [zeros(prelude+2035-start_year,4);injection_lower_1;zeros(end_year-2069,4)];
    injection_lower_05_with_prelude = [zeros(prelude+2035-start_year,4);injection_lower_05;zeros(end_year-2069,4)];
    injection_off_with_prelude = [zeros(prelude+2035-start_year,4);injection_off;zeros(end_year-2069,4)];
    injection_default_slow_with_prelude = [zeros(prelude+2035-start_year,4);injection_default_slow;zeros(end_year-2069,4)];
    injection_constant_with_prelude = [zeros(prelude+2035-start_year,4);injection_constant;zeros(end_year-2069,4)+injection_constant(1,:)];
    injection_held_with_prelude = [zeros(prelude+2035-start_year,4);injection_held;zeros(end_year-2069,4)+injection_held(end,:)];

else
    injection_default_with_prelude = [zeros(prelude+2035-start_year,4);injection_default];
    injection_default_126_with_prelude = [zeros(prelude+2035-start_year,4);injection_default_126];
    injection_default_slow_with_prelude = [zeros(prelude+2035-start_year,4);injection_default_slow];
    injection_delayed_2045_with_prelude = [zeros(prelude+2045-start_year,4);injection_delayed_2045];
    injection_lower_1_with_prelude = [zeros(prelude+2035-start_year,4);injection_lower_1];
    injection_lower_05_with_prelude = [zeros(prelude+2035-start_year,4);injection_lower_05];
    injection_off_with_prelude = [zeros(prelude+2035-start_year,4);injection_off];
    injection_constant_with_prelude = [zeros(prelude+2035-start_year,4);injection_constant];
    injection_held_with_prelude = [zeros(prelude+2035-start_year,4);injection_held];

end
injection_default_monthly = zeros(length(injection_default_with_prelude(:,1))*12,4);
injection_default_126_monthly = zeros(length(injection_default_126_with_prelude(:,1))*12,4);
injection_default_slow_monthly = zeros(length(injection_default_slow_with_prelude(:,1))*12,4);
injection_lower_1_monthly = zeros(length(injection_lower_1_with_prelude(:,1))*12,4);
injection_lower_05_monthly = zeros(length(injection_lower_05_with_prelude(:,1))*12,4);
injection_delayed_2045_monthly = zeros(length(injection_delayed_2045_with_prelude(:,1))*12,4);
injection_off_monthly = zeros(length(injection_off_with_prelude(:,1))*12,4);
injection_constant_monthly = zeros(length(injection_constant_with_prelude(:,1))*12,4);
injection_held_monthly = zeros(length(injection_held_with_prelude(:,1))*12,4);

for i = 1:4
injection_default_monthly(:,i) = repeatElements(injection_default_with_prelude(:,i),12)/12;
injection_default_126_monthly(:,i) = repeatElements(injection_default_126_with_prelude(:,i),12)/12;
injection_default_slow_monthly(:,i) = repeatElements(injection_default_slow_with_prelude(:,i),12)/12;
injection_delayed_2045_monthly(:,i) = repeatElements(injection_delayed_2045_with_prelude(:,i),12)/12;
injection_lower_1_monthly(:,i) = repeatElements(injection_lower_1_with_prelude(:,i),12)/12;
injection_lower_05_monthly(:,i) = repeatElements(injection_lower_05_with_prelude(:,i),12)/12;
injection_off_monthly(:,i) = repeatElements(injection_off_with_prelude(:,i),12)/12;
injection_constant_monthly(:,i) = repeatElements(injection_constant_with_prelude(:,i),12)/12;
injection_held_monthly(:,i) = repeatElements(injection_held_with_prelude(:,i),12)/12;

end

injection_ssp245_monthly = injection_default_monthly*0;
injection_ssp126_monthly = injection_default_monthly*0;
injection_no_sai_monthly = injection_default_monthly*0;

for i = 1:length(active_injection_names)
    if ~strcmp(active_injection_names(i),"default") && ~strcmp(active_injection_names(i),"default_126") && ~strcmp(active_injection_names(i),"lower_1") && ~strcmp(active_injection_names(i),"lower_05") && ~strcmp(active_injection_names(i),"no_sai") && ~strcmp(active_injection_names(i),"delayed_2045") && ~strcmp(active_injection_names(i),"default_slow")
        inj_name = active_injection_names(i);
        eval("start_index = ("+inj_name+".inc_start_year - start_year)*12 + "+inj_name+".inc_start_month + 1;")
        eval("end_index = min(("+inj_name+".inc_end_year - start_year)*12 + "+inj_name+".inc_end_month + 1,(end_year - start_year+1)*12);")
        base_run = eval(inj_name+".base");
        injection_base_monthly = eval("injection_"+base_run+"_monthly");
        eval("injection_"+inj_name+"_monthly = injection_base_monthly;")
        injection_function = eval(inj_name+".formula");
        prelude_months = prelude*12;
        if start_index == 1
            last_con_index = 1;
        else
            last_con_index = start_index-1;
        end
        last_con_injection = injection_base_monthly(prelude_months+last_con_index,:);
        for j = 1:4
            for k = start_index:end_index
                eval("injection_"+inj_name+"_monthly(prelude_months+k,j) = injection_function(floor(k/12)+start_year,last_con_injection(j),injection_base_monthly(prelude_months+k,j));")
            end
        end
    end
end

injection_default_monthly_frontload = zeros(length(injection_default_with_prelude(:,1))*12,4);
for i = 1:length(injection_default_with_prelude(:,1))
    injection_default_monthly_frontload(1+(i-1)*12,:)= injection_default_with_prelude(i,:);
end

INJ_default = @(t) [injection_default_monthly(floor(t)+1,1) (injection_default_monthly(floor(t)+1,2)+ injection_default_monthly(floor(t)+1,3)) injection_default_monthly(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_default_126 = @(t) [injection_default_126_monthly(floor(t)+1,1) (injection_default_126_monthly(floor(t)+1,2)+ injection_default_126_monthly(floor(t)+1,3)) injection_default_126_monthly(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_default_slow = @(t) [injection_default_slow_monthly(floor(t)+1,1) (injection_default_slow_monthly(floor(t)+1,2)+ injection_default_slow_monthly(floor(t)+1,3)) injection_default_slow_monthly(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_default_frontload = @(t) [injection_default_monthly_frontload(floor(t)+1,1) (injection_default_monthly_frontload(floor(t)+1,2)+ injection_default_monthly_frontload(floor(t)+1,3)) injection_default_monthly_frontload(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_delayed_2045 = @(t) [injection_delayed_2045_monthly(floor(t)+1,1) (injection_delayed_2045_monthly(floor(t)+1,2)+ injection_delayed_2045_monthly(floor(t)+1,3)) injection_delayed_2045_monthly(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_lower_1 = @(t) [injection_lower_1_monthly(floor(t)+1,1) (injection_lower_1_monthly(floor(t)+1,2)+ injection_lower_1_monthly(floor(t)+1,3)) injection_lower_1_monthly(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_lower_05 = @(t) [injection_lower_05_monthly(floor(t)+1,1) (injection_lower_05_monthly(floor(t)+1,2)+ injection_lower_05_monthly(floor(t)+1,3)) injection_lower_05_monthly(floor(t)+1,4) 0 0 0 0 0 ]';
INJ_off = @(t) [injection_off_monthly(floor(t/12)+1,1) (injection_off_monthly(floor(t/12)+1,2)+ injection_off_monthly(floor(t/12)+1,3)) injection_off_monthly(floor(t/12)+1,4) 0 0 0 0 0 ]';

for i = 1:length(active_injection_names)
    
    if ~strcmp(active_injection_names(i),"default") && ~strcmp(active_injection_names(i),"default_126") && ~strcmp(active_injection_names(i),"lower_1") && ~strcmp(active_injection_names(i),"lower_05") && ~strcmp(active_injection_names(i),"delayed_2045") && ~strcmp(active_injection_names(i),"default_frontload") && ~strcmp(active_injection_names(i),"default_slow")
        inj_name = active_injection_names(i);
        eval("INJ_"+inj_name+" = @(t) max([injection_"+inj_name+"_monthly(floor(t)+1,1) (injection_"+inj_name+"_monthly(floor(t)+1,2)+ injection_"+inj_name+"_monthly(floor(t)+1,3)) injection_"+inj_name+"_monthly(floor(t)+1,4) 0 0 0 0 0 ]',0);")
    end
end

%% Emulate Injection -> SO4
for i = 1:length(active_injection_names)
    inj_name = active_injection_names(i);
    eval("[t_with_prelude,X_"+inj_name+"] = ode45(@(t,X)sulfur_dynamics(t,X,sulfur_dynamics_params,INJ_"+inj_name+"),[0:(end_year-start_year_w_prelude+1)*12-1],zeros(16,1));");
    eval("SO2_"+inj_name+" = X_"+inj_name+"(12*prelude+1:end,1:8);");
    eval("SO4_"+inj_name+" = X_"+inj_name+"(12*prelude+1:end,9:16);");
end
t = t_with_prelude(12*prelude+1:end);
%% Convert SO4 -> AOD
SO4_to_AOD_conversion = 0.0129;
efficiency_loss_frac = .8222;
x_star = 7;
SO4_Actual = 0*t;
for j = 1:length(active_injection_names)
    
    inj_name = active_injection_names(j);
    eval("AOD_emu_"+inj_name+" = SO4_to_AOD_conversion*sum(SO4_"+inj_name+"(:,1:end),2)+AOD_base;");
    for i = 1:length(t)
        eval("SO4_Actual(i) = sum(SO4_"+inj_name+"(i,1:end));")
        eval("if (sum(SO4_"+inj_name+"(i,1:end)) > x_star) " + "AOD_emu_"+inj_name+"(i) = SO4_to_AOD_conversion*(x_star^(1-efficiency_loss_frac))*(sum(SO4_"+inj_name+"(i,1:end),2)^(efficiency_loss_frac))+AOD_base;" + "end")
    end
     eval("AOD_emu_"+inj_name+"_above_base = AOD_emu_"+inj_name+" - AOD_base;");
end

%% Overwrite AOD if instant
% if current_tile == 7
%     for j = 1:length(active_injection_names)
%         inj_name = active_injection_names(j);
%         if strcmp(inj_name,"Termination_in_2055_instant")
%             eval("AOD_emu_"+inj_name+"_above_base(20*12+1:end) =  0;")
%         end
%         if strcmp(inj_name,"Interrupt_1y_in_2055_instant")
%             eval("AOD_emu_"+inj_name+"_above_base(20*12+1:21*12+1) =  0;")
%         end
%         if strcmp(inj_name,"Interrupt_2y_in_2055_instant")
%             eval("AOD_emu_"+inj_name+"_above_base(20*12+1:22*12+1) =  0;")
%         end
%     end
% end
%% Emulate AOD -> Temperature
emulation_time = annualToMonthly(start_year:end_year);
for i = 1:length(active_injection_names)
    inj_name = active_injection_names(i);
    eval(inj_name+"_emu_T = emulate_forcing_to_T(param_final,CO2_forcing_month,AOD_emu_"+inj_name+"_above_base,emulation_time)+T_base_above_PIT;");
end

instant_AOD = eval("AOD_emu_"+inj_name+"_above_base");
instant_AOD(emulation_time>=2055&emulation_time<=eval(inj_name+".inc_end_year + " + inj_name + ".inc_end_month/12"))=0;
%% Emulate AOD -> PRECT
param_final_PRECT = [1394, .2554/1394,  -1.8950/1394];  
emulation_time = annualToMonthly(start_year:end_year);
for i = 1:length(active_injection_names)
    inj_name = active_injection_names(i);
    eval(inj_name+"_emu_PRECT = emulate_forcing_to_T(param_final_PRECT,CO2_forcing_month,AOD_emu_"+inj_name+"_above_base,emulation_time)+PRECT_base_above_PI;");
end

%% Display Temperature Plots
% if current_tile ~=6
emulation_time = annualToMonthly(start_year:end_year);
simulation_line_width_T = 1;
simulation_line_style_T = '-';
emulation_line_width_T = 2;
emulation_line_style_T = '-';
my_tile = nexttile();
hold on
box on
for i = 1:length(runs_to_plot)
run2plot = runs_to_plot(i);
switch run2plot
    case "SSP2-4.5"
        plot(ssp245_T_data.months(ssp245_T_data.months<=emulation_time(end)),ssp245_T_data_deseasonalized(ssp245_T_data.months<=emulation_time(end))+T_base_above_PIT,simulation_line_style_T,'Color','#4A4A4A','LineWidth',simulation_line_width_T)
    case "DEFAULT"
        plot(default_T_data.months,default_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color',[0 0.4470 0.7410],'LineWidth',simulation_line_width_T)
    case "Termination"
        plot(off_T_data.months,off_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','r','LineWidth',simulation_line_width_T)
    case "LOWER-1.0"
        plot(lower_1_T_data.months,lower_1_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','g','LineWidth',simulation_line_width_T)
    case "DELAYED 2045"
        plot(delayed_2045_T_data.months,delayed_2045_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','m','LineWidth',simulation_line_width_T/2)
    case "Phase Out"
        plot(po_T_data.months,po_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#EDB120','LineWidth',simulation_line_width_T)
    case "1y Interruption"
        plot(restart_2_T_data.months,restart_2_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color',int1_color,'LineWidth',simulation_line_width_T)
    case "2y Interruption"
        plot(restart_2_T_data.months,restart_2_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#ff7b24','LineWidth',simulation_line_width_T)
end
end

for i = 1:length(active_injection_names)
    inj_name = active_injection_names(i);
    if strcmp(inj_name,"defaulty")
        plot(emulation_time(emulation_time<2070),eval(inj_name+"_emu_T(emulation_time<2070)"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
    else
        plot(emulation_time,eval(inj_name+"_emu_T"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
    end
end
amount  = 0.13;
brightened_default =[210 247 255]/255;
if current_tile == 5
    patchy = patch([(emulation_time') fliplr(emulation_time')], [(default_emu_T'+amount) flip(default_emu_T'-amount)], brightened_default);
    patchy.EdgeColor = 'none';
end
% 
% for i = 1:length(emulations_to_plot_again)
%     inj_name = emulations_to_plot_again(i);
%     if strcmp(inj_name,"defaulty")
%         plot(emulation_time(emulation_time<2070),eval(inj_name+"_emu_T(emulation_time<2070)"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
%     else
%         plot(emulation_time,eval(inj_name+"_emu_T"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
%     end
% end

for i = 1:length(runs_to_plot_again)
run2plot = runs_to_plot_again(i);
switch run2plot
    case "SSP2-4.5"
        plot(ssp245_T_data.months(ssp245_T_data.months<=emulation_time(end)),ssp245_T_data_deseasonalized(ssp245_T_data.months<=emulation_time(end))+T_base_above_PIT,simulation_line_style_T,'Color','#4A4A4A','LineWidth',simulation_line_width_T)
    case "DEFAULT"
        plot(default_T_data.months,default_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color',[0 0.4470 0.7410],'LineWidth',simulation_line_width_T)
    case "Termination"
        plot(off_T_data.months,off_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','r','LineWidth',simulation_line_width_T)
    case "LOWER 1.0"
        plot(lower_1_T_data.months,lower_1_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','g','LineWidth',simulation_line_width_T)
    case "DELAYED 2045"
        plot(delayed_2045_T_data.months,delayed_2045_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','c','LineWidth',simulation_line_width_T/2)
    case "Phase Out"
        plot(po_T_data.months,po_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#EDB120','LineWidth',simulation_line_width_T)
    case "2y Interruption"
        plot(restart_2_T_data.months,restart_2_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#ff7b24','LineWidth',simulation_line_width_T)
    otherwise
        plot(emulation_time,eval(run2plot+"_emu_T"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
end
end
spacer = [];
% if current_tile == 5
% for i = 1:length(runs_to_plot)
%     spacer = [spacer ""];
% end
% end
hold off
xlabel("Year","Fontsize",14)
ylabel("Temp. above PI, °C","FontSize",14)
legend([spacer active_injection_names_w_spaces],"Location","best","FontSize",12)
set(gca,'Linewidth',2)
set(gca,'FontSize', 16)

xlim([2035 end_year+1])


% my_tile.TitleHorizontalAlignment = 'left';
% 
% title(my_title,"FontSize",16)

% end
%% Display Temperature Plots in Percent
% if current_tile == 6
%     emulation_time = annualToMonthly(start_year:end_year);
% simulation_line_width_T = 1;
% simulation_line_style_T = '-';
% emulation_line_width_T = 2;
% emulation_line_style_T = '-';
% my_tile = nexttile();
% hold on
% box on
% 
% for i = 1:length(runs_to_plot)
% run2plot = runs_to_plot(i);
% switch run2plot
%     case "SSP2-4.5"
%         plot(ssp245_T_data.months(ssp245_T_data.months<=emulation_time(end)),ssp245_T_data_deseasonalized(ssp245_T_data.months<=emulation_time(end))+T_base_above_PIT,simulation_line_style_T,'Color','#4A4A4A','LineWidth',simulation_line_width_T)
%     case "DEFAULT"
%         plot(default_T_data.months,default_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color',[0 0.4470 0.7410],'LineWidth',simulation_line_width_T)
%     case "Termination"
%         plot(off_T_data.months,off_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','r','LineWidth',simulation_line_width_T)
%     case "LOWER-1.0"
%         plot(lower_1_T_data.months,lower_1_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','g','LineWidth',simulation_line_width_T)
%     case "DELAYED 2045"
%         plot(delayed_2045_T_data.months,delayed_2045_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','m','LineWidth',simulation_line_width_T/2)
%     case "Phase Out"
%         plot(po_T_data.months,po_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#EDB120','LineWidth',simulation_line_width_T)
%     case "1y Interruption"
%         plot(restart_2_T_data.months,restart_2_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color',int1_color,'LineWidth',simulation_line_width_T)
%     case "2y Interruption"
%         plot(restart_2_T_data.months,restart_2_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#ff7b24','LineWidth',simulation_line_width_T)
% end
% end
% 
% for i = 1:length(active_injection_names)
%     inj_name = active_injection_names(i);
%     inc_start_year = eval(inj_name+".inc_start_year");
%     index_to_hold = (inc_start_year-2035)*12+1;
%     if strcmp(inj_name,"ssp245")
%         run_to_plot_percent = eval(inj_name+"_emu_T")*0+1;
%     elseif strcmp(inj_name,"held")
%         run_to_plot_percent = eval(inj_name+"_emu_T")*0;
%     else
% 
%     run_to_plot = eval(inj_name+"_emu_T");
%     run_to_plot_percent = eval(inj_name+"_emu_T");
%     run_to_plot_percent(1:index_to_hold) = 1;
%     run_to_plot_percent(index_to_hold:end) = (ssp245_emu_T(index_to_hold:end) -run_to_plot(index_to_hold:end))/(ssp245_emu_T(index_to_hold) - run_to_plot(index_to_hold));
%     plot(emulation_time-inc_start_year,(1-run_to_plot_percent)*100,emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
%     eval(inj_name+"_decade_mark = (1-run_to_plot_percent(index_to_hold+120))*100")
%     end
%     % plot(emulation_time,eval(inj_name+"_emu_T"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
% 
% end
% % plot(emulation_time,no_lag_1y_interrupt_emu_T,'--','Color','m','LineWidth',2)
% 
% % for i = 1:length(emulations_to_plot_again)
% %     inj_name = emulations_to_plot_again(i);
% %     if strcmp(inj_name,"defaulty")
% %         plot(emulation_time(emulation_time<2070),eval(inj_name+"_emu_T(emulation_time<2070)"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
% %     else
% %         plot(emulation_time,eval(inj_name+"_emu_T"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
% %     end
% % end
% 
% for i = 1:length(runs_to_plot_again)
% run2plot = runs_to_plot_again(i);
% switch run2plot
%     case "SSP2-4.5"
%         plot(ssp245_T_data.months(ssp245_T_data.months<=emulation_time(end)),ssp245_T_data_deseasonalized(ssp245_T_data.months<=emulation_time(end))+T_base_above_PIT,simulation_line_style_T,'Color','#4A4A4A','LineWidth',simulation_line_width_T)
%     case "DEFAULT"
%         plot(default_T_data.months,default_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color',[0 0.4470 0.7410],'LineWidth',simulation_line_width_T)
%     case "Termination"
%         plot(off_T_data.months,off_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','r','LineWidth',simulation_line_width_T)
%     case "LOWER 1.0"
%         plot(lower_1_T_data.months,lower_1_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','g','LineWidth',simulation_line_width_T)
%     case "DELAYED 2045"
%         plot(delayed_2045_T_data.months,delayed_2045_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','m','LineWidth',simulation_line_width_T/2)
%     case "Phase Out"
%         plot(po_T_data.months,po_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#EDB120','LineWidth',simulation_line_width_T)
%     case "2y Interruption"
%         plot(restart_2_T_data.months,restart_2_T_data_deseasonalized+T_base_above_PIT,simulation_line_style_T,'Color','#ff7b24','LineWidth',simulation_line_width_T)
%     otherwise
%         plot(emulation_time,eval(run2plot+"_emu_T"),emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)
% end
% end
% 
% 
% hold off
% xlabel("Years after Termination","FontSize",14)
% ylabel("Percent of Cooling Lost","FontSize",14)
% % title("Emulated Temperature")
% legend(active_injection_names_w_spaces(3:end),"Location","northwest","FontSize",12)
% axis([0 20 0 100])
% set(gca,'Linewidth',2)
% set(gca,'FontSize', 16)
% 
% % title(my_title,"FontSize",16)
% t = title(my_title,"FontSize",16);
% % set(t, 'horizontalAlignment', 'right')
% % set(t, 'units', 'normalized')
% % h1 = get(t, 'position');
% % set(t, 'position', [1 h1(2) h1(3)])
% my_tile.TitleHorizontalAlignment = 'left';
% 
% end
%% Plot rates
if plot_slopes ==1
    nexttile
    hold on
    box on
    for i = 1:length(active_injection_names)
        inj_name = active_injection_names(i);
        plot(emulation_time(60:end-60)+.5,rollingSlopes(eval(inj_name+"_emu_T"),120)*12*10,emulation_line_style_T,'Color',eval(inj_name+".color"),'LineWidth',emulation_line_width_T)

    end
    hold off
xlabel("Year","Fontsize",14)
ylabel("Temp. Rate, °C/decade","FontSize",14)
xlim([2035 end_year+1])
legend(active_injection_names_w_spaces,"Location","best","FontSize",12)
set(gca,'Linewidth',2)
set(gca,'FontSize', 16)

end

end

set(gcf,'renderer','painters')
print(gcf,'-dpng',["Generated_Figures/Generated_Figure_" + getNow() + ".png"])

toc
%% Functions
function sample_inconsistent_inj = createEasyInconsistentInj(base_inj,time_array,inconsistency_formula,color)
sample_inconsistent_inj = [];
sample_inconsistent_inj.base = lower(base_inj);
sample_inconsistent_inj.inc_start_year = time_array(1); % The first year (inclusive) of the inconsistency
sample_inconsistent_inj.inc_start_month = time_array(2); % 0 through 11
sample_inconsistent_inj.inc_end_year = time_array(3); % The last year (inclusive) of the inconsistency
sample_inconsistent_inj.inc_end_month = time_array(4); % 0 through 11
sample_inconsistent_inj.formula = inconsistency_formula;
sample_inconsistent_inj.color = color;
end

function dX_dt = sulfur_dynamics(t,X,sulfur_dynamics_params,INJ)
t_prod = sulfur_dynamics_params.t_prod;
MIXING = sulfur_dynamics_params.MIXING;
SO2_background = sulfur_dynamics_params.SO2_background;
SO4_background = sulfur_dynamics_params.SO4_background;
SO2 = X(1:8);
SO4 = X(9:16);
dep_multiplier = 1;
if sum(SO4)>7
    dep_multiplier = (1-0.015*min(sum(SO4)-7,13))^-1;
end
LOSS = sulfur_dynamics_params.LOSS_side + dep_multiplier*sulfur_dynamics_params.LOSS_dep;
dSO2_dt = INJ(t) - SO2/t_prod;
SO4_PROD = SO2/t_prod + SO4_background;
dSO4_dt = (MIXING + LOSS)*SO4 + SO4_PROD;
dX_dt = [dSO2_dt;dSO4_dt];
end

function dX_dt = sulfur_dynamics_w_controls(t,X,sulfur_dynamics_params,INJ)
t_prod = sulfur_dynamics_params.t_prod;
MIXING = sulfur_dynamics_params.MIXING;
SO2_background = sulfur_dynamics_params.SO2_background;
SO4_background = sulfur_dynamics_params.SO4_background;
SO2 = X(1:8);
SO4 = X(9:16);
INJ = get_controls(sum(SO4(1:8),SO4_target));
dep_multiplier = 1;
if sum(SO4)>7
    dep_multiplier = (1-0.015*min(sum(SO4)-7,13))^-1;
end
LOSS = sulfur_dynamics_params.LOSS_side + dep_multiplier*sulfur_dynamics_params.LOSS_dep;
dSO2_dt = INJ(t) - SO2/t_prod;
SO4_PROD = SO2/t_prod + SO4_background;
dSO4_dt = (MIXING + LOSS)*SO4 + SO4_PROD;
dX_dt = [dSO2_dt;dSO4_dt];
end

% function AOD = calculate_AOD_from_S04(SO4_data)
% SO4_to_AOD_conversion = 0.0131;
% efficiency_loss_frac = .84;
% x_star = 7;
% 
% AOD = SO4_to_AOD_conversion*sum(SO4_data(:,1:end),2);
%     for i = 1:length(AOD)
%         if (sum(SO4_data(i,1:end)) > x_star) 
%             AOD(i) = SO4_to_AOD_conversion*(x_star^(1-efficiency_loss_frac))*(sum(SO4_data(i,1:end),2)^(efficiency_loss_frac));
%         end
%     end     
% end


%% References
% Aubry, T. J., Toohey, M., Marshall, L.,Schmidt, A., & Jellinek, A. M. (2020). 
%   A new volcanic stratospheric sulfate aerosol forcing emulator (EVA_H): 
%   Comparison with interactive stratospheric aerosol models. Journal of 
%   Geophysical Research:Atmospheres,125, e2019JD031303. 
%   https://doi.org/10.1029/2019JD031303

% Hansen, J. et al (1984). Climate sensitivity: Analysis of feedback 
%   mechanisms. in Geophysical Monograph Series (eds. Hansen, J. E. & 
%   Takahashi, T.) vol. 29 130–163 (American Geophysical Union, Washington, 
%   D. C.).

% MacMartin, D. G. and Kravitz, B. (2016). Dynamic climate emulators for 
% solar geoengineering, Atmos. Chem. Phys., 16, 15789–15799. 
% https://doi.org/10.5194/acp-16-15789-2016 
