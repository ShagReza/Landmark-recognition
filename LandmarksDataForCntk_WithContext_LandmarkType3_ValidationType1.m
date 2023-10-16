
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
%Writing Tarin and Test and val Data in CNTK format
clc, clear all, fclose all

%---------------------------------
AllOutOne=1; %if set to one, all out will be one
LabelMethod=1; %1 0r 2
SeperateLabelForNonLandmark=1;
%---------------------------------
NumL1=306;
NumL2=276;
mm=0; M=[];

DataSet={'Train','Test','Val'};
DataSetNames={'SmalFarsdatTrainNames_train.mat','SmalFarsdatTestNames.mat','SmalFarsdatTrainNames_validation.mat'};
%DataSetNames={'TrainNames.mat','TestNames.mat','ValNames.mat'};

SmalFarsdatPath='SmallFarsdat\';
for nDataSet=1:3
    TrainOrTest=DataSet{nDataSet};
    for context=7 %1:7
        %-------------------------------
        LhcbPath=[SmalFarsdatPath,'LHCB'];
        %---
        load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat;
        load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat;
        %---
        if strcmp(TrainOrTest , 'Train')
            load(DataSetNames{nDataSet});
            DataNames=SmalFarsdatTrainNames_train;
            %DataNames=TrainNames;
            if LabelMethod==1
                fid=fopen(['TrainLandmarksCntk_LabelFormat1_Context',num2str(context),'.txt'],'w');
                fidState=fopen(['TrainLandmarksCntk_State_LabelFormat1_Context',num2str(context),'.txt'],'w');
                fidEvent=fopen(['TrainLandmarksCntk_Event_LabelFormat1_Context',num2str(context),'.txt'],'w');
            elseif LabelMethod==2
                fid=fopen(['TrainLandmarksCntk_LabelFormat2_Context',num2str(context),'.txt'],'w');
                fidState=fopen(['TrainLandmarksCntk_State_LabelFormat2_Context',num2str(context),'.txt'],'w');
                fidEvent=fopen(['TrainLandmarksCntk_Event_LabelFormat2_Context',num2str(context),'.txt'],'w');
            end
        elseif strcmp(TrainOrTest , 'Val')
            load(DataSetNames{nDataSet});
            DataNames=SmalFarsdatTrainNames_validation;
            %DataNames=ValNames;
            if LabelMethod==1
                fid=fopen(['ValidationLandmarksCntk_LabelFormat1_Context',num2str(context),'.txt'],'w');
                fidState=fopen(['ValidationLandmarksCntk_State_LabelFormat1_Context',num2str(context),'.txt'],'w');
                fidEvent=fopen(['ValidationLandmarksCntk_Event_LabelFormat1_Context',num2str(context),'.txt'],'w');
            elseif LabelMethod==2
                fid=fopen(['ValidationLandmarksCntk_LabelFormat2_Context',num2str(context),'.txt'],'w');
                fidState=fopen(['ValidationLandmarksCntk_State_LabelFormat2_Context',num2str(context),'.txt'],'w');
                fidEvent=fopen(['ValidationLandmarksCntk_Event_LabelFormat2_Context',num2str(context),'.txt'],'w');
            end
        elseif strcmp(TrainOrTest , 'Test')
            load(DataSetNames{nDataSet});
            DataNames=SmalFarsdatTestNames;
            %DataNames=TestNames;
            if LabelMethod==1
                fid=fopen(['TestLandmarksCntk_LabelFormat1_Context',num2str(context),'.txt'],'w');
                fidState=fopen(['TestLandmarksCntk_State_LabelFormat1_Context',num2str(context),'.txt'],'w');
                fidEvent=fopen(['TestLandmarksCntk_Event_LabelFormat1_Context',num2str(context),'.txt'],'w');
            elseif LabelMethod==2
                fid=fopen(['TestLandmarksCntk_LabelFormat2_Context',num2str(context),'.txt'],'w');
                fidState=fopen(['TestLandmarksCntk_State_LabelFormat2_Context',num2str(context),'.txt'],'w');
                fidEvent=fopen(['TestLandmarksCntk_Event_LabelFormat2_Context',num2str(context),'.txt'],'w');

            end
        end
        %-------------------------------
        NumData=0; LBL=[];
        mm=0;
        for  i=1:size(DataNames,2)         
            i
            load([LhcbPath,'\LHCB',DataNames{i},'.mat']); %out:CB
            CB=(CB-repmat(meanT,size(CB,1),1))./(repmat(varT,size(CB,1),1)); %LHCB normalization????????????
            
            load(['Landmarks\Landmarks',DataNames{i}]);%BorderLength
            EventStateTag=Landmarks.EventStateTag_LandmarksType3;
            
            for j=1:size(EventStateTag,2)
                if AllOutOne==1, EventStateTag{2,j}=1; end
                if EventStateTag{1,j}~='d'
                    NumData=NumData+1;
                    CBframe=CB(j,:);
                    
                    a=j-context; if a<1, a=1; end;
                    b=j+context; if b>size(CB,1), b=size(CB,1); end;
                    if a==1, b=a+2*context; end
                    if b==size(CB,1); a= b-2*context; end
                    CBframesWithContext=CB(a:b,:)'; CBframesWithContext=CBframesWithContext(:)';
                    %if size(CBframesWithContext,2)>54, i,j, end;
                    
                    fprintf(fid,'|features'); fprintf(fidState,'|features'); fprintf(fidEvent,'|features');
                    fprintf(fid,' %f', CBframesWithContext); fprintf(fidState,' %f', CBframesWithContext); fprintf(fidEvent,' %f', CBframesWithContext);
                    
                    if LabelMethod==1
                        lbl=[];
                        lbl_1(1:30)=0; %state
                        lbl_2(1:36)=0;%first vaj in border lbl_3(1:36)=0;
                        lbl_3(1:36)=0; %second vaj in border
                        if EventStateTag{1,j}=='s', lbl_1( EventStateTag{3,j})=EventStateTag{2,j};  end;
                        if EventStateTag{1,j}=='e'
                            lbl_2(EventStateTag{3,j}{1,1}{1})=EventStateTag{2,j};
                            lbl_3(EventStateTag{3,j}{1,1}{2})=EventStateTag{2,j};
                        end
                        lbl=[lbl_1,lbl_2,lbl_3];
                    elseif LabelMethod==2
                        lbl(1:NumL1)=0;
                        lbl_1(1:30)=0; %state
                        if EventStateTag{1,j}=='s'
                            lbl_1(EventStateTag{3,j})=EventStateTag{2,j};
                            lbl(EventStateTag{3,j})=EventStateTag{2,j};
                        end
                        lbl_2(1:NumL2)=0; lbl_3=[];
                        if EventStateTag{1,j}=='e',
                            lbl_2(Landmarks.LandmarkType3Name(j)-30)=EventStateTag{2,j};
                            lbl(Landmarks.LandmarkType3Name(j))=EventStateTag{2,j};
                        end
                    end
    
                    fprintf(fid,' |labels'); fprintf(fidState,' |labels'); fprintf(fidEvent,' |labels');
                    fprintf(fid,' %d', lbl); fprintf(fidState,' %d',lbl_1); fprintf(fidEvent,' %d', [lbl_2,lbl_3]);
                    if SeperateLabelForNonLandmark==1
                        LBLnonlandmark=0;
                        if EventStateTag{1,j}=='n',LBLnonlandmark=1; end
                        fprintf(fid,' %d', LBLnonlandmark); fprintf(fidState,' %d',LBLnonlandmark); fprintf(fidEvent,' %d', LBLnonlandmark);
                    end
                    fprintf(fid,'\n'); fprintf(fidState,'\n'); fprintf(fidEvent,'\n');
                    mm=mm+1;
                end % if EventStateTag(i,1)~='d'
            end % j=1:size(EventStateTag,2)
            M(i)=mm;
        end %for  i=1:size(DataNames,2)
        fclose(fid); fclose(fidState); fclose(fidEvent);
    end %for context=0:7
    %---------------------------------------------
    if strcmp(TrainOrTest , 'Train')
        NumTrain=NumData;
    elseif strcmp(TrainOrTest , 'Val')
        NumVal=NumData;
    elseif strcmp(TrainOrTest , 'Test')
        NumTest=NumData;
    end
    IndexTrain=M;
    save('IndexTrain','IndexTrain');
