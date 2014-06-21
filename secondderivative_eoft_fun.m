function [y]=secondderivative_eoft_fun(derivativeofeoft)

% Finds the second derivative of the sensor error, e(t)

for i=1:length(derivativeofeoft)-1
    y(i)=(derivativeofeoft(i+1)-derivativeofeoft(i));
end
y(end+1)=0;
