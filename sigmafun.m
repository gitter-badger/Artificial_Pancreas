function [Sigmaoft]=sigmafun(SensorGlucoseValuesatDisplacement)

% Finds one of the sensor related errors, sigma

indicelength=length(SensorGlucoseValuesatDisplacement);

unitcovariance=1;
indices=1:indicelength;
for j=1:indicelength
    % laplacian white noise probability distribution production-produces an
    % array with unit covariance and NEAR zero mean
    voft(j)=(1/sqrt(2*pi*unitcovariance^2))*exp(-sqrt(2/unitcovariance^2)*abs(indices(j)));
end

Sigmaoft(1)=voft(1);

for i=2:length(SensorGlucoseValuesatDisplacement+1)
    Sigmaoft(i)=.7*(Sigmaoft(i-1)+voft(i));
end
