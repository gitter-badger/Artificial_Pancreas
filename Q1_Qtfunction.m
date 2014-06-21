function Q1_Qtfun=Q1_Qtfunction(t,dQ1_Qt)

% Integrates dQ1_Qt, so that expected Plasma Glucose Concentration can be
% found

Q1_Qtfun=(dQ1_Qt*t(1))-dQ1_Qt*t(2);
