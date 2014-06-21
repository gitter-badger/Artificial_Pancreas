function [y]=derivativeofYnegsubMoft_evaluated_fun(YnegsubMoft_evaluated)

% Finds the derivative of YnegsubMoft, which is a value generated when
% carbs are consumed

for i=1:length(YnegsubMoft_evaluated)-1
    y(i)=(YnegsubMoft_evaluated(i+1)-YnegsubMoft_evaluated(i));
end
y(end+1)=0;
