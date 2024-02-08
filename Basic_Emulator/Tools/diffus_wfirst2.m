function ydata = diffus_wfirst2(beta, alpha, p, t)
% edited from Albert Chu
% beta and alpha are from first order response of AOD to injection
% parameter vector here is the semi-infinite diffusion part
n=length(t);
delta=p(2);
mu=p(1);
% ydata=(beta*mu*alpha*delta/(alpha+delta^2)).*((delta/alpha).*(1-exp(-alpha.*t))-...
%     (1/sqrt(alpha)).*exp(-alpha.*t).*erfi(sqrt(alpha.*t))+...
%     (1/delta).*(1-exp((delta^2).*t).*erfc(delta.*sqrt(t))));
ydata=(beta*mu*alpha*delta/(alpha+delta^2)).*(exp(-alpha.*t).*(delta+sqrt(alpha).*erfi(sqrt(alpha.*t)))-delta.*exp((delta.^2).*t).*erfc(delta.*sqrt(t)));
end 