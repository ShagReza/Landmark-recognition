
%--------------------------------------------------------------------------
%                  Landmark number for all train data and center of
%                  landmarks  and test data
%--------------------------------------------------------------------------




clc,clear all,close all
%----------------------------------------------------------------------
% Landmark Number (landmark number and is codes)
V=1:6;
C=7:29;
B=31:36;
D=[7,8,9,10,11,19,22,23,24,25,26,27,28,29];
DB=[D,B]
A=[9,10,18,26,29];
S=30;

LandmarkCode=[];
LandmarkVaj=[];
k=0;
for i=1:length(V)
    for j=1:length(DB)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(V(i))=1; L3(DB(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[V(i),DB(j)];
    end
end
for i=1:length(V)
    for j=1:length(S)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(V(i))=1; L3(S(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[V(i),S(j)];
    end
end
for i=1:length(C)
    for j=1:length(V)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(C(i))=1; L3(V(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[C(i),V(j)];
    end
end
for i=1:length(S)
    for j=1:length(D)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(S(i))=1; L3(D(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[S(i),D(j)];
    end
end
for i=1:length(A)
    for j=1:length(S)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(A(i))=1; L3(S(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[A(i),S(j)];
    end
end
for i=1:30
    L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
    L1(i)=1;
    k=k+1;
    LandmarkCode(k,1:103)=[L1,L2,L3,L4];
    LandmarkVaj(k,1:2)=[i,0];
end

L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=1;
k=k+1;
LandmarkCode(k,1:103)=[L1,L2,L3,L4];
LandmarkVaj(k,1:2)=[0,0];

FinalLandmarkCode=LandmarkCode; save('FinalLandmarkCode','FinalLandmarkCode');
FinalLandmarkVaj=LandmarkVaj; save('FinalLandmarkVaj','FinalLandmarkVaj');
%----------------------------------------------------------------------
% Find Landmarks Centers
path='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras';
LBL_train=load([path,'\LBL_total_train.mat']);
LBL_train=LBL_train.LBL_total_train;

CB_train=load([path,'\CB_total_train.mat']);
CB_train=CB_train.CB_total_train;


% LandmarkNumber_TrainCenters=[];
% for i=1:313
%     i
%     for j=1:size(LBL_train,1)
%         if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
%             LandmarkNumber_TrainCenters(j)=i;
%         end
%     end
%     NumberOfCenterLandmarksInTrain(i)=length(find( LandmarkNumber_TrainCenters==i));
% end
%----------------------------------------------------------------------



% %----------------------------------------------------------------------
% A=find(LBL_train>0.5);
% LBL_train(A)=1;
% LandmarkNumber_TrainCenters=[];
% k=0;
% CB_LandamarksTrain=CB_train;
% for i=1:313
%     i
%     for j=1:size(LBL_train,1)
%         if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
%             LandmarkNumber_TrainCenters(j)=i;
%             k=k+1;
%             LandmarkNumber_Train(k)=i;
%             CB_LandamarksTrain(k,:)=CB_train(j,:);
%         end
%     end
%     NumberOfCenterLandmarksInTrain(i)=length(find( LandmarkNumber_TrainCenters==i));
% end
% save('LandmarkNumber_Train','LandmarkNumber_Train');
% save('CB_LandamarksTrain','CB_LandamarksTrain');
% %----------------------------------------------------------------------




% %----------------------------------------------------------------------
% % load Keras output for train data
% train_predict=load('D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras\train_predict.mat')
% train_predict=train_predict.lbl;
% % for each landmark using (LandmarkNumber_Train) find all keras output
% % and select the best output for  each landmark (out:BestLandmarks)
% %CB_LandamarksTrain=zeros(length(LandmarkNumber_Train),270);
% %CB_BestLandmarksTrain=zeros(length(LandmarkNumber_Train),270);
% CB_LandamarksTrain=[];
% CB_BestLandmarksTrain=[];
% BestLandmarks=zeros(313,103);
% BestCBLanmarkI=zeros(313,270);
% for i=1:313
%     i
%     LandmarkI=[]; dist=[]; dist2=[];  IndexLandmarks=[];
%     k=0;
%     for j=1:size(LBL_train,1)
%         if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
%            k=k+1;
%            LandmarkI(k,:)=train_predict(j,:);
%            CBLanmarkI(k,:)=CB_train(j,:);
%            IndexLandmarks=[IndexLandmarks,j];
%         end
%     end
%     if k>0
%         dist = bsxfun(@minus, LandmarkI, FinalLandmarkCode(i,:));
%         dist2 = sqrt(sum(dist'.*dist'));
%         [mindist, column] = min(dist2);
%         BestLandmarks(i,:)=LandmarkI(column,:);
%         BestCBLanmarkI(i,:)=CBLanmarkI(column,:);
%         CB_LandamarksTrain=[CB_LandamarksTrain;CB_train(IndexLandmarks,:)];
%         CB_BestLandmarksTrain=[CB_BestLandmarksTrain;repmat(BestCBLanmarkI(i,:),size(LandmarkI,1),1)];
%     end
% end
%
% % % for all data in CB_LandamarksTrain write their best landmark in a variable
% % % with the same length as CB_LandamarksTrain (out CB_BestLandmarksTrain)
% % CB_BestLandmarksTrain=zeros(length(LandmarkNumber_Train),103);
% % for i=1:length(LandmarkNumber_Train)
% %     i
% %     CB_BestLandmarksTrain(i,:)=BestCBLanmarkI(LandmarkNumber_Train(i),:);
% % end
% save('CB_BestLandmarksTrain','CB_BestLandmarksTrain');
% save('CB_LandamarksTrain','CB_LandamarksTrain');
% %----------------------------------------------------------------------




%----------------------------------------------------------------------
A=find(LBL_train>0.5);
LBL_train(A)=1;

train_predict=load('D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Keras\train_predict.mat')
train_predict=train_predict.lbl;
CB_LandamarksTrain=[];
CB_BestLandmarksTrain=[];
CB_LandamarksTrain=zeros(591536,270);
CB_BestLandmarksTrain=zeros(591536,270);
a=0;
b=0;

K=[]; LBL_BestLandmarks=[]; LBL_BestLandmarks_final=[];
m=0;
for i=1:314
    i
    k=0;
    LBL_BestLandmarks=[];
    for j=1:size(LBL_train,1)
        if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
            k=k+1;
            m=m+1;
            %LBL_BestLandmarks(m,1:103)=LBL_train(j,:);
            LBL_BestLandmarks(k,1:103)=LBL_train(j,:);
        end
    end
    LBL_BestLandmarks_final=[LBL_BestLandmarks_final;LBL_BestLandmarks];
    K(i)=k;
end

a=0; b=0;
KK=[];KKK=[]; K=[];
CB_LandamarksTrain=zeros(591536,270);
CB_BestLandmarksTrain=zeros(591536,270);
for i=1:314
    i
    LandmarkI=[]; CBLanmarkI=[]; dist=[]; dist2=[];  IndexLandmarks=[];
    k=0;
    for j=1:size(LBL_train,1)
        if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
            k=k+1;
            LandmarkI(k,:)=train_predict(j,:);
            CBLanmarkI(k,:)=CB_train(j,:);
            IndexLandmarks=[IndexLandmarks,j];
        end
        K(i)=k;
    end
    if k>0
        dist = bsxfun(@minus, LandmarkI, FinalLandmarkCode(i,:));
        dist2 = sqrt(sum(dist'.*dist'));
        [mindist, column] = min(dist2);
        BestLandmarks(i,:)=LandmarkI(column,:);
        BestCBLanmarkI(i,:)=CBLanmarkI(column,:);
        a=b+1
        b=a+size(LandmarkI,1)-1
        KK(i)=k;
        KKK(i)=b-a+1;
        CB_LandamarksTrain(a:b,:)=CB_train(IndexLandmarks,:);
        CB_BestLandmarksTrain(a:b,:)=repmat(BestCBLanmarkI(i,:),size(LandmarkI,1),1);
    end
end

% plot to check data
plot(CB_LandamarksTrain(:,1)),
plot(CB_BestLandmarksTrain(:,1))


%randomize data:
%!!!!!!!!!!!!!!!!!!!!!!!!!!
r= randperm(size(LBL_train,1));

save('CB_BestLandmarksTrain','CB_BestLandmarksTrain');
save('CB_LandamarksTrain','CB_LandamarksTrain');


%----------------------------------------------------------------------






















%----------------------------------------------------------------------
a=0; b=0;
KK=[];KKK=[]; K=[];
CB_LandamarksTrain=zeros(314*200,270);
CB_BestLandmarksTrain=zeros(314*200,270);
for i=1:314
    i
    LandmarkI=[]; CBLanmarkI=[]; dist=[]; dist2=[];  IndexLandmarks=[];
    k=0;
    for j=1:size(LBL_train,1)
        if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
            k=k+1;
            LandmarkI(k,:)=train_predict(j,:);
            CBLanmarkI(k,:)=CB_train(j,:);
            IndexLandmarks=[IndexLandmarks,j];
        end
        K(i)=k;
    end
    if k>0
        dist = bsxfun(@minus, LandmarkI, FinalLandmarkCode(i,:));
        dist2 = sqrt(sum(dist'.*dist'));
        [mindist, column] = min(dist2);
        BestLandmarks(i,:)=LandmarkI(column,:);
        BestCBLanmarkI(i,:)=CBLanmarkI(column,:);
        
        if size(LandmarkI,1)>200
            a=b+1
            b=a+200-1
            KK(i)=k;
            KKK(i)=b-a+1;
            [O,I]=sort(dist2);
            CB_LandamarksTrain(a:b,:)=CB_train(IndexLandmarks(I(1:200)),:);
            CB_BestLandmarksTrain(a:b,:)=repmat(BestCBLanmarkI(i,:),200,1);
        else
            a=b+1
            b=a+size(LandmarkI,1)-1
            KK(i)=k;
            KKK(i)=b-a+1;
            CB_LandamarksTrain(a:b,:)=CB_train(IndexLandmarks,:);
            CB_BestLandmarksTrain(a:b,:)=repmat(BestCBLanmarkI(i,:),size(LandmarkI,1),1);
        end
        
    end
end
CB_BestLandmarksTrain2=CB_BestLandmarksTrain;
CB_LandamarksTrain2=CB_LandamarksTrain;
save('CB_BestLandmarksTrain2','CB_BestLandmarksTrain2');
save('CB_LandamarksTrain2','CB_LandamarksTrain2');
%----------------------------------------------------------------------







%----------------------------------------------------------------------
%Finding non landmark data and adding them to landmarks:
CB_NonLandmark=[];
LBL_NonLandmark=[];
CBout_NonLandmark=[];
k=0;
for i=1:size(CB_train,1)
    i
    nonLandmarkTag=1;
    for j=1:313
        if (isequal(LBL_train(i,:),FinalLandmarkCode(j,:)))==1
            nonLandmarkTag=0;
        end
    end
    if nonLandmarkTag==1
        k=k+1;
        CB_NonLandmark(k,:)=CB_train(i,:);
        LBL_NonLandmark(k,:)=LBL_train(i,:);
    end
end
CBout_NonLandmark=CB_NonLandmark;
save('CB_NonLandmark','CB_NonLandmark');
save('CBout_NonLandmark','CBout_NonLandmark');
save('LBL_NonLandmark','LBL_NonLandmark');

CbTotal=[CB_LandamarksTrain;CB_NonLandmark];
CbOutTotal=[CB_BestLandmarksTrain;CBout_NonLandmark];
LblTotal=[LBL_BestLandmarks_final;LBL_NonLandmark];
save('CbTotal','CbTotal');
save('CbOutTotal','CbOutTotal');
save('LblTotal','LblTotal');
%----------------------------------------------------------------------





%----------------------------------------------------------------------
CB_total_val=load('CB_total_val.mat');
CB_total_val=CB_total_val.CB_total_val;
LBL_total_val=load('LBL_total_val.mat');
LBL_total_val=LBL_total_val.LBL_total_val;
A=find(LBL_total_val>0.5);
LBL_total_val(A)=1;
for i=1:size(CB_total_val,1)
    i
    nonLandmarkTag=1;
    for j=1:313
        if (isequal(LBL_total_val(i,:),FinalLandmarkCode(j,:)))==1
            ValOut(i,:)=BestCBLanmarkI(j,:);
        else
            ValOut(i,:)=CB_total_val(i,:);
        end
    end
end
save('ValOut','ValOut');
%----------------------------------------------------------------------






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

load('BestCBLanmarkI.mat');
load('FinalLandmarkCode');

TrainOut2=CB_train;
for i=1:size(CB_train,1)
    i
    LBLout(1:103)=0;
    Out=train_predict(i,:);
    [a,b]=max(Out);
    if (b<31 || b==103), LBLout(b)=1; 
    else 
        [c1,c2]=max(Out(31:66)); [d1,d2]=max(Out(67:102));
        LBLout(30+c2)=1;   LBLout(66+d2)=1;
    end
    
    %plot(LBLout,'*'),hold on,plot(LBL_train(i,:),'r');
    if (isequal(LBLout,LBL_train(i,:)))==1
        TrainOut2(i,:)=CB_train(i,:);
    else
        I=0; J=0;
        for j=1:313
            if (isequal(LBL_train(i,:),FinalLandmarkCode(j,:)))==1
                I=1; J=j; 
            end
        end
        if I==1
            TrainOut2(i,:)=BestCBLanmarkI(J,:);
        else
            TrainOut2(i,:)=CB_train(i,:);
        end
    end
end
save('TrainOut2','TrainOut2');
%----------------------------------------------------------------------




%----------------------------------------------------------------------
CB_total_val=load('CB_total_val.mat');
CB_total_val=CB_total_val.CB_total_val;
LBL_total_val=load('LBL_total_val.mat');
LBL_total_val=LBL_total_val.LBL_total_val;
A=find(LBL_total_val>0.5);
LBL_total_val(A)=1;
for i=1:size(CB_total_val,1)
    i,I
    I=0; J=0;
    for j=1:313
        if (isequal(LBL_total_val(i,:),FinalLandmarkCode(j,:)))==1
           I=1; J=j;
        end
    end
    if I==1
        ValOut(i,:)=BestCBLanmarkI(J,:);
    else
        ValOut(i,:)=CB_total_val(i,:);
    end
end
save('ValOut','ValOut');
%----------------------------------------------------------------------










