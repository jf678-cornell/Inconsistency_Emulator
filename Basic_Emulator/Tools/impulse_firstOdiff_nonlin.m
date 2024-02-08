function ydata = impulse_firstOdiff_nonlin(beta, gamma, alpha, q, t)
% edited from Albert Chu
% beta and alpha are from first order response of AOD to injection
% parameter vector here is the semi-infinite diffusion part
% n=length(t);
% delta=p(2);
% mu=p(1);

% fun = @(t) exp(-alpha*t).*((ceil(t)-t)*q(floor(t)+1)+(t-ceil(t-1))*q(ceil(t)+1))';
% myinterp1([floor(t) ceil(t)], [q(floor(t)+1) q(ceil(t)+1)],t)
% fun     = @(t)   exp(-alpha*t).*q(round(t)+1)';
fun     = @(tau)   exp(-alpha*(tau)).*q(round(tau)+1)';
% fun4ode = @(t,z) exp(-alpha*t).*q(round(t)+1)';
fun4ode = @(tau,z) exp(-alpha*(tau)).*q(round(tau)+1)';
% fun     = @(t)   exp(-alpha*t).*myinterp1(unique([floor(t) ceil(t)]), unique([q(floor(t)+1)' q(ceil(t)+1)']),t);
% fun4ode = @(t,z) exp(-alpha*t).*myinterp1([floor(t) ceil(t)], [q(floor(t)+1) q(ceil(t)+1)],t)';

% if t ~=0
% z = ode45(fun4ode,[0:.0001:t],0).y(end);
% % z = zall(end);
% else
%     z = 0;
% end

z = integral(fun,0,t);

% z = -(14*alpha*t+75*alpha+2*7)*exp(-alpha*t)/ (50*alpha^2);

% ydata = beta*exp(-alpha*t)+gamma*q(t+1).*exp(-1*alpha*t);
% % ydata = beta*z+0*gamma*z^2;
% ydata = (beta+gamma*t)*exp(-alpha*t);

% if runType == 0
%     ydata = (beta+gamma*t)*exp(-alpha*t);
% else
%     if t<20
%         ydata = (beta+gamma*t)*exp(-alpha*t);
%     else
%         ydata = (beta+gamma*(20-(t-20)))*exp(-alpha*t);
%         ydata = (beta)*exp(-alpha*t);
%     end
% 
% end
    % ydata = (beta+gamma*(35-t))*exp(-alpha*t);
% ydata = (beta+gamma*(t-0))*exp(-alpha*t);
ydata = (beta+0*gamma*q(round(t+1)))*exp(-alpha*t);

% ydata = (beta)*exp(-(alpha+gamma*t)*t);


% ydata=(beta*mu*alpha*delta/(alpha+delta^2)).*((delta/alpha).*(1-exp(-alpha.*t))-...
%     (1/sqrt(alpha)).*exp(-alpha.*t).*erfi(sqrt(alpha.*t))+...
%     (1/delta).*(1-exp((delta^2).*t).*erfc(delta.*sqrt(t))));

end 