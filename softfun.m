function [y]=softfun(t,dsoft_dt)

% integral-differential error function

y=(dsoft_dt*t(1))-dsoft_dt*t(2);
