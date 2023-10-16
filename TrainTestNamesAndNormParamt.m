% TrainTestNames and NormalizationParameters

%--------------------------------------------------------
SmalFarsdatTrainNames=[];
for i=1:297
    SmalFarsdatTrainNames{i}=['1',num2str(i)];
end
for i=1:297
    SmalFarsdatTrainNames{i+297}=['2',num2str(i)];
end
save('SmalFarsdatTrainNames','SmalFarsdatTrainNames');
%--------------------------------------------------------




%--------------------------------------------------------
SmalFarsdatTestNames=[];
j=0;
for i=298:304
    j=j+1;
    SmalFarsdatTestNames{j}=['1',num2str(i)];
end
for i=298:304
    j=j+1;
    SmalFarsdatTestNames{j}=['2',num2str(i)];
end
save('SmalFarsdatTestNames','SmalFarsdatTestNames');
%--------------------------------------------------------




%--------------------------------------------------------
LhcbPath='E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LHCB';
load('SmalFarsdatTrainNames.mat')
MeanTrainSmalFarsdat=[];
VarTrainSmalFarsdat=[];
for i=1:size(SmalFarsdatTrainNames,2)
    path=[LhcbPath,'\LHCB',SmalFarsdatTrainNames{i},'.mat'];
    load(path);
    MeanTrainSmalFarsdat{i}=mean(CB);
    VarTrainSmalFarsdat{i}=var(CB);
end
save('MeanTrainSmalFarsdat','MeanTrainSmalFarsdat');
save('VarTrainSmalFarsdat','VarTrainSmalFarsdat');

TCB=[];
for i=1:size(SmalFarsdatTrainNames,2)
    i
    path=[LhcbPath,'\LHCB',SmalFarsdatTrainNames{i},'.mat'];
    load(path);
    TCB=[TCB;CB];
end
MeanTotalSmalFarsdat=mean(TCB);
VarTotalSmalFarsdat=var(TCB);
save('MeanTotalSmalFarsdat','MeanTotalSmalFarsdat');
save('VarTotalSmalFarsdat','VarTotalSmalFarsdat');
%--------------------------------------------------------







%--------------------------------------------------------
% mean and var for melspec
FeatPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras\FeatExtract\MelSpec64';
load('SmalFarsdatTrainNames.mat')
Tfeat=[];
for i=1:size(SmalFarsdatTrainNames,2)
    i
    path=[FeatPath,'\S',SmalFarsdatTrainNames{i},'.mat'];
    load(path);
    Tfeat=[Tfeat;Feat'];
end
MeanTotalSmalFarsdat_melspec=mean(Tfeat);
VarTotalSmalFarsdat_melspec=var(Tfeat);
save('MeanTotalSmalFarsdat_melspec','MeanTotalSmalFarsdat_melspec');
save('VarTotalSmalFarsdat_melspec','VarTotalSmalFarsdat_melspec');
%--------------------------------------------------------






%--------------------------------------------------------
% mean and var for lhcb64
FeatPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LHCB64';
load('SmalFarsdatTrainNames.mat')
Tfeat=[];
for i=1:size(SmalFarsdatTrainNames,2)
    i
    path=[FeatPath,'\S',SmalFarsdatTrainNames{i},'.mat'];
    load(path);
    Tfeat=[Tfeat;CB];
end
MeanTotalSmalFarsdat_lhcb64=mean(Tfeat);
VarTotalSmalFarsdat_lhcb64=var(Tfeat);
save('MeanTotalSmalFarsdat_lhcb64','MeanTotalSmalFarsdat_lhcb64');
save('VarTotalSmalFarsdat_lhcb64','VarTotalSmalFarsdat_lhcb64');
%--------------------------------------------------------




%--------------------------------------------------------
% mean and var for MfccDelta2
FeatPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LhcbPlusDelta';
load('SmalFarsdatTrainNames.mat')
Tfeat=[];
for i=1:size(SmalFarsdatTrainNames,2)
    i
    path=[FeatPath,'\LHCB',SmalFarsdatTrainNames{i},'.mat'];
    load(path);
    Tfeat=[Tfeat;CB];
end
MeanTotalSmalFarsdat_lhcbDelta2=mean(Tfeat);
VarTotalSmalFarsdat_lhcbDelta2=var(Tfeat);
save('MeanTotalSmalFarsdat_lhcbDelta2','MeanTotalSmalFarsdat_MfccDelta2');
save('VarTotalSmalFarsdat_lhcbDelta2','VarTotalSmalFarsdat_MfccDelta2');
%--------------------------------------------------------




