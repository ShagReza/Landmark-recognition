
clc, clear all, close all

LabelPath='SmallFarsdat\LABEL';

dirlbl=dir(LabelPath);
NumLbl=length(dirlbl)-2;
mkdir('Vaj');
xx=0; XX=[]; xx2=0; XX2=[];

for j=3:length(dirlbl)
    j
    %-----------------------------
    Z=[]; Z2=[];
    % Load Feature and Label File:
    load([LabelPath,'\',dirlbl(j).name]); %out:Z
    Name=dirlbl(j).name; Name(1)=[];
  
    
    
    
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
    for i=1:nz
        if (Z(i)==40), Z2(i)=30; end; %silence
        if (Z(i)==38), Z2(i)=18; end;
        if (Z(i)==33), Z2(i)=13; end;
        if (Z(i)==32), Z2(i)=12; end;
        if (Z(i)==37), Z2(i)=17; end;
        if (Z(i)==35), Z2(i)=15; end;
        if (Z(i)==39), Z2(i)=19; end;
        if (Z(i)==42), Z2(i)=19; end;
        if (Z(i)==44), Z2(i)=15; end;
        if (Z(i)==34), Z2(i)=14; end;
        if (Z(i)==36), Z2(i)=16; end;
        if (Z(i)==30), Z2(i)=20; end;
        if (Z(i)==31), Z2(i)=21; end;
        if (Z(i)==41), Z2(i)=19; end;
        if (Z(i)==43), Z2(i)=15; end;       
    end%i
    Z=Z2;
    %-----------------------------------------------------------------------------------
    %-----------------------------------------------------------------------------------
    Vaj=Z;
        save(['Vaj\Vaj',Name],'Vaj');
 
end %j=3:NumLbl


