
clc, clear all, close all

LhcbPath='SmallFarsdat\LHCB';
LabelPath='SmallFarsdat\LABEL';

dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;
mkdir('Landmarks');
xx=0; XX=[]; xx2=0; XX2=[];

for j=3:length(dirlbl)
    j
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
    
    
    
    
    %----------------------------------------------------------------------
                 % Changing 44 phonetic Labels to 36
    %----------------------------------------------------------------------
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
    Z3=Z;
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
    Z=Z2;
    %-----------------------------------------------------------------------------------
    %-----------------------------------------------------------------------------------
    
    
    
    %-----------------------------------------------------------------------------------
                            % States:
    %---------------------------------------------------------------------------
    %Delete Bast Labels
    Z4=Z3;
    for i=1:nz
        if (Z3(i)==40), Z4(i)=30; end; %silence
        if (Z3(i)==31), Z4(i)=20; end;
        if (Z3(i)==32), Z4(i)=12; end;
        if (Z3(i)==33), Z4(i)=13; end;
        if (Z3(i)==34), Z4(i)=14; end;
        if (Z3(i)==35), Z4(i)=15; end;
        if (Z3(i)==36), Z4(i)=16; end;
        if (Z3(i)==37), Z4(i)=17; end;
        if (Z3(i)==38), Z4(i)=18; end;
        if (Z3(i)==39), Z4(i)=19; end;
        if (Z3(i)==41), Z4(i)=19; end;
        if (Z3(i)==42), Z4(i)=19; end;
        if (Z3(i)==43), Z4(i)=15; end;
        if (Z3(i)==44), Z4(i)=15; end;
    end%i
    %-----------------------
    % Finding  borders
    B=[];
    for  i=1:nz-1
        if(Z4(i)~=Z4(i+1))
            B=[B,i];
        end
    end%l
    LenB=length(B);
    %-------------------------
    % Compute State Scores
    Landmarks=[]; labels=[]; ScoreOfStates=[]; StatesName=[];
    ScrState=[];
    C=[0,B,nz]; LenC=length(C);
    StatePosition=[];
    State=[]; StatesName=[];
    for i=1:LenC-1
        StatePosition(i)=C(i)+((C(i+1)-C(i)+1)/2);
        LenState=C(i+1)-C(i);
        % if silence is too big, we train just 10 frames of it with
        % statescore=1 to avoid overtraining on it:
        BigSilence=LenState>=20 && Z(C(i+1))==30;
        
%                 if LenState<=2 
%                     if (Z(C(i+1))<12) || (Z(C(i+1))>21 && Z(C(i+1))<30)
%                         XX=[XX,Z(C(i+1))];
%                         xx=xx+1;
%                     end
%                 end
                
                if LenState<=1 
                    if (Z(C(i+1))<12) || (Z(C(i+1))>21 && Z(C(i+1))<30)
                        %XX2=[XX2,Z(C(i+1))];
                        XX2=[XX2;[Z(C(i)),Z(C(i+1)),Z(C(i+2))]];
                        %Z(C(i)),Z(C(i+1)),Z(C(i+2));
                        xx2=xx2+1;
                    end
                end
        
        if LenState>2 && (~BigSilence)
            ScrStep=1/floor((LenState-1)/2);
            a1=[]; a2=[];
            a1=0:ScrStep:1; a2=1:-1*ScrStep:0; a1(end)=[];
            if  mod(LenState,2)==0, a1=[0,a1]; end
            ScrState=[ScrState,a1,a2];
        end
        if LenState<=2 %phonese which are 1 or 2 frames won't be trained as states
            %a1=[]; a1(1: LenState)=0;
            a1=[]; a1(1: LenState)=-100; % -100 means: don't train it as state
            ScrState=[ScrState,a1];
        end
        if  BigSilence
            %a1=[]; a1(1:LenState)=0;
            a1=[]; a1(1: LenState)=-100; % -100 means: don't train it as state
            a3=floor(LenState/2);
            a1(a3-5:a3+5)=1;
            ScrState=[ScrState,a1];
        end
        State=[]; State(1:LenState)=Z4(C(i+1));
        StatesName=[StatesName,State];
    end
    Landmarks.labels(1,:)=Z; %labels
    Landmarks.ScoreOfStates=ScrState; %State Scores
    Landmarks.StatesName=StatesName; %State Scores
    
    %---------------------------------------------------------------------------
    %---------------------------------------------------------------------------
    
    
    
    
    %---------------------------------------------------------------------------
                                % Events:
    %---------------------------------------------------------------------------
    EventScore=[]; BordersPhones=[];
    Event=[]; EventScore(1:nz)=0;
    for i=1:LenB
        S= (B(i)+3 > nz) || (B(i)-1<1);
        if S==0
            Event(i,1:3)=[B(i),Z(B(i)),Z(B(i)+1)];
            %EventScore(B(i))=1;
            %BordersPhones{B(i)}={Z(B(i)),Z(B(i)+1)};
            EventScore(B(i)+1)=1;
            BordersPhones{B(i)+1}={Z(B(i)),Z(B(i)+1)};
            if EventScore(B(i)+2)<0.7, EventScore(B(i)+2)=0.7; BordersPhones{B(i)+2}={Z(B(i)),Z(B(i)+1)};end
            if EventScore(B(i)+3)<0.3, EventScore(B(i)+3)=0.3; BordersPhones{B(i)+3}={Z(B(i)),Z(B(i)+1)}; end
            if EventScore(B(i))<0.7, EventScore(B(i))=0.7; BordersPhones{B(i)}={Z(B(i)),Z(B(i)+1)};end
            if EventScore(B(i)-1)<0.3, EventScore(B(i)-1)=0.3; BordersPhones{B(i)-1}={Z(B(i)),Z(B(i)+1)};end    
        end
    end
    BordersPhones{nz}=[];
    Landmarks.EventScore=EventScore;
    Landmarks.BordersPhones=BordersPhones;
    %---------------------------------------------------------------------------
    %---------------------------------------------------------------------------
    
    
    
    
    %-----------------------------------------------------------------------------
                                 % EventStateTag:
                % 'e' for event, 's' for state and 'n' for non of them and
                % 'd' for frames which should be emited from train data
    %-----------------------------------------------------------------------------
    EventStateTag=[];
    for i=1:nz
        E=0;
        EventStateTag{1,i}='n';
        EventStateTag{2,i}=0;
        if EventScore(i)>0
            EventStateTag{1,i}='e';
            EventStateTag{2,i}=EventScore(i);
            EventStateTag{3,i}=BordersPhones(i); %cell2mat(EventStateTag{3,269}{1,1})
            E=1;
        end
        if ScrState(i)>EventScore(i) &&  ScrState(i)>0.5
            EventStateTag{1,i}='s';
            EventStateTag{2,i}=ScrState(i);
            EventStateTag{3,i}=StatesName(i);
        end
        if ScrState(i)==-100 &&  E==0
            EventStateTag{1,i}='d';
            EventStateTag{2,i}=-100;
        end        
    end
    Landmarks.EventStateTag=EventStateTag;
    %---------------------------------------------------------------------------
    %---------------------------------------------------------------------------
    
    
    save(['Landmarks\Landmarks',Name],'Landmarks');

    
end %j=3:NumLbl


