function [y]=derivativeofeoftfun(eoft)

% finds the derivative of the sensor error, e(t)

for i=1:length(eoft)-1
    y(i)=(eoft(i+1)-eoft(i));
end
y(end+1)=0;
