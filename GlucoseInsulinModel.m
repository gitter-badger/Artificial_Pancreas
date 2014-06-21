function [xfunctions]=GlucoseInsulinModel(t,xI,DG,ut,VarIn)

% Solves for variables in multiple differential equations that represent
% the relationship between insulin, blood glucose values, and carbs

D1=xI(1); % [mmol]
D2=xI(2); % [mmol]
Q1=xI(3); % [mmol]
Q2=xI(4); % [mmol]
S1=xI(5); % [mU]
S2=xI(6);  % [mU]
I=xI(7);  %[mU/L] 
x=xI(8:10); %[mU/L] 

%Constants 
AG=VarIn(1); %Carbohydrate(CHO) bioavailability
tG=VarIn(2); %Time to maximum CHO absorption, [min]
F01=VarIn(3); %Non?insulin?dependent glucose flux, [mmol min^-1]
k12=VarIn(4); %Transfer rate, [min??1]
EGP0=VarIn(5); %Endogenous glucose production, [mmol min^-1]
tI=VarIn(6); %Time to maximum sc insulin absorption, [min]
ke=VarIn(7); %Insulin elimination from plasma, [min^-1]
VI=VarIn(8); %Insulin distribution volume, [L]
kb=VarIn(9:11)'; %Activation rate
ka=VarIn(12:14)'; %Deactivation rate,[min^-1]
VG=VarIn(15);	%Glucose distribution volume, [L]

%Additional variables
G=Q1/VG;	%Glucose concentration

%The Non insulin dependent glucose flux 
%%corrected for the ambient glucose concentration 
if(G>=4.5);
Fc01=F01;
else
Fc01=F01*G/4.5;
end  %The renal glucose clearance above the glucose threshold
if(G>9);
FR=0.003*(G-9)*VG;
else
FR=0;
end
UG=D2/tG;
UI=S2/tI;

xfunctions=zeros(10,1);

%The Meal Model 
%Glucose absorption subsystem 
xfunctions(1,1)=AG*DG-D1/tG; %%dD1/dt[dmmol/dt] 
xfunctions(2,1)=D1/tG-UG;	%dD2/dt[dmmol/dt] 

%The Hovorka Glucose insulin Model 

%Glucose subsystem
xfunctions(3,1)=-(Fc01+FR)-x(1)*Q1+k12*Q2+UG+EGP0*(1-x(3));%dQ1/dt[dmmol/dt]
xfunctions(4,1)=x(1)*Q1-(k12+x(2))*Q2;%dQ2/dt[dmmol/dt] 
%Insulin subsystem 
xfunctions(5,1)=ut-S1/tI; 
xfunctions(6,1)=S1/tI-UI; 
xfunctions(7,1)=UI/VI-ke*I;

%Insulin action subsystem 
xfunctions(8,1)=kb(1)*I-ka(1)*x(1);%dx1/dt[d(mU/L)/dt] 
xfunctions(9,1)=kb(2)*I-ka(2)*x(2);%dx2/dt[d(mU/L)/dt] 
xfunctions(10,1)=kb(3)*I-ka(3)*x(3);%dx3/dt[d(mU/L)/dt]
