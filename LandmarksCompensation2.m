%----------------------------------------------------------------------
clc,clear all,close all
path='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras';

LBL_train=load([path,'\LBL_total_train.mat']);
LBL_train=LBL_train.LBL_total_train;

CB_train=load([path,'\CB_total_train.mat']);
CB_train=CB_train.CB_total_train;

A=find(LBL_train>0.5);
LBL_train(A)=1;

train_predict=load('D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras\train_predict.mat')
train_predict=train_predict.lbl;

load('FinalLandmarkCode');
%----------------------------------------------------------------------




%---------------------------------------------------------------------
CBtrain_Out_Comp2=[];
CBtrain_In_Comp2=[];
LBL_out_Comp2=[];
IndexLandmarksTotal=[];
for i=1:313
    i
    % step 1: find landmark=i in train labels and their output
    k=0;
    OutputLandmarkI=[]; CBLanmarkI=[]; IndexLandmarks=[];
    for j=1:size(LBL_train,1)
        if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
            k=k+1;
            OutputLandmarkI(k,:)=train_predict(j,:);
            CBLanmarkI(k,:)=CB_train(j,:);
            IndexLandmarks=[IndexLandmarks,j];
        end
    end
    IndexLandmarksTotal=[IndexLandmarksTotal,IndexLandmarks];
    % step 2: find the ones with correct output 
    LBLoutI=[]; k=0; x=0; CorrectRecLandmarkI=[]; FalseRecLandmarkI=[];
    for j=1:size(OutputLandmarkI,1)
        LBLout(1:103)=0;
        Out=OutputLandmarkI(j,:);
        [a,b]=max(Out);
        if (b<31 || b==103), LBLout(b)=1;
        else
            [c1,c2]=max(Out(31:66)); [d1,d2]=max(Out(67:102));
            LBLout(30+c2)=1;   LBLout(66+d2)=1;
        end
        if isequal(LBLout,FinalLandmarkCode(i,:))
            k=k+1;
            CorrectRecLandmarkI(k,:)=CBLanmarkI(j,:);
        else
            x=x+1;
            FalseRecLandmarkI(x,:)=CBLanmarkI(j,:);
        end
        LBLoutI(j,:)=LBLout;
    end
    
    % step 3: for false recognized data put nearest true recognized as output
    if size(IndexLandmarks,1)>0
        if size(CorrectRecLandmarkI,1)==0
            CorrectRecLandmarkI(1,:)=FalseRecLandmarkI(1,:);
            FalseRecLandmarkI(1,:)=[];
        end
        outForFalseRec=[];
        for j=1:size(FalseRecLandmarkI,1)
            dist = bsxfun(@minus, FalseRecLandmarkI(j,:), CorrectRecLandmarkI);
            dist2 = sqrt(sum(dist'.*dist'));
            [mindist, column] = min(dist2);
            outForFalseRec(j,:)=CorrectRecLandmarkI(column,:);
        end
        %----out
        CBtrain_In_Comp2=[CBtrain_In_Comp2;CorrectRecLandmarkI;FalseRecLandmarkI];
        CBtrain_Out_Comp2=[CBtrain_Out_Comp2;CorrectRecLandmarkI;outForFalseRec];
        LBL_out_Comp2=[LBL_out_Comp2;repmat(FinalLandmarkCode(i,:),size(OutputLandmarkI,1),1)];
    end
end  
%%%what about non landmarks
%%% what about landmark=314
AllLabels=1:length(LBL_train);
NonLandmarksLabels=AllLabels; 
NonLandmarksLabels(IndexLandmarksTotal)=[];
CB_NonLandmarks=CB_train(NonLandmarksLabels,:);
LBL_NonLandmarks=LBL_train(NonLandmarksLabels,:);

LBL_out_Comp2=[LBL_out_Comp2;LBL_NonLandmarks];
CBtrain_In_Comp2=[CBtrain_In_Comp2;CB_NonLandmarks];
CBtrain_Out_Comp2=[CBtrain_Out_Comp2;CB_NonLandmarks];

save('CBtrain_In_Comp2','CBtrain_In_Comp2');
save('CBtrain_Out_Comp2','CBtrain_Out_Comp2');
save('LBL_out_Comp2','LBL_out_Comp2');
%----------------------------------------------------------------------




