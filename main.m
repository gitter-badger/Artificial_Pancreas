% Artificial Pancreas Dosing Project

clear,clc,close

% importing, paramaterizing, and formating the excel data from the medtronic insulin pump and cgms
% upload by creating a function file, dataformat, to manage the data

[Index,Date,Time,Timestamp,TempBasalAmount,BolusWizardData,Raw_Type,Raw_Values,raw]=dataformat('CareLink-Export-XLS.xls');


% Sensor Glucose Readings, AKA Reference Glucose
[SensorGlucosecell,Timestamp_SensorGlucose]=sensor(raw,Timestamp);

% Basal function
[TimeStampBasalRate,BasalProfileStarteditedUniformMatrix]=Basalfunction(raw,Raw_Type,Raw_Values,Timestamp);

% Basal function 2
[Basalstring]=Basalfun2(BasalProfileStarteditedUniformMatrix);

if isempty(Basalstring)==1
   Basal=input('Current basal rate not available via uploaded file. Please enter current basal rate');
else
    Basal=Basalstring;
end

%========================================================================%
%                                                                        %
%                       End of Importation                               %
%                                                                        %
%========================================================================%

% Finding starting displacement point of Blood Glucose (original place
% where blood glucose exceeds or goes below target)

SensorGlucosechar=char(SensorGlucosecell);

SensorGlucosenum=str2num(SensorGlucosechar);

if isempty(SensorGlucosenum)==1
    error('Program aborted. There are no CGMS sensor readings in this data file. CGMS readings are necessary for the calculation of insulin dosages. Please use a data file with CGMS readings')
end

if (SensorGlucosenum(end)>=100)==1
displacementpointsindices=find(SensorGlucosenum>=100);
else (SensorGlucosenum(end)<100)==1;
    displacementpointsindices=find(SensorGlucosenum<100);
end

for i=length(displacementpointsindices):-1:2
    if displacementpointsindices(i)-displacementpointsindices(i-1)>1
        originaldisplacementpointindice=displacementpointsindices(i);
        break
    else
        originaldisplacementpointindice=displacementpointsindices(1);
    end
end

% Sensor Glucose Values at Displacement
SensorGlucoseValuesatDisplacement=SensorGlucosenum(originaldisplacementpointindice:end);

% Timestamp of Sensor Glucose Values at Displacement
TimestampSensorGlucoseValuesDisplacementcell=Timestamp_SensorGlucose(originaldisplacementpointindice:end);

TimestampSensorGlucoseValuesDisplacementchar=char(TimestampSensorGlucoseValuesDisplacementcell);

TimestampSensorGlucoseValuesDisplacementMatrix=datenum(TimestampSensorGlucoseValuesDisplacementchar);



% Sensor Glucose Values timestamp, now defined at t=0 at the first displacement
% point up until total time of displacement is reached

SerialTimestampIntervalofDisplacement(1)=0;



for j=2:length(TimestampSensorGlucoseValuesDisplacementMatrix)
    SerialTimestampIntervalofDisplacement(j)=TimestampSensorGlucoseValuesDisplacementMatrix(j,:)-TimestampSensorGlucoseValuesDisplacementMatrix(j-1,:);
end
SerialTimestampofDisplacement(1)=0;
SerialTimeElapsed(1)=0;

for ll=2:length(SerialTimestampIntervalofDisplacement)
    SerialTimeElapsed(ll)=sum(SerialTimestampIntervalofDisplacement(1:ll));
    SerialTimestampofDisplacement(ll)=SerialTimeElapsed(ll-1)+SerialTimestampIntervalofDisplacement(ll);
end

SerialTimestampofDisplacement=SerialTimestampofDisplacement';

[TimestampofDisplacement]=Timefun(SerialTimestampofDisplacement);

% Total time of displacement
TotalDisplacementTime=TimestampofDisplacement(end)-TimestampofDisplacement(1);

%========================================================================%
%                                                                        %
%                    End of Finding Displacement points                  %
%                                                                        %
%========================================================================%
% Start of Subcutaneous Glucose Measurements

%Finding Sensor Error

%sigma of t

