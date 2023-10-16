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
AllLabels2_train=zeros(172861,72);
AllLabels1_train=zeros(171718,NumLbl);


x1=0;
x2=0;
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
            x1=x1+1; AllLabels2_train(x1,:)=lbl2;           
            % Label format 1:
            if k<=NumLbl
                x2=x2+1; AllLabels1_train(x2,:)=lbl;
            end
        end % if size(EventIndex,1)==1
    end
end
save('AllLabels2_train','AllLabels2_train');
save('AllLabels1_train','AllLabels1_train');
%--------------------------------------------------------------------------





























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


%Test
load('SmalFarsdatTestNames.mat'); DataNames=SmalFarsdatTestNames;
AllLabels2_test=zeros(4070,72);
AllLabels1_test=zeros(4050,NumLbl);


x1=0;
x2=0;
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
            x1=x1+1; AllLabels2_test(x1,:)=lbl2;          
            % Label format 1:
            if k<=NumLbl
                lbl(k)=1;
                x2=x2+1; AllLabels1_test(x2,:)=lbl;
            end
        end % if size(EventIndex,1)==1
    end
end
save('AllLabels2_test','AllLabels2_test');
save('AllLabels1_test','AllLabels1_test');
%--------------------------------------------------------------------------
