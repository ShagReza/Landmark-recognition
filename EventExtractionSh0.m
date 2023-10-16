%-----------------------------
% Event Extraction
% Shaghayegh Reza
%-----------------------------

clc, clear all, close all

LhcbPath='F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LHCB';
LabelPath='F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LABEL';
dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;

for j=3:NumLbl
    %-----------------------------
    % Load Feature and Label File:
    load(['F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LABEL\',dirlbl(j).name]); %out:Z
    Name=dirlbl(j).name; Name(1)=[];
    load(['F:\MyPHDThesis\AfterPropozal\Step1-EventLandmark\Programs\SmallFarsdat\LHCB\LHCB',Name]);%out:CB
    %-----------------------------
    % Changing 44 phonetic Labels to 31
    nz=length(Z);
    for i=1:nz
        if (Z(i)>44 && i>1), Z(i)=Z(i-1); end;
        if (Z(i)>44 && i==1), Z(i)=Z(end); end;
        if (Z(i)>29 && Z(i)<40), Z(i)=30; end; %closure of plosives
        if (Z(i)==40), Z(i)=31; end; %silence
        if (Z(i)==42 ||Z(i)==44), Z(i)=30; end; %closure of plosives
        if (Z(i)==41), Z(i)=19; end; %vajgoone k
        if (Z(i)==43), Z(i)=15; end; %vajgoone g
    end%i
    %-----------------------------
    % Finding  borders
    B=[];
    for  i=i:nz-1
        if(Z(i)~=Z(i+1))  
           B=[B,l];
        end
    end%l
    LenB=length(B);
    %-----------------------------
    for i=1:LenB
         Event=[B(i),Z(B(i)),Z(B(i)+1),,];
    end
    %-----------------------------
end %j=3:NumLbl


