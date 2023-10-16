%Writing Tarin and Test Data in CNTK format

%--------------------------------------------------------------------------
%Input:
clc, clear all, close all, fclose all
SmalFarsdatPath='E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\';
TrainOrTest='Train'; %'Test' or 'Train'
LabelMethod=1; %1 0r 2
%-------------------------------



%-------------------------------
LhcbPath=[SmalFarsdatPath,'LHCB'];
%---
load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat;
load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat;
%---
if strcmp(TrainOrTest , 'Train')
    load('SmalFarsdatTrainNames.mat'); DataNames=SmalFarsdatTrainNames;
    if LabelMethod==1
        fid=fopen('TrainLandmarksCntk_LabelFormat1.txt','w');
    elseif LabelMethod==2
        fid=fopen('TrainLandmarksCntk_LabelFormat2.txt','w');
    end
elseif strcmp(TrainOrTest , 'Test')
    load('SmalFarsdatTestNames.mat'); DataNames=SmalFarsdatTestNames;
    if LabelMethod==1
        fid=fopen('TestLandmarksCntk_LabelFormat1.txt','w');
    elseif LabelMethod==2
        fid=fopen('TestLandmarksCntk_LabelFormat2.txt','w');
    end
end
%-------------------------------
NumData=0;
for  i=1:size(DataNames,2)    
    i
    load([LhcbPath,'\LHCB',DataNames{i},'.mat']); %out:CB
    CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT,size(CB,1),1)); %LHCB normalization????????????
    
    load(['Landmarks\Landmarks',DataNames{i}]);%BorderLength
    EventStateTag=Landmarks.EventStateTag;
    
    for j=1:size(EventStateTag,2)        
        if EventStateTag{1,j}~='d'
            NumData=NumData+1;
            CBframe=CB(j,:);
            fprintf(fid,'|features');
            fprintf(fid,' %f', CBframe);           
            if LabelMethod==1
                lbl=[];
                lbl_1(1:30)=0; %state 
                lbl_2(1:36)=0;%first vaj in border lbl_3(1:36)=0;
                lbl_3(1:36)=0; %second vaj in border
                if EventStateTag{1,j}=='s', lbl_1( EventStateTag{3,j})=EventStateTag{2,j};  end;
                if EventStateTag{1,j}=='e'
                    lbl_2(EventStateTag{3,j}{1,1}{1})=EventStateTag{2,j};
                    lbl_3(EventStateTag{3,j}{1,1}{2})=EventStateTag{2,j};
                end               
                lbl=[lbl_1,lbl_2,lbl_3];
            elseif LabelMethod==2
            end
            
            fprintf(fid,' |labels');
            fprintf(fid,' %d', lbl);
            fprintf(fid,'\n');
        end % if EventStateTag(i,1)~='d'
    end % j=1:size(EventStateTag,2)
end %for  i=1:size(DataNames,2)
fclose(fid);
%--------------------------------------------------------------------------
