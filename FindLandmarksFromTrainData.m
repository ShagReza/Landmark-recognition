%----------------------------------------------------------------------
% Find Landmarks Centers
path='D:\Shapar\ShaghayeghUni\AfterPropozal\MyPrograms\EventExtraction\Keras';
LBL_train=load([path,'\LBL_total_train.mat']);
LBL_train=LBL_train.LBL_total_train;

CB_train=load([path,'\CB_total_train.mat']);
CB_train=CB_train.CB_total_train;


LandmarkNumber_TrainCenters=[];
for i=1:313
    i
    for j=1:size(LBL_train,1)
        if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
            LandmarkNumber_TrainCenters(j)=i;
        end
    end
    NumberOfCenterLandmarksInTrain(i)=length(find( LandmarkNumber_TrainCenters==i));
end
%----------------------------------------------------------------------



%----------------------------------------------------------------------
A=find(LBL_train>0.5);
LBL_train(A)=1;
LandmarkNumber_TrainCenters=[];
k=0;
CB_LandamarksTrain=CB_train;
for i=1:313
    i
    for j=1:size(LBL_train,1)
        if isequal(LBL_train(j,:),FinalLandmarkCode(i,:))
            LandmarkNumber_TrainCenters(j)=i;
            k=k+1;
            LandmarkNumber_Train(k)=i;
            CB_LandamarksTrain(k,:)=CB_train(j,:);
        end
    end
    NumberOfCenterLandmarksInTrain(i)=length(find( LandmarkNumber_TrainCenters==i));
end
save('LandmarkNumber_Train','LandmarkNumber_Train');
save('CB_LandamarksTrain','CB_LandamarksTrain');
%----------------------------------------------------------------------