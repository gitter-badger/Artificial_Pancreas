function [x0]=Gfind(input_basalperminute)

% Solves for various variables in the steady state (conditions over a long period of
% time) so that further calculations can be used. Further calculations can
% be things like expected glucose value based on insulin given and carbs
% consumed.

% Inputs

M=80; %Mass of the subject, [kg]
AG = 0.8; %Carbohydrate(CHO) bioavailability, []
tG=40; %Time to maximum CHO absorption, [min]
F01=0.0097*M; %Non?insulin?dependent glucose flux, [mmol min^-1]
k12=0.066; %Transfer rate, [min??1]
EGP0=0.0161*M; %Endogenous Glucose Production [mmol min^-1]
tI=55;  % Time to maximum subcutaneous insulin absorption [min]
ke=0.138; %Insulin elimination from plasma, [min^-1]
VI=0.12*M; %Insulin distribution volume, [L]
ka=[0.006;0.06;0.03]; %Deactivation rate,[min??1] 
kb=[51.2*1e-4*ka(1);8.2*1e-4*ka(2);520*1e-4*ka(3)];%Activation rate 
VG=0.16*M; %%Glucose distribution volume,[L] 
ut=input_basalperminute*1000;
DG=0; %Carbohydrates consumed [grams/100]

%Initializing variables 

x0(1:10,1)=-5; 

% maximum times fsolve can be evaluated
options = optimset('MaxFunEvals',1000000,'Display','off');

%Initializing x0 to the steady state 
VarIn=[AG,tG,F01,k12,EGP0,tI,ke,VI,kb',ka',VG]; 
XS=fsolve(@(x)GlucoseInsulinModelWrap(x,DG,ut,VarIn),x0,options); 
x0=XS;
