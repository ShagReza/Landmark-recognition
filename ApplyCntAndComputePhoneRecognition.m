% Apply Net On Test and Compute Recognition rate
%current directory: Step1-EventLandmark\Programs\MyPrograms\EventExtraction

clc,clear all,close all, fclose all

context=3;
LblLen=36;
Thr2=0.1;
Thr3=0.5;
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
%     for i=2:size(CB,1)
%         deltaCB(
%     end


    %----------------------------------------------------------------------
    %if we knew events position (oracle)
    load(['.\Events\Event', Name]);
    r=Event(:,1);
    A=RecognizedBorders(1:2,r)== Event(:,2:3)';
    BorderAccuracyOfEachFile=sum((A(1,:)==1) & (A(2,:)==1))/size(Event,1);
    B=RecognizedBorders(1:2,r);
    %continue!!!!
    %----------------------------------------------------------------------
    
    
    
    %----------------------------------------------------------------------
    %if we don't khnow events position:
    %Filterning Similar Borders:
    k=1; RecognizedBorders2=[];
    RecognizedBorders2(1:4,1)=RecognizedBorders(1:4,1);
    for i=2:size(RecognizedBorders,2)
        if RecognizedBorders2(1:2,k)==RecognizedBorders(1:2,i) % Same Borther
            if RecognizedBorders(3:4,i)>RecognizedBorders2(3:4,k) % From same borders, save the one with the biggest score
               RecognizedBorders2(3:4,k) =RecognizedBorders(3:4,i);
            end     
        elseif (RecognizedBorders(3:4,i)>=Thr2)   &   (RecognizedBorders(3,i)>Thr3  | RecognizedBorders(4,i)>Thr3)   
            %-----------------------------------------
            % Rule1: emit VV borders
            Rule1=(RecognizedBorders(1,i)<7) & (RecognizedBorders(2,i)<7); 
            %-----------------------------------------
            % Rule 2: Phones of a border can't be equal
            Rule2=(RecognizedBorders(1,i)~= RecognizedBorders(2,i)); 
            %-----------------------------------------
            % Rule3: Emit Bast Bust Border
            Rule3=0;
            if ((RecognizedBorders(1,i)==31) && (RecognizedBorders(2,i)==13 || RecognizedBorders(2,i)== 18)) , Rule3=1; end
            if ((RecognizedBorders(1,i)==32) && (RecognizedBorders(2,i)==12 || RecognizedBorders(2,i)== 17)) , Rule3=1; end
            if ((RecognizedBorders(1,i)==33) && (RecognizedBorders(2,i)==15 || RecognizedBorders(2,i)== 19)) , Rule3=1; end
            if ((RecognizedBorders(1,i)==34) && (RecognizedBorders(2,i)==14)) , Rule3=1; end
            if ((RecognizedBorders(1,i)==35) && (RecognizedBorders(2,i)==16)) , Rule3=1; end
            if ((RecognizedBorders(1,i)==36) && (RecognizedBorders(2,i)==20 || RecognizedBorders(2,i)== 21)) , Rule3=1; end
            if ((RecognizedBorders(1,i)<37) && (RecognizedBorders(1,i)>30) && (RecognizedBorders(2,i)<22) && (RecognizedBorders(2,i)>11)), Rule3=1; end
                 
            %-----------------------------------------
            if Rule2 & ~Rule1 & ~Rule3
            k=k+1;
            RecognizedBorders2(1:4,k)=RecognizedBorders(1:4,i);   
            end
        end
    end
    %----------------------------------------------------------------------
    
    
    
    
    %----------------------------------------------------------------------
    RecognizedBorders3=RecognizedBorders2;
    sequence=[];
    i=1;
    if (RecognizedBorders2(1,i)==30 || RecognizedBorders2(2,i)==30) && (RecognizedBorders2(1,i+1)==30 || RecognizedBorders2(2,i+1)==30) 
        RecognizedBorders3(5,i)=30;
    end
    
    i=size(RecognizedBorders2,2);
   if (RecognizedBorders2(1,i)==30 || RecognizedBorders2(2,i)==30) && (RecognizedBorders2(1,i-1)==30 || RecognizedBorders2(2,i-1)==30) 
        RecognizedBorders3(5,i)=30;
    end

    
    for i=2:size(RecognizedBorders2,2)-1
        %sokoot
        s=0;
        if (RecognizedBorders2(1,i)==30 || RecognizedBorders2(2,i)==30) && (RecognizedBorders2(1,i+1)==30 || RecognizedBorders2(2,i+1)==30)  && (RecognizedBorders2(1,i-1)==30 || RecognizedBorders2(2,i-1)==30)
            RecognizedBorders3(5,i)=30;
            s=1;
        end
         if (RecognizedBorders2(1,i)==30 && (RecognizedBorders2(1,i-1)~=30 && RecognizedBorders2(2,i-1)~=30))
             if (RecognizedBorders2(1,i+1)==30 || RecognizedBorders2(2,i+1)==30)
                 RecognizedBorders3(5,i)=30;
             else
                RecognizedBorders3(5,i)=-100; 
             end
             s=1;
         end
         if s==0
             RecognizedBorders3(5,i)=RecognizedBorders3(1,i);
         end
    end
    
    %     % correct it!
    %     j=1;
    %     sequenc(j)=RecognizedBorders3(5,1);
    %     for i=2:size(RecognizedBorders3,2)
    %         if RecognizedBorders3(5,i)~=sequenc(j)
    %             j=j+1;
    %             sequenc(j)=RecognizedBorders3(5,i);
    %         end
    %     end
    %----------------------------------------------------------------------
    %Filtering Similar Phones:
end
