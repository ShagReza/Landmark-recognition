% Event Extraction
% Shaghayegh Reza

clc
clear all
close all


LhcbPath='F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LHCB';
LabelPath='F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LABEL';

%Converting 44 labels to 30
ZT=[1:29,20 21 12 13 14 15 16 17 18 19 30 19 19 15 15];
CS=['@aeouiylmnrbdqg?ptkj#fvsz$*hx >.'];
consonant=['ylmnrbdqg?ptkj#fvsz$*hx'];%6<ZT
plosive=['bdqg?ptkj#'];%11<ZT<22,
vowell=['@aeoui'];%ZT<7

dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;
event2=[];
event3=[];


for j=3:NumLbl
    %Load Feature and Label File:
    load(['F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LABEL\',dirlbl(j).name]); %out:Z
    Name=dirlbl(j).name; Name(1)=[];
    load(['F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LHCB\LHCB',Name]);%out:CB
    %-----------------------------
    nz=length(Z);
    for i=2:nz
        if Z(i)>44,  'gg', end;
    end%i
    %-----------------------------
    %Finding Number of different ZTs and border of different phonems
    LengthCB=size(CB,1);
    H=[];
    for  l=5:LengthCB-5 %l=1:LengthCB
        if(Z(l)~=Z(l+1))
            H=[H,l];
        end
    end%l
    LH=length(H);
    %-----------------------------
    %finding in each phoneme borders
    for i=1:LH      
        b1=H(i);
        b2=H(i)+1;
        if i==LH
            b3=H(i)+2;
            b4=H(i)+3;
        else
            b3=H(i+1)+1;
        end
        if i==LH-1
            b4=H(i+1)+2;
        elseif i<(LH-1)
            b4=H(i+2)+1;
        end                
        z1=Z(b1);
        z2=Z(b2);
        z3=Z(b3);
        z4=Z(b4);
    end %for i=1:LH
end %j=3:NumLbl


