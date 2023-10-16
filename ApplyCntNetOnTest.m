% Apply Net On Test
%current directory: Step1-EventLandmark\Programs\MyPrograms\EventExtraction

clc,clear all,close all, fclose all

context=3;
LblLen=36;
thr=0;

load('.\TrainWithCntk\ReadCntkNetworks\Net1.mat');
load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat;
load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat;

LhcbPath='..\..\\SmallFarsdat\LHCB';
LabelPath='..\..\SmallFarsdat\LABEL';
dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;


for j=3:length(dirlbl)
    %-----------------------------
    % Load Feature and Label File:
    load([LabelPath,'\',dirlbl(j).name]); %out:Z
    Name=dirlbl(j).name; Name(1)=[];
    load([LhcbPath,'\LHCB',Name]);%out:CB
    CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT,size(CB,1),1));
    RecognizedBorders=[];
    %----------------------------
    k=0;
    for i=1:size(CB,1)     
        a1=i-2; a2=i+3;
        if a1<1, a1=1; a2=6; end
        if a2>size(CB,1),a1=size(CB,1)-5; a2=size(CB,1); end
        cb1=CB(a1:a2,:);
        cb1=cb1';cb1=cb1(:);
        %Apply Net:
        cb1=(cb1-Mean).*InvStd; %????????????? .* or ./
        out=(W1*logsig(W0*cb1+B0)+B1);
        out1=out(1:LblLen); out2=out(LblLen+1:2*LblLen);
        %Recognized Borders:
        [out1Max,Out1IndexMax]=max(out1);
        [out2Max,Out2IndexMax]=max(out2);
        
        if (out1Max>=thr) && (out2Max>=thr)
            k=k+1;
            RecognizedBorders(1:4,k)=[Out1IndexMax;Out2IndexMax;out1Max;out2Max];
        end
    end
    %------------------
    %if we new events position (oracle)
    load(['.\Events\Event', Name]);
    r=Event(:,1);
    A=RecognizedBorders(1:2,r)== Event(:,2:3)';
    BorderAccuracyOfEachFile=sum((A(1,:)==1) & (A(2,:)==1))/size(Event,1);
    B=RecognizedBorders(1:2,r);
    %------------------
    %Filterning Similar Borders:
    
    %Filtering Similar Phones:
end
