%-----------------------------
% Event Extraction
% Shaghayegh Reza
%-----------------------------

clc, clear all, close all

LhcbPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LHCB';
LabelPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LABEL';
% LhcbPath='D:\Shaghayegh\Step1-EventLandmark\EventExtraction\data\LHCBNEW';
% LabelPath='D:\Shaghayegh\Step1-EventLandmark\EventExtraction\data\LBLNEW';

dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;
AA=[];BB=[];
for j=3:length(dirlbl)
    %-----------------------------
    Z=[]; Z2=[];
    % Load Feature and Label File:
    load([LabelPath,'\',dirlbl(j).name]); %out:Z
    Name=dirlbl(j).name; Name(1)=[];
    load([LhcbPath,'\LHCB',Name]);%out:CB
    %-----------------------------
    % Changing 44 phonetic Labels to 31
    nz=length(Z);
    %     for i=1:nz
    %         if (Z(i)>44 && i>1), Z(i)=Z(i-1); end;  % emit label number 89 (maybe I should do something else!!!!)
    %         if (Z(i)>44 && i==1), Z(i)=Z(end); end; % emit label number 89
    %         if (Z(i)>29 && Z(i)<40), Z(i)=30; end; %closure of plosives
    %         if (Z(i)==40), Z(i)=31; end; %silence
    %         if (Z(i)==42 || Z(i)==44), Z(i)=30; end; %closure of plosives
    %         if (Z(i)==41), Z(i)=19; end; %vajgoone k
    %         if (Z(i)==43), Z(i)=15; end; %vajgoone g
    %     end%i
    %----------------
    Z2=Z;
    for i=1:nz
        if (Z(i)>44 && i>1), Z2(i)=Z(i-1); end;  % emit label number 89 (maybe I should do something else!!!!)
        if (Z(i)>44 && i==1), Z2(i)=Z(end); end; % emit label number 89
    end
    for i=1:nz % if label 89 is two frames
        if (Z2(i)>44 && i>1), Z2(i)=Z2(i-1); end; 
    end
    Z=Z2;
    for i=1:nz
        if (Z(i)==40), Z2(i)=30; end; %silence
        if (Z(i)==38 || Z(i)==33), Z2(i)=31; end; %closure of plosives t % d
        if (Z(i)==32 || Z(i)==37), Z2(i)=32; end; %closure of plosives b % p
        if (Z(i)==35 || Z(i)==39 || Z(i)==42 || Z(i)==44), Z2(i)=33; end; %closure of plosives k & g
        if (Z(i)==34), Z2(i)=34; end; %closure of plosives t % d
        if (Z(i)==36), Z2(i)=35; end; %closure of plosives t % d
        if (Z(i)==30 || Z(i)==31), Z2(i)=36; end; %closure of plosives t % d
        if (Z(i)==41), Z2(i)=19; end; %vajgoone k
        if (Z(i)==43), Z2(i)=15; end; %vajgoone g
    end%i
    %----------------
    Z36=Z2;

     save(['D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\36Labels\36Labels_',Name],'Z36');
    %-----------------------------
end %j=3:NumLbl


