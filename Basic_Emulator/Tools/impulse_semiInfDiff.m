function h = impulse_semiInfDiff(t, impulse_p)

% Avoid divide by zero error
if t == 0
    t = realmin;
end

% Load in parameters
mu = impulse_p.mu;
tau = impulse_p.tau;

% Impulse response
h = mu*(1/sqrt(pi*t/tau)-exp(t/tau)*erfc(sqrt(t/tau)));

% Approximate if MATLAB fails, using functions MATLAB handles better
if exp(t/tau)*erfc(sqrt(t/tau))==Inf || isnan(exp(t/tau)*erfc(sqrt(t/tau)))
h = mu*(1/sqrt(pi*t/tau)-2/sqrt(pi)*(sqrt(t/tau)+sqrt(sqrt(t/tau).^2+2)).^(-1));
end

end