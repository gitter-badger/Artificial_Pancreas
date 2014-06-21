function [y]=integral_eoftfun(t,eoft)

% finds the integral of the sensor error, e(t)

y=(eoft*t(1))-eoft*t(2);
