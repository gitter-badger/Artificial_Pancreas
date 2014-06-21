function [SensorGlucose,Timestamp_SensorGlucose]=sensor(raw,Timestamp)

% Extracts SensorGlucose values and Timestamp_SensorGlucose from the
% imported xls file

SensorGlucose=raw(2:end,31);

%Removing 'Sensor Glucose' from SensorGlucose array
for nnn=1:length(SensorGlucose)
    if (strcmp(SensorGlucose(nnn),'Sensor Glucose (mg/dL)')==1)
        SensorGlucose(nnn)=[];
    else 
        break
    end
end

%raw 3, removal of NaN [Not a Number] values, using for loops
[x,y]=size(SensorGlucose);

for ii=1:x
    for jj=1:y
        if strcmp('NaN',SensorGlucose{ii,jj})==1
            SensorGlucose{ii,jj}=[];
            Timestamp{ii,jj}=[];
        else 
            SensorGlucose{ii,jj}=SensorGlucose{ii,jj};
            Timestamp{ii,jj}=Timestamp{ii,jj};
        end
    end
end


Timestamp_SensorGlucose=Timestamp;

Timestamp_SensorGlucose(cellfun(@isempty,SensorGlucose)) = [];

SensorGlucose(cellfun(@isempty,SensorGlucose)) = [];
