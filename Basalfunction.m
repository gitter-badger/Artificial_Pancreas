function [TimestampBasalRate,BasalProfileStarteditedUniformMatrix,BasalProfileStartedited2]=Basalfunction(raw,Raw_Type,Raw_Values,Timestamp)

% This function extracts Timestamp from Basal Rate, and finds the place where a new basal
% profile was started and records the basal rate


% Basal Rate Start Timestamp

TimestampBasalRate=Timestamp(strcmp(Raw_Type,'BasalProfileStart'));


%BasalProfileStart, extracted from Raw Values, contains extraneous data
%that must be removed

BasalProfileStart=Raw_Values(strcmp(Raw_Type,'BasalProfileStart')==1);

% Removing Empty cells from TimeStampBasalRate
TimestampBasalRate(cellfun(@isempty,BasalProfileStart)) = [];

% Removing Empty Cells from BasalProfileStart
BasalProfileStart(cellfun(@isempty,BasalProfileStart)) = [];

% Loop to remove extraneous data from the begininning of BasalProfileStart

% pre loop initialization

% counter
ccc=1;

% vsriable
BasalProfileStartedited2={0};

% Removing extraneous data from the beginning of BasalProfileStart
if length(BasalProfileStart)>1
while ccc<=length(BasalProfileStart(:,1))
    for ddd=1:length(BasalProfileStart(1,:))
        BasalProfileStartedited=cell2mat(BasalProfileStart(ccc,ddd));
        BasalProfileStartedited(1:40)=[];
        BasalProfileStartedited2{ccc}=BasalProfileStartedited;
    end
    ccc=ccc+1;
end
end
BasalProfileStartedited2=BasalProfileStartedited2';

% Loop-create uniform length for each indice of BasalProfileStartedited2

% Loop-create uniform length for each indice of BasalProfileStartedited2

% pre loop initilization

% BasalProfileStartedited2Uniform-Equal Length Indices of BolusWizardData

BasalProfileStarteditedUniformMatrix={0};

% counter
ggg=1;

% Temporary Storage Variable
hhh=0;


% while loop
if length(BasalProfileStart)>1
while (ggg<=length(BasalProfileStartedited2))
    lll=BasalProfileStartedited2(ggg,:);
    hhh=cell2mat(lll);
    jjj=hhh(1:20);
        if isempty(jjj)~=1
        BasalProfileStarteditedUniformMatrix{ggg}=jjj;
        ggg=ggg+1;
else
    return
        end
end
end
BasalProfileStarteditedUniformMatrix=BasalProfileStarteditedUniformMatrix';