end %for ndataSet=1:3
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------




%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
% For  Writing Labels in a mat file:
for nDataSet=3
    TrainOrTest=DataSet{nDataSet};
    fid=fopen(['LblLandmark_', TrainOrTest,'_All.txt'],'w');
    fidState=fopen(['LblLandmark_', TrainOrTest,'_State.txt'],'w');
    fidEvent=fopen(['LblLandmark_', TrainOrTest,'_Event.txt'],'w');
    %------------------------
    DataNames=[];
    if strcmp(TrainOrTest , 'Train')
        load(DataSetNames{nDataSet});
        DataNames=SmalFarsdatTrainNames_train;
        %DataNames=TrainNames;
    elseif strcmp(TrainOrTest , 'Val')
        load(DataSetNames{nDataSet});
        DataNames=SmalFarsdatTrainNames_validation;
        %DataNames=ValNames;
    elseif strcmp(TrainOrTest , 'Test')
        load(DataSetNames{nDataSet});
        DataNames=SmalFarsdatTestNames;
        %DataNames=TestNames;
    end
    %-----------------------
    for  i=1:size(DataNames,2)
        i
        load(['Landmarks\Landmarks',DataNames{i}]);%BorderLength
        EventStateTag=Landmarks.EventStateTag_LandmarksType3;
        for j=1:size(EventStateTag,2)
            if AllOutOne==1, EventStateTag{2,j}=1; end
            if EventStateTag{1,j}~='d'
                if LabelMethod==1
                    lbl=[];
                    lbl_1(1:30)=0; %state
                    lbl_2(1:36)=0;%first vaj in border lbl_3(1:36)=0;
                    lbl_3(1:36)=0; %second vaj in border
                    if EventStateTag{1,j}=='s', lbl_1( EventStateTag{3,j})=EventStateTag{2,j};  end;
                    if EventStateTag{1,j}=='e'
                        lbl_2(EventStateTag{3,j}{1,1}{1})=EventStateTag{2,j};
                        lbl_3(EventStateTag{3,j}{1,1}{2})=EventStateTag{2,j};
                    end
                    lbl=[lbl_1,lbl_2,lbl_3];
                elseif LabelMethod==2
                    lbl(1:NumL1)=0;
                    lbl_1(1:30)=0; %state
                    if EventStateTag{1,j}=='s'
                        lbl_1(EventStateTag{3,j})=EventStateTag{2,j};
                        lbl(EventStateTag{3,j})=EventStateTag{2,j};
                    end
                    lbl_2(1:NumL2)=0; lbl_3=[];
                    if EventStateTag{1,j}=='e'
                        lbl_2(Landmarks.LandmarkType3Name(j)-30)=EventStateTag{2,j};
                        lbl(Landmarks.LandmarkType3Name(j))=EventStateTag{2,j};
                    end
                end
                fprintf(fid,' %d', lbl); fprintf(fidState,' %d',lbl_1); fprintf(fidEvent,' %d', [lbl_2,lbl_3]);
                if SeperateLabelForNonLandmark==1
                        LBLnonlandmark=0;
                        if EventStateTag{1,j}=='n',LBLnonlandmark=1; end
                        fprintf(fid,' %d', LBLnonlandmark); fprintf(fidState,' %d',LBLnonlandmark); fprintf(fidEvent,' %d', LBLnonlandmark);
                end
                fprintf(fid,' \n'); fprintf(fidState,' \n'); fprintf(fidEvent,' \n');
            end % if EventStateTag(i,1)~='d'
        end % j=1:size(EventStateTag,2)
    end %for  i=1:size(DataNames,2)
    fclose(fid); fclose(fidState);  fclose(fidEvent);
end
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------
