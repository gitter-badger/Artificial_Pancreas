function [TimestampofDisplacement]=Timefun(SerialTimestampofDisplacement)

% Finds the Timestamp of displacement, and sets the initial time of
% displacement as T=0

Time=datestr(SerialTimestampofDisplacement);

if length(Time(1,:))>8
Minutes=Time(:,16:17);
    Hours=Time(:,13:14);
else
    Minutes=Time(:,4:5);
    Hours=Time(:,1:2);
end

Minutesnum=str2num(Minutes);

Hoursvector{length(Hours)}=0;

for i=1:length(Hours)
    Hoursvectorcell{i}=Hours(i,1:end);
end

Hoursvectorcell=Hoursvectorcell';

midnightandnoonindices=find(ismember(Hoursvectorcell, '12')==1);

startnoon=0;
endmidnight=0;


for j=2:length(midnightandnoonindices)
    if (midnightandnoonindices(j)-midnightandnoonindices(j-1))>1
        endmidnight=midnightandnoonindices(j-1);
        startnoon=midnightandnoonindices(j);
    end
end

if (startnoon&endmidnight)==1
midnightindices=midnightandnoonindices(midnightandnoonindices<=endmidnight);
noonindices=midnightandnoonindices(midnightandnoonindices>=startnoon);
end



if (startnoon&endmidnight)==1
    Hoursvectorcell(noonindices)={'12'};
    Hoursvectorcell(midnightindices)={'0'};
else
    Hoursvectorcell(midnightandnoonindices)={'0'};
end


% replacing values with number value instead of a string
Hoursvectorcell(strcmp(Hoursvectorcell,'0'))={0};
Hoursvectorcell(strcmp(Hoursvectorcell,'00'))={0};
Hoursvectorcell(strcmp(Hoursvectorcell,' 1'))={1};
Hoursvectorcell(strcmp(Hoursvectorcell,'01'))={1};
Hoursvectorcell(strcmp(Hoursvectorcell,' 2'))={2};
Hoursvectorcell(strcmp(Hoursvectorcell,'02'))={2};
Hoursvectorcell(strcmp(Hoursvectorcell,' 3'))={3};
Hoursvectorcell(strcmp(Hoursvectorcell,'03'))={3};
Hoursvectorcell(strcmp(Hoursvectorcell,' 4'))={4};
Hoursvectorcell(strcmp(Hoursvectorcell,'04'))={4};
Hoursvectorcell(strcmp(Hoursvectorcell,' 5'))={5};
Hoursvectorcell(strcmp(Hoursvectorcell,'05'))={5};
Hoursvectorcell(strcmp(Hoursvectorcell,' 6'))={6};
Hoursvectorcell(strcmp(Hoursvectorcell,'06'))={6};
Hoursvectorcell(strcmp(Hoursvectorcell,' 7'))={7};
Hoursvectorcell(strcmp(Hoursvectorcell,'07'))={7};
Hoursvectorcell(strcmp(Hoursvectorcell,'08'))={8};
Hoursvectorcell(strcmp(Hoursvectorcell,' 8'))={8};
Hoursvectorcell(strcmp(Hoursvectorcell,'09'))={9};
Hoursvectorcell(strcmp(Hoursvectorcell,' 9'))={9};
Hoursvectorcell(strcmp(Hoursvectorcell,'10'))={10};
Hoursvectorcell(strcmp(Hoursvectorcell,'11'))={11};
Hoursvectorcell(strcmp(Hoursvectorcell,'12'))={12};
Hoursvectorcell(strcmp(Hoursvectorcell,'13'))={13};
Hoursvectorcell(strcmp(Hoursvectorcell,'14'))={14};
Hoursvectorcell(strcmp(Hoursvectorcell,'15'))={15};
Hoursvectorcell(strcmp(Hoursvectorcell,'16'))={16};
Hoursvectorcell(strcmp(Hoursvectorcell,'17'))={17};
Hoursvectorcell(strcmp(Hoursvectorcell,'18'))={18};
Hoursvectorcell(strcmp(Hoursvectorcell,'19'))={19};
Hoursvectorcell(strcmp(Hoursvectorcell,'20'))={20};
Hoursvectorcell(strcmp(Hoursvectorcell,'21'))={21};
Hoursvectorcell(strcmp(Hoursvectorcell,'22'))={22};
Hoursvectorcell(strcmp(Hoursvectorcell,'23'))={23};

Hoursvectormatrix=cell2mat(Hoursvectorcell);

% Creating TimestampofDisplacement, in minutes

for m=1:length(Hoursvectormatrix)
    TimestampofDisplacement(m)=(Hoursvectormatrix(m)*60)+Minutesnum(m);
end
