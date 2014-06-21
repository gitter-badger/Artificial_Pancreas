function [Basal2]=Basalfun2(BasalProfileStarteditedUniformMatrix)

% This function further edits the information extracted from the function
% Basalfunction so that data vectors are in a calculatable form for matlab

% BasalProfileStarted needs to be converted in to matrix to perform other
% functions

BasalProfileStarteditedUniformMatrix2=cell2mat(BasalProfileStarteditedUniformMatrix);


% Loop to remove more extraneous data if length of extraneous data is
% greater than length of 40

% counter
eee=1;

while eee<=length(BasalProfileStarteditedUniformMatrix2(:,1))
    for zzz=1:length(BasalProfileStarteditedUniformMatrix2(1,:))
        if strcmp(BasalProfileStarteditedUniformMatrix2(eee,zzz),'R')~=1
            BasalProfileStarteditedUniformMatrix2(eee,zzz)=BasalProfileStarteditedUniformMatrix2(eee,zzz);
        else
            break
        end
    end
      eee=eee+1;
end
