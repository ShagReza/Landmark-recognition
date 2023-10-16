
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % This Program is correct just for LabelMethod=1
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
FeatType='melspec'; % melspec or lhcb
FeatType='lhcb64'; % melspec or lhcb
FeatType='lhcbDelta2';
FeatType='lhcb';
%---------------------------------
NumL1=306;
NumL2=276;
eps=0.000001;
%---------------------------------
DataSet={'Train','Test','Val'};
DataSetNames={'TrainBabaiName.mat','TestBabaiName.mat','ValBabaiName.mat'}; %Babaii
%DataSetNames={'SmalFarsdatTrainNames_train.mat','SmalFarsdatTestNames.mat','SmalFarsdatTrainNames_validation.mat'}; %ansari
%DataSetNames={'TrainNames.mat','TestNames.mat','ValNames.mat'}; %Me
%---------------------------------
if strcmp(FeatType , 'lhcb'), SmalFarsdatPath='SmallFarsdat\'; 
elseif strcmp(FeatType , 'melspec'), SmalFarsdatPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras\FeatExtract\MelSpec64'; 
elseif strcmp(FeatType , 'lhcb64'), SmalFarsdatPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LHCB64'; 
elseif strcmp(FeatType , 'lhcbDelta2'), SmalFarsdatPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\lhcbDelta2';
end
%---------------------------------
for nDataSet=1:3
    TrainOrTest=DataSet{nDataSet};
    CB_total=[]; LBL_total=[];
    for context=7 %1:7
        %-------------------------------
        if strcmp(FeatType , 'lhcb'),LhcbPath=[SmalFarsdatPath,'LHCB']; end;
        %---
        if strcmp(FeatType , 'lhcb'),load('VarTotalSmalFarsdat.mat');  varT=VarTotalSmalFarsdat; load('MeanTotalSmalFarsdat.mat'); meanT=MeanTotalSmalFarsdat;
        elseif strcmp(FeatType , 'melspec'),load('VarTotalSmalFarsdat_melspec.mat');  varT=VarTotalSmalFarsdat_melspec; load('MeanTotalSmalFarsdat_melspec.mat'); meanT=MeanTotalSmalFarsdat_melspec;
        elseif strcmp(FeatType , 'lhcb64'),load('VarTotalSmalFarsdat_lhcb64.mat');  varT=VarTotalSmalFarsdat_lhcb64; load('MeanTotalSmalFarsdat_lhcb64.mat'); meanT=MeanTotalSmalFarsdat_lhcb64; 
        elseif strcmp(FeatType , 'lhcbDelta2'), load('VarTotalSmalFarsdat_lhcbDelta2.mat');  varT=VarTotalSmalFarsdat_lhcbDelta2; load('MeanTotalSmalFarsdat_lhcbDelta2.mat'); meanT=MeanTotalSmalFarsdat_lhcbDelta2; end;
        %---
        if strcmp(TrainOrTest , 'Train')
            load(DataSetNames{nDataSet});
            DataNames=TrainBabaiName; %babai
            %DataNames=SmalFarsdatTrainNames_train; %ansari
            %DataNames=TrainNames; %me
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
            DataNames=ValBabaiName; %babai
            %DataNames=SmalFarsdatTrainNames_validation; %ansari
            %DataNames=ValNames; %me
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
            DataNames=TestBabaiName; %babai
            %DataNames=SmalFarsdatTestNames; %ansari
            %DataNames=TestNames; %me
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
        for  i=1:size(DataNames,2)
            i
            %load([LhcbPath,'\LHCB',DataNames{i},'.mat']); %out:CB
            %load(['Landmarks\Landmarks',DataNames{i}]);%BorderLength
            
            if strcmp(FeatType , 'lhcb'),load([LhcbPath,'\LHCB',num2str(DataNames(i)),'.mat']); %out:CB
            elseif strcmp(FeatType , 'melspec'),load([SmalFarsdatPath,'\S',num2str(DataNames(i)),'.mat']);CB=Feat'; 
            elseif strcmp(FeatType , 'lhcb64'),load([SmalFarsdatPath,'\S',num2str(DataNames(i)),'.mat']); 
            elseif strcmp(FeatType , 'lhcbDelta2'),load([SmalFarsdatPath,'\LHCB',num2str(DataNames(i)),'.mat']);
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

                    fprintf(fid,'|features'); fprintf(fidState,'|features'); fprintf(fidEvent,'|features');
                    fprintf(fid,' %f', CBframesWithContext); fprintf(fidState,' %f', CBframesWithContext); fprintf(fidEvent,' %f', CBframesWithContext);
                    CB_t=[CB_t;CBframesWithContext];
                    if LabelMethod==1
                        lbl=[];
                        lbl_1(1:30)=0; %state
                        lbl_2(1:36)=0;%first vaj in border lbl_3(1:36)=0;
                        lbl_3(1:36)=0; %second vaj in border
                        if Landmarks.ScoreOfStates(j)>0, lbl_1(Landmarks.StatesName(j))=Landmarks.ScoreOfStates(j); end
                        if Landmarks.EventScore(j)>0
                            lbl_2(Landmarks.BordersPhones{1,j}{1})=Landmarks.EventScore(j);
                            lbl_3(Landmarks.BordersPhones{1,j}{2})=Landmarks.EventScore(j);
                        end
                        lbl=[lbl_1,lbl_2,lbl_3];
                    elseif LabelMethod==2

                    end
    
                    fprintf(fid,' |labels'); fprintf(fidState,' |labels'); fprintf(fidEvent,' |labels');
                    fprintf(fid,' %d', lbl); fprintf(fidState,' %d',lbl_1); fprintf(fidEvent,' %d', [lbl_2,lbl_3]);
                    
                    if SeperateLabelForNonLandmark==1
                        LBLnonlandmark=0;
                        if EventStateTag{1,j}=='n',LBLnonlandmark=1; end
                        fprintf(fid,' %d', LBLnonlandmark); fprintf(fidState,' %d',LBLnonlandmark); fprintf(fidEvent,' %d', LBLnonlandmark);
                        LBL_t=[LBL_t;[lbl_1,lbl_2,lbl_3,LBLnonlandmark]];
                    end
                    fprintf(fid,'\n'); fprintf(fidState,'\n'); fprintf(fidEvent,'\n');
                end % if EventStateTag(i,1)~='d'
            end % j=1:size(EventStateTag,2)
        CB_total=[CB_total;CB_t];
        LBL_total=[LBL_total;LBL_t];
        end %for  i=1:size(DataNames,2)
        fclose(fid); fclose(fidState); fclose(fidEvent);
    end %for context=0:7
    %---------------------------------------------
    if strcmp(TrainOrTest , 'Train')
        NumTrain=NumData;
        CB_total_train=CB_total; save('CB_total_train','CB_total_train');
        LBL_total_train=LBL_total; save('LBL_total_train','LBL_total_train');
    elseif strcmp(TrainOrTest , 'Val')
        NumVal=NumData;
        CB_total_val=CB_total; save('CB_total_val','CB_total_val');
        LBL_total_val=LBL_total; save('LBL_total_val','LBL_total_val');
    elseif strcmp(TrainOrTest , 'Test')
        NumTest=NumData;
        CB_total_test=CB_total; save('CB_total_test','CB_total_test');
        LBL_total_test=LBL_total; save('LBL_total_test','LBL_total_test');
    end