[Sigmaoft]=sigmafun(SensorGlucoseValuesatDisplacement);

% epsilon of t

[Epsilonoft]=epsilonfun(Sigmaoft);

%=========================================================================%
%                                                                         %
%                     End of Sensor Error Calculations                    %
%                                                                         %
%=========================================================================%


% Finding G(t) in order to find the CGM signal function
% y(t)

% First we must find input insulin dosage in order to find G(t)

insulin_input_basal_hourlycell=Basal(end);

insulin_input_basal_hourly=str2num(cell2mat(insulin_input_basal_hourlycell));

input_basalperminute=insulin_input_basal_hourly/60;


% Carbohydrate Consumption

DG_input=input('How many carbohydrates are you going to consume? [grams]');

DG=DG_input/100;

[x0]=Gfind(input_basalperminute);

dQ1_dt=x0(3,1);

% Integrating to get Q(t)

for h=2:length(TimestampofDisplacement)
    t(1)=TimestampofDisplacement(h);
    t(2)=TimestampofDisplacement(h-1);
    Q1oft(h)=Q1_Qtfunction(t,dQ1_dt);
end

Q1oft(end+1)=0;
Q1oft(1)=[];

Q1oft=Q1oft';


Mass=80; %Mass, [kg]

VG=0.16*Mass; %Glucose distribution volume, [L]

Goft=Q1oft/VG; %plasma glucose concentration
 

% Finding GofT with sensor delay G(T-tau)

[Goft_sensordelay]=GoftSensorDelayfun(TimestampofDisplacement,Goft);

% Removing extra indices from Goft_sensordelay
% double check this
Goft_sensordelay(1:2)=[];

% Finding CGM signal y(t)
[yoft]=yoftfun(Epsilonoft,Goft_sensordelay);
yoft=yoft';

%=========================================================================%
%                                                                         %
%            End of Subcutaneous Glucose Measurements Section             %
%                                                                         %
%=========================================================================%

% Controllers section

% reference glucose, aka Sensor Glucose, [mmol/L]

roft=SensorGlucoseValuesatDisplacement/18.1;

% constants are Km,t0m,tm1,and tm2

Km=-19;   % [mg min/mU dl]
t0m1=25;  % [min]
tm1=155; % [min]
tm2=365; % [min]

% YsubMofS, deviation of glucose level and insulin infusion from the
% chosen basal point (Y0, U0)
syms s;
YsubMofS=Km*exp(-t0m1*s);

%YsubMoft

YsubMoft_fun=matlabFunction(YsubMofS);

