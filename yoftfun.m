function [yoft]=yoftfun(Epsilonoft,Goft_sensordelay)

% CGM signal model

for i=1:length(Epsilonoft)
    yoft(i)=Epsilonoft(i)+Goft_sensordelay(i);
end
