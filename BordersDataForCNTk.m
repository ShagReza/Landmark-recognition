%Writing Tarin and Test Data in CNTK format

%--------------------------------------------------------------------------
clc, clear all, close all, fclose all
SmalFarsdatPath='F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\';

context=3; % number of frames, before and after a border
%NumLbl=1260; %36*36
NumLbl=696; %more than 10 frames from 1260 possible labels

load('AllEvents4.mat');
LhcbPath=[SmalFarsdatPath,'LHCB'];

load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat;
load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat;

%Train
 load('SmalFarsdatTrainNames.mat'); DataNames=SmalFarsdatTrainNames;
 fid=fopen('TrainBordersCntk_LabelFormat2.txt','w');
% %fid=fopen('TrainBordersCntk_LabelFormat1.txt','w');

%Test
%load('SmalFarsdatTestNames.mat'); DataNames=SmalFarsdatTestNames;
%fid=fopen('TestBordersCntk_LabelFormat2.txt','w');
%fid=fopen('TestBordersCntk_LabelFormat1.txt','w');


for  i=1:size(DataNames,2)
    i
    load([LhcbPath,'\LHCB',DataNames{i},'.mat']); %out:CB
    load(['BordersLength\BordersLength',DataNames{i}]);%BorderLength
    load(['Events\Event',DataNames{i}]);
    
    %LHCB normalization????????????
    CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT,size(CB,1),1));
    for j=1:size(Event,1)
        indx=[];
        lbl=zeros(1,NumLbl);
        lbl2=[]; lbl2_1(1:36)=0; lbl2_2(1:36)=0;

        EventFlag=[];
        for k=1:size(AllEvents4,1)
            indx=find((Event(j,2)==AllEvents4{k,1}) && (Event(j,3)==AllEvents4{k,2}) );
            
            if size(indx,1)==1, lbl2_1(Event(j,2))=1;  lbl2_2(Event(j,3))=1; EventFlag=1; break; end;
        end
        lbl2=[lbl2_1,lbl2_2];
        
        if size(EventFlag,1)==1
            % Label format 2:
            c=Event(j,1);
            a=c-context+1; if a<0, a=1; end;
            b=c+context; if b>size(CB,1), b=size(CB,1); end;
            CBborder=CB(a:b,:)'; CBborder=CBborder(:);
            fprintf(fid,'|Features');
            fprintf(fid,' %f', CBborder);
            fprintf(fid,' |Labels');
            fprintf(fid,' %d', lbl2);
            fprintf(fid,'\n');

                    % Label format 1:
%                     if k<=NumLbl
%                         c=Event(j,1);
%                         a=c-context+1; if a<0, a=1; end;
%                         b=c+context; if b>size(CB,1), b=size(CB,1); end;
%                         CBborder=CB(a:b,:)'; CBborder=CBborder(:);
%                         fprintf(fid,'|features');
%                         fprintf(fid,' %f', CBborder);
%                         fprintf(fid,' |labels');
%                         lbl(k)=1;
%                         fprintf(fid,' %d', lbl);
%                         fprintf(fid,'\n');
%                     end
        end % if size(EventIndex,1)==1
    end
end
fclose(fid);
%--------------------------------------------------------------------------
