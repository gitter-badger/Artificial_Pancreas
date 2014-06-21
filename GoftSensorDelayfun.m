function [Goft_sensordelay]=GoftSensorDelayfun(TimestampofDisplacement,Goft)

% Finds Expected/Predicted Plasma Glucose Concentration considering sensor
% time delay

for i=1:length(TimestampofDisplacement)
    Goft_sensordelay(i)=Goft(i);
end

Goft_sensordelay(end+1)=0;

Goft_sensordelay(end+1)=0;
