function ydata = diffus_wfirst(beta, alpha,  t)
% edited from Albert Chu
% beta and alpha are from first order response of AOD to injection
% parameter vector here is the semi-infinite diffusion part
n=length(t);
% delta=p(2);
% mu=p(1);
ydata = beta*(1-exp(-alpha*t));
% ydata=(beta*mu*alpha*delta/(alpha+delta^2)).*((delta/alpha).*(1-exp(-alpha.*t))-...
%     (1/sqrt(alpha)).*exp(-alpha.*t).*erfi(sqrt(alpha.*t))+...
%     (1/delta).*(1-exp((delta^2).*t).*erfc(delta.*sqrt(t))));

end 