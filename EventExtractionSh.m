%-----------------------------
% Event Extraction
% Shaghayegh Reza
%-----------------------------

clc, clear all, close all

LhcbPath='E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LHCB';
LabelPath='E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LABEL';
% LhcbPath='D:\Shaghayegh\Step1-EventLandmark\EventExtraction\data\LHCBNEW';
% LabelPath='D:\Shaghayegh\Step1-EventLandmark\EventExtraction\data\LBLNEW';

dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;
mkdir('Events');
mkdir('BordersLength');
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
    Z=Z2;
    AA=[AA,j];
    BB=[BB,max(Z2)];
    %-----------------------------
    % Finding  borders
    B=[];
    for  i=1:nz-1
        if(Z(i)~=Z(i+1))  
           B=[B,i];
        end
    end%l
    LenB=length(B);
    %-----------------------------
    Event=[];
    for i=1:LenB
         Event(i,1:3)=[B(i),Z(B(i)),Z(B(i)+1)];
    end
    save(['Events\Event',Name],'Event');
    %-----------------------------
    BorderLength=[];
    for i=1:LenB
        if i>1, LenVaj1=B(i)-B(i-1); else , LenVaj1=B(i); end
        if i<LenB, LenVaj2=B(i+1)-B(i); else, LenVaj2=nz-B(i); end
         BorderLength(i,1:4)=[Z(B(i)),Z(B(i)+1), LenVaj1,LenVaj2];
    end
     save(['BordersLength\BordersLength',Name],'BorderLength');
    %-----------------------------
end %j=3:NumLbl