end %for ndataSet=1:3
%---------------------------------------------------------------------------
%---------------------------------------------------------------------------




% %---------------------------------------------------------------------------
% %---------------------------------------------------------------------------
% % For  Writing Labels in a mat file:
% for nDataSet=1:3
%     TrainOrTest=DataSet{nDataSet};
%     fid=fopen(['LblLandmark_', TrainOrTest,'_All.txt'],'w');
%     fidState=fopen(['LblLandmark_', TrainOrTest,'_State.txt'],'w');
%     fidEvent=fopen(['LblLandmark_', TrainOrTest,'_Event.txt'],'w');
%     %------------------------
%     DataNames=[];
%     if strcmp(TrainOrTest , 'Train')
%         load(DataSetNames{nDataSet});
%         DataNames=SmalFarsdatTrainNames_train;
%         %DataNames=TrainNames;
%     elseif strcmp(TrainOrTest , 'Val')
%         load(DataSetNames{nDataSet});
%         DataNames=SmalFarsdatTrainNames_validation;
%         %DataNames=ValNames;
%     elseif strcmp(TrainOrTest , 'Test')
%         load(DataSetNames{nDataSet});
%         DataNames=SmalFarsdatTestNames;
%         %DataNames=TestNames;
%     end
%     %-----------------------
%     for  i=1:size(DataNames,2)
%         i
%         load(['Landmarks\Landmarks',DataNames{i}]);%BorderLength
%         EventStateTag=Landmarks.EventStateTag_LandmarksType3;
%         for j=1:size(EventStateTag,2)
%             if AllOutOne==1, EventStateTag{2,j}=1; end
%             if EventStateTag{1,j}~='d'
%                 if LabelMethod==1
%                     lbl=[];
%                     lbl_1(1:30)=0; %state
%                     lbl_2(1:36)=0;%first vaj in border lbl_3(1:36)=0;
%                     lbl_3(1:36)=0; %second vaj in border
%                     if Landmarks.ScoreOfStates(j)>0, lbl_1(Landmarks.StatesName(j))=Landmarks.ScoreOfStates(j); end
%                     if Landmarks.EventScore(j)>0
%                         lbl_2(Landmarks.BordersPhones{1,j}{1})=Landmarks.EventScore(j);
%                         lbl_3(Landmarks.BordersPhones{1,j}{2})=Landmarks.EventScore(j);
%                     end
%                     lbl=[lbl_1,lbl_2,lbl_3];
%                 elseif LabelMethod==2
%                         %                     lbl(1:NumL1)=0;
%                         %                     lbl_1(1:30)=0; %state
%                         %                     if EventStateTag{1,j}=='s'
%                         %                         lbl_1(EventStateTag{3,j})=EventStateTag{2,j};
%                         %                         lbl(EventStateTag{3,j})=EventStateTag{2,j};
%                         %                     end
%                         %                     lbl_2(1:NumL2)=0; lbl_3=[];
%                         %                     if EventStateTag{1,j}=='e'
%                         %                         lbl_2(Landmarks.LandmarkType3Name(j)-30)=EventStateTag{2,j};
%                         %                         lbl(Landmarks.LandmarkType3Name(j))=EventStateTag{2,j};
%                         %                     end
%                 end
%                 fprintf(fid,' %d', lbl); fprintf(fidState,' %d',lbl_1); fprintf(fidEvent,' %d', [lbl_2,lbl_3]);
%                 if SeperateLabelForNonLandmark==1
%                         LBLnonlandmark=0;
%                         if EventStateTag{1,j}=='n',LBLnonlandmark=1; end
%                         fprintf(fid,' %d', LBLnonlandmark); fprintf(fidState,' %d',LBLnonlandmark); fprintf(fidEvent,' %d', LBLnonlandmark);
%                 end
%                 fprintf(fid,' \n'); fprintf(fidState,' \n'); fprintf(fidEvent,' \n');
%             end % if EventStateTag(i,1)~='d'
%         end % j=1:size(EventStateTag,2)
%     end %for  i=1:size(DataNames,2)
%     fclose(fid); fclose(fidState);  fclose(fidEvent);
% end
% %---------------------------------------------------------------------------
% %---------------------------------------------------------------------------
