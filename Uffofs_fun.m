function y=Uffofs_fun(s,Dml)

% Finds the laplace transform Uffofs, which is based on carb consumption

DG_input=100*Dml;

t3=t3find(DG_input); % [min]
t4=313; % [min]
Ksubf=-15.625;

y=(Dml*(-Ksubf)*(t3*s+1))/(t4*s+1);
