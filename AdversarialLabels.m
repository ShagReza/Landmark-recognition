
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % based on this program:
    %  LandmarksDataForCntk_WithContext_LandmarkType3_ValType1_SoftLabels.m
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%Writing Tarin and Test and val Data in CNTK format
clc, clear all, fclose all
%---------------------------------
AllOutOne=1; %if set to one, all out will be one
LabelMethod=1; %1 0r 2
SeperateLabelForNonLandmark=1;
MeanVarNorm=4; %1:global, 2:each speaker, 3: 3 second, 4:std
%data='babaii'   note!!!!!!!!!!!!!!!!!!!
FeatType='lhcb';
%---------------------------------
NumL1=306;
NumL2=276;
eps=0.000001;
%---------------------------------
Genderlabel=load('Genderlabel'); Genderlabel=Genderlabel.Genderlabel;
%---------------------------------
DataSet={'Train','Test','Val'};
DataSetNames={'TrainBabaiName.mat','TestBabaiName.mat','ValBabaiName.mat'}; %Babaii
%---------------------------------
if strcmp(FeatType , 'lhcb'), SmalFarsdatPath='SmallFarsdat\'; end
%---------------------------------
Gender=[];
SpeakerNum=[];
for nDataSet=1:3
    TrainOrTest=DataSet{nDataSet};
    CB_total=[]; LBL_total=[];
    for context=7 %1:7
        %-------------------------------
        if strcmp(FeatType , 'lhcb'),LhcbPath=[SmalFarsdatPath,'LHCB']; end;
        if strcmp(FeatType , 'lhcb'),load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat; load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat; end

        %-----
        if strcmp(TrainOrTest , 'Train')
            load(DataSetNames{nDataSet});
            DataNames=TrainBabaiName; %babai
        elseif strcmp(TrainOrTest , 'Val')
            load(DataSetNames{nDataSet});
            DataNames=ValBabaiName; %babai
        elseif strcmp(TrainOrTest , 'Test')
            load(DataSetNames{nDataSet});
            DataNames=TestBabaiName; %babai
        end
        %-------------------------------
        NumData=0; LBL=[];
        for  i=1:size(DataNames,2)
            i
            if strcmp(FeatType , 'lhcb'),load([LhcbPath,'\LHCB',num2str(DataNames(i)),'.mat']); %out:CB
            end;
            load(['Landmarks\Landmarks',num2str(DataNames(i))]);%BorderLength
            %MinF=min(size(Feat,2),);
            
          
            if MeanVarNorm==1
                CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT+eps,size(CB,1),1)); %LHCB normalization????????????
            elseif MeanVarNorm==4
                CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(sqrt(varT)+eps,size(CB,1),1)); %LHCB normalization????????????      
            elseif MeanVarNorm==2
                Vajs=Landmarks.labels;
                IndexMinus30=find(Vajs~=30);
                meanT=mean(CB(IndexMinus30,:));
                varT=var(CB(IndexMinus30,:));
                CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT+eps,size(CB,1),1));
            elseif MeanVarNorm==3
                Vajs=Landmarks.labels;
                IndexMinus30=find(Vajs~=30);
                CB2=CB;
                for h=1:length(IndexMinus30)
                    [SortOut,SortIndex]=sort(abs(IndexMinus30(h)-IndexMinus30));
                    SelectedFrames=CB(IndexMinus30(SortIndex(2:301)),:); %nearest non silent frames
                    meanT=mean(SelectedFrames);
                    varT=var(SelectedFrames);
                    CB2(IndexMinus30(h),:)=(CB(IndexMinus30(h),:)-meanT)./(varT+eps);
                end
                Index30=find(Vajs==30);
                for h=1:length(Index30)
                    [SortOut,SortIndex]=sort(abs(Index30(h)-Index30));
                    if length(Index30)<301, LL=length(Index30);
                    else, LL=301; end      
                    SelectedFrames=CB(Index30(SortIndex(2:LL)),:); %nearest non silent frames
                    meanT=mean(SelectedFrames);
                    varT=var(SelectedFrames);
                    CB2(Index30(h),:)=(CB(Index30(h),:)-meanT)./(varT+eps);
                end
                CB=CB2;
            end
            
            EventStateTag=Landmarks.EventStateTag_LandmarksType3;
            CB_t=[];LBL_t=[];
            for j=1:size(EventStateTag,2)
                if AllOutOne==1, EventStateTag{2,j}=1; end
                if EventStateTag{1,j}~='d' && j<=size(CB,1)
                    NumData=NumData+1;
                    CBframe=CB(j,:);
                    
                    a=j-context; if a<1, a=1; end;
                    b=j+context; if b>size(CB,1), b=size(CB,1); end;
                    if a==1, b=a+2*context; end
                    if b==size(CB,1); a= b-2*context; end
                    
                    CBframesWithContext=CB(a:b,:)'; CBframesWithContext=CBframesWithContext(:)';
                    CB_t=[CB_t;CBframesWithContext];

                end % if EventStateTag(i,1)~='d'
            end % j=1:size(EventStateTag,2)
        %CB_total=[CB_total;CB_t];
        D=DataNames(i); D=num2str(D); D(1)=[]; D=str2num(D);
        L=size(CB_t,1);
        G=[]; G(1:L)=Genderlabel(D);
        S=[]; S(1:L)=D;
        Gender=[Gender,G];
        SpeakerNum=[SpeakerNum,S];
        end %for  i=1:size(DataNames,2)
      
    end %for context=0:7
    %---------------------------------------------
    if strcmp(TrainOrTest , 'Train')
        Gender_train=Gender; save('Gender_train','Gender_train');
        SpeakerNum_train=SpeakerNum; save('SpeakerNum_train','SpeakerNum_train');
    elseif strcmp(TrainOrTest , 'Val')
        Gender_val=Gender; save('Gender_val','Gender_val');
        SpeakerNum_val=SpeakerNum; save('SpeakerNum_val','SpeakerNum_val');
    elseif strcmp(TrainOrTest , 'Test')
        Gender_test=Gender; save('Gender_test','Gender_test');
        SpeakerNum_test=SpeakerNum; save('SpeakerNum_test','SpeakerNum_test');
    end
end %for ndataSet=1:3
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------