YsubMoft_evaluated=invlap(YsubMoft_fun,TimestampofDisplacement')';

% YnegsubS
 syms s;
YnegsubS=Km;

YnegsubSoft_fun=@(s) YnegsubS;

YnegsubMoft_evaluated=invlap(YnegsubSoft_fun,TimestampofDisplacement');

YnegsubMoft_evaluated=YnegsubMoft_evaluated';

% error of t,e(t)

eoft=roft-(yoft-YsubMoft_evaluated)-YnegsubMoft_evaluated;

% Gff(t), a feedforward action only needs to be found if carbohydrates are consumed
if DG>0

% finding Uff(t)
%consider changing back to tfind
t3=338; % [min]
t4=313; % [min]
Ksubf=-15.625;

% meal in CHO
Dml=DG_input;

% Laplace transform of feedforward insulin, aka proposed bolus amount
syms s
UffofsSym=(Dml*(-Ksubf)*(t3*s+1))/(t4*s+1);
UffofsFun=matlabFunction(UffofsSym);

Uffoft=invlap(UffofsFun,TimestampofDisplacement');

else DG==0;
    Uffoft=0;

end

Uffoft_BolusDose=Uffoft(1)/10000;


% finding ufb(t)

% need to find the derivative of e(t)
	
derivativeofeoft=derivativeofeoftfun(eoft)';

% need to find the derivative of YnegsubMoft_evaluated

derivativeofYnegsubMoft_evaluated=derivativeofYnegsubMoft_evaluated_fun(YnegsubMoft_evaluated)';

% finding s(t)

% need to find second derivative of e(t)

SecondDerivativeofeoft=secondderivative_eoft_fun(derivativeofeoft)';

% constants for dsoft_dt
lambda1=.014; %[min^-1]
lambda2=4.923e-5; %[min^-2]

% derivative of s of t
dsoft_dt=SecondDerivativeofeoft+(lambda1.*derivativeofeoft)+(lambda2.*eoft);

% s of t
for jj=1:length(TimestampofDisplacement)
t(1)=TimestampofDisplacement(jj);
t(2)=0;
integral_eoftmatrix(:,jj)=integral_eoftfun(t,eoft);
end

[r,c]=size(integral_eoftmatrix);

for iii=1:r
    for jjj=1:c
integral_eoft(iii)=integral_eoftmatrix(iii,jjj);
    end
end
integral_eoft=integral_eoft';

soft=derivativeofeoft+lambda1*eoft+lambda2*integral_eoft;



% finding sign(s(t))

gamma=.06; % mg/dL
sign_soft=soft./(abs(soft)+gamma);

% constant kd
kd=1/Km;


% u_fboft, feedback insulin (basal), in terms of minutes

u_fboft=((1/Km)*((tm1*tm2)*(lambda1*derivativeofeoft+lambda2*eoft)+(tm1+tm2)*derivativeofYnegsubMoft_evaluated+YnegsubMoft_evaluated)+kd*sign_soft)/10000;
abs_u_fboft=abs(u_fboft);

u_fboft2=input_basalperminute+abs_u_fboft;

%identifiying outliers
for i=1:length(u_fboft2)
if u_fboft2(i)~=max(u_fboft2)
    new_u_fboft(i)=u_fboft2(i);
else
    new_u_fboft(i)=0;
end
end
for i=1:length(new_u_fboft)
    if new_u_fboft(i)~=max(new_u_fboft)
        nooutlieru_fboft(i)=new_u_fboft(i);
    else
        nooutlieru_fboft(i)=0;
    end
end
 nooutlieru_fboft(nooutlieru_fboft==0)=[];
  average=mean(nooutlieru_fboft);
basal_summed=sum(u_fboft2(u_fboft2<4)); % units per minute

SensorGlucoseValuesatDisplacement_StandardDeviation=std(SensorGlucoseValuesatDisplacement);

SensorGlucoseValuesatDisplacement_mean=mean(SensorGlucoseValuesatDisplacement);

TotalDisplacementTimeinHours=TotalDisplacementTime/60;

ut=input_basalperminute*1000+basal_summed;
AG=.8;
tG=40;
F01=0.0097*Mass;
k12=0.066;
EGP0=0.0161*Mass;
tI=55;
ke=0.138; %Insulin elimination from plasma, [min^-1]
VI=0.12*Mass; %Insulin distribution volume, [L]
ka=[0.006;0.06;0.03]; %Deactivation,[min??1] 
kb=[51.2*1e-4*ka(1);8.2*1e-4*ka(2);520*1e-4*ka(3)];%Activation rate 
VG=0.16*Mass; %%Glucose distribution volume,[L]
VarIn=[AG,tG,F01,k12,EGP0,tI,ke,VI,kb',ka',VG]; 

x1(1:10,:)=-5000;
options = optimset('MaxFunEvals',1000000,'Display','off');
diffeqsteadystate=(fsolve(@(x)GlucoseInsulinModelWrap(x,DG,ut,VarIn),x1,options));

dq1_dt2=diffeqsteadystate(3,1);

% Integrating to get Q(t)
Q1oft2(1)=0;

for kk=2:length(TimestampofDisplacement)
    t(1)=TimestampofDisplacement(kk);
    t(2)=TimestampofDisplacement(kk-1);
    Q1oft2(kk)=Q1_Qtfunction(t,dq1_dt2);
end

Q1oft2=Q1oft2';

Goft2=Q1oft2/VG; %plasma glucose concentration

Goft2_mgdL=Goft2*18.1;


TotalBolus=basal_summed+Uffoft_BolusDose;

disp('          Please Peform These Actions:         ')
disp(' ')

disp(['===>  Administer a bolus dose of' ' ' num2str(TotalBolus) ' ' '[Units]'])
