function [Epsilonoft]=epsilonfun(Sigmaoft)

% finds a sensor related error

Xi=-5.471;
Upsilon=-.5444;
Beta=1.6898;
Mu=15.96;

for i=1:length(Sigmaoft)
Epsilonoft(i)=Xi+(Mu*sinh((Sigmaoft(i)-Upsilon)/Beta));
end
