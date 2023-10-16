
%--------------------------------------------------------------------------
clc,clear all,close all
MeanVarNorm=4; %1:global, 2:each speaker, 3: 3 second, 4:std
load('TestBabaiName.mat');
context=7;
eps=0.000001;
%context=6;
LhcbPath=['SmallFarsdat\LHCB'];
MelspecPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras\FeatExtract\MelSpec64';
lhcb64Path='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LHCB64';
lhcbDelta2Path='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\lhcbDelta2';

FeatType='melspec'; % melspec or lhcb
FeatType='lhcb64'; % melspec or lhcb
FeatType='lhcbDelta2';
%---
if strcmp(FeatType , 'lhcb'),load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat; load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat;
elseif strcmp(FeatType , 'melspec'),load('VarTotalSmalFarsdat_melspec.mat');  varT=VarTotalSmalFarsdat_melspec; load('MeanTotalSmalFarsdat_melspec.mat'); meanT=MeanTotalSmalFarsdat_melspec;
elseif strcmp(FeatType , 'lhcb64'),load('VarTotalSmalFarsdat_lhcb64.mat');  varT=VarTotalSmalFarsdat_lhcb64; load('MeanTotalSmalFarsdat_lhcb64.mat'); meanT=MeanTotalSmalFarsdat_lhcb64; 
elseif strcmp(FeatType , 'lhcbDelta2'), load('VarTotalSmalFarsdat_lhcbDelta2.mat');  varT=VarTotalSmalFarsdat_lhcbDelta2; load('MeanTotalSmalFarsdat_lhcbDelta2.mat'); meanT=MeanTotalSmalFarsdat_lhcbDelta2; end;
%---

for  i=1:size(TestBabaiName,2)
    i
    fid=fopen(['Test_',num2str(TestBabaiName(i)),'_Context',num2str(context),'.txt'],'w');
    
    if strcmp(FeatType , 'lhcb'),load([LhcbPath,'\LHCB',num2str(TestBabaiName(i)),'.mat']); %out:CB
    elseif strcmp(FeatType , 'melspec'),load([MelspecPath,'\S',num2str(TestBabaiName(i)),'.mat']);CB=Feat'; 
    elseif strcmp(FeatType , 'lhcb64'),load([lhcb64Path,'\S',num2str(TestBabaiName(i)),'.mat']);
    elseif strcmp(FeatType , 'lhcbDelta2'),load([lhcbDelta2Path,'\LHCB',num2str(TestBabaiName(i)),'.mat']); end;
    
    load(['Landmarks\Landmarks',num2str(TestBabaiName(i))]);%BorderLength
    if MeanVarNorm==1
        CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT,size(CB,1),1)); %LHCB normalization????????????
    elseif MeanVarNorm==4
        CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(sqrt(varT)+eps,size(CB,1),1)); %LHCB normalization????????????
    elseif MeanVarNorm==2
        Vajs=Landmarks.labels;
        IndexMinus30=find(Vajs~=30);
        meanT=mean(CB(IndexMinus30,:));
        varT=var(CB(IndexMinus30,:));
        CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT,size(CB,1),1));
    elseif MeanVarNorm==3
        Vajs=Landmarks.labels;
        IndexMinus30=find(Vajs~=30);
        CB2=CB;
        for h=1:length(IndexMinus30)
            [SortOut,SortIndex]=sort(abs(IndexMinus30(h)-IndexMinus30));
            SelectedFrames=CB(IndexMinus30(SortIndex(2:301)),:); %nearest non silent frames
            meanT=mean(SelectedFrames);
            varT=var(SelectedFrames);
            CB2(IndexMinus30(h),:)=(CB(IndexMinus30(h),:)-meanT)./(varT+eps);
        end
        Index30=find(Vajs==30);
        for h=1:length(Index30)
            [SortOut,SortIndex]=sort(abs(Index30(h)-Index30));
            if length(Index30)<301, LL=length(Index30);
            else, LL=301; end
            SelectedFrames=CB(Index30(SortIndex(2:LL)),:); %nearest non silent frames
            meanT=mean(SelectedFrames);
            varT=var(SelectedFrames);
            CB2(Index30(h),:)=(CB(Index30(h),:)-meanT)./(varT+eps);
        end
        CB=CB2;
    end
    CB_context=[];
    for j=1:size(CB,1)
        a=j-context; if a<1, a=1; end;
        b=j+context; if b>size(CB,1), b=size(CB,1); end;
        if a==1, b=a+2*context; end
        if b==size(CB,1); a= b-2*context; end
        CBframesWithContext=CB(a:b,:)'; CBframesWithContext=CBframesWithContext(:)';
        lbl(1:103)=0;
        %lbl(1:73)=0;
        fprintf(fid,'|features'); fprintf(fid,' %f', CBframesWithContext);
        fprintf(fid,' |labels'); fprintf(fid,' %d', lbl); fprintf(fid,'\n');
        CB_context=[CB_context;CBframesWithContext];
    end
    fclose(fid);
    save('CB_context','CB_context');
    copyfile('CB_context.mat',[num2str(TestBabaiName(i)),'.mat'])
end

%--------------------------------------------------------------------------



