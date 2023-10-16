
% 
% load('E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LHCB\LHCB11.MAT')
% load('E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LABEL\Z11.mat')
%  
% lcb=size(CB,1);
% lcb2=size(CB,2);
% MCB=mean(CB,2);
% CB=CB-mean(CB,2)*ones(1,18);%DC cancellation
% DE=MCB(2:lcb)-MCB(1:lcb-1);
% 
% %norm of diffrence:
% dmcb=CB(2:lcb,:)-CB(1:lcb-1,:);%(lcb-1)*18
% DMCB=sqrt(sum((dmcb.*dmcb)'));%length of diffrence vector
% DMCB2=DMCB'.*MCB(1:lcb-1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d1=CB(3:lcb,:)-CB(2:lcb-1,:);
% dd1=sqrt(sum((d1.*d1)'));%similaritty with next 
% dd1=[0,dd1];
% 
% d2=CB(2:lcb-1,:)-CB(1:lcb-2,:);
% dd2=sqrt(sum((d2.*d2)'));%similaritty with befor 
% dd2=[0,dd2];
% 
% dm12=(dd1+dd2)/2;%mean of similarity with two adjacent
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% plot(DE),hold on,plot(DMCB,'r')
% hold on,plot(dm12,'g')
% hold on,plot(Z(1,1:2421),'g')




%-----------------------------
% Event Extraction (Corrected with Delta LHCB)
% Shaghayegh Reza
%-----------------------------

clc, clear all, close all

LhcbPath='E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LHCB';
LabelPath='E:\Shaghayegh\Step1-EventLandmark\Programs\SmallFarsdat\LABEL';

dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;
mkdir('EventsCorrectedWithDeltaLhcb');
mkdir('BordersLengthCorrectedWithDeltaLhcb');
mkdir('StatesPosition');
mkdir('EventState');

AA=[];BB=[];
for j=3:length(dirlbl)
    %-----------------------------
    Z=[]; Z2=[];
    % Load Feature and Label File:
    load([LabelPath,'\',dirlbl(j).name]); %out:Z
    Name=dirlbl(j).name; Name(1)=[];
    load([LhcbPath,'\LHCB',Name]);%out:CB
    %-----------------------------
    %Delta LHCB
    CB=CB-mean(CB,2)*ones(1,18);%DC cancellation
    dmcb=CB(2:size(CB,1),:)-CB(1:size(CB,1)-1,:);%(lcb-1)*18
    DMCB=sqrt(sum((dmcb.*dmcb)'));%length of diffrence vector
    %-----------------------------
    % Changing 44 phonetic Labels to 36
    nz=length(Z);
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
    C=[1,B,nz]; LenC=length(C);
    StatePosition=[];
    for i=1:LenC-1
         StatePosition(i)=floor(C(i)+((C(i+1)-C(i))/2));
    end
    save(['StatesPosition\StatePosition',Name],'StatePosition');
    %-----------------------------
     Event=[];
    for i=1:LenB
         Event(i,1:3)=[B(i),Z(B(i)),Z(B(i)+1)];
    end
    save(['Events\Event',Name],'Event');
    %--------------------------------------
    IndxMaxDMCB=[];
    for i=1:LenC-2
        [MaxDMCB,IndxMax]=max(DMCB(StatePosition(i):StatePosition(i+1)));
        IndxMaxDMCB(i)=IndxMax+StatePosition(i)-1;
    end
    EventNew=[];
    for i=1:LenB
         EventNew(i,1:3)=[IndxMaxDMCB(i),Z(B(i)),Z(B(i)+1)];
    end
    save(['EventsCorrectedWithDeltaLhcb\EventNew',Name],'EventNew');
    %-----------------------------
    EventState=[];
    k=0;
    for i=1:LenB
        k=k+1;
        EventState{1,k}=StatePosition(i); EventState{2,k}='s';
        k=k+1;
        EventState{1,k}=IndxMaxDMCB(i); EventState{2,k}='e';
        EventState{3,k}=Event(i,1);
    end
    k=k+1; i=i+1;
    EventState{1,k}=StatePosition(i); EventState{2,k}='s';
    save(['EventState\EventState',Name],'EventState');
    %-----------------------------
    %     BorderLength=[];
    %     for i=1:LenB
    %         if i>1, LenVaj1=B(i)-B(i-1); else , LenVaj1=B(i); end
    %         if i<LenB, LenVaj2=B(i+1)-B(i); else, LenVaj2=nz-B(i); end
    %          BorderLength(i,1:4)=[Z(B(i)),Z(B(i)+1), LenVaj1,LenVaj2];
    %     end
    %      save(['BordersLengthCorrectedWithDeltaLhcb\BordersLength',Name],'BorderLength');
    %-----------------------------
end %j=3:NumLbl


