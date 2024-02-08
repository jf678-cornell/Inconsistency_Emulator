%% Optimize Parameters, Forcing (GHG concentrations, AOD) to Global Mean Temperature
% Jared Farley 
% Feb. 6, 2024

function RMSE = optimize_params_forcing_to_T(params,T_to_fit,CO2_forcing,SAI_forcing)
% params: the parameters of the emulator, [timescale eq_CO2_response eq_SAI_response]
% T_to_fit: Simulation data we want to emulate well
% CO2_forcing: The forcing from CO2, read from SSP data
% SAI_forcing: The forcing from AOD, read from Simulation data
% RMSE: The root mean square error between the simulation and the emulation

% diffs will sum up the squares of the difference between the emulation and
% the data
diffs = 0;

% Load in parameters for GHG
impulse_p_CO2 = [];
impulse_p_CO2.tau = params(1);
impulse_p_CO2.mu = params(2);

% Load in parameters for SAI
impulse_p_SAI = [];
impulse_p_SAI.tau = params(1);
impulse_p_SAI.mu = params(3);

% Convolve the impulse response
for k = 1:length(T_to_fit)
    T_emulated = 0;
    for j = 1:k
        T_emulated = T_emulated + impulse_semiInfDiff(j,impulse_p_CO2)*CO2_forcing(k-j+1)+ impulse_semiInfDiff(j,impulse_p_SAI)*SAI_forcing(k-j+1);
    end
    diffs = diffs+(T_to_fit(k)-T_emulated)^2;
end

% Root Mean Square Error calculation
RMSE = sqrt(diffs/length(T_to_fit));
end