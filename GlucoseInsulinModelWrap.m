function [xfunctions] = GlucoseInsulinModelWrap(xI,DG,ut,VarIn)

% Finds values generated in GlucoseInsulinModel in the steady state (over a
% long period of time)

t=[]; 
[xfunctions]=GlucoseInsulinModel(t,xI,DG,ut,VarIn);
