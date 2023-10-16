clc,clear all,close all

%Counting Number of Each landmark in Train data


% Number of Output:307
% A=textread('LblLandmark_Train_All.txt');
% 
% A(:,end)=[];
% [max,maxIndex]=max(A');
% Count=[];
% for i=1:307  
%     count(i)=length(find(maxIndex==i));
%     IndexLandmarks{i}=find(maxIndex==i);
% end


% Number of Output:103
A=textread('LblLandmark_Train_All.txt');
load('LandmarkType3_Events.mat');
A(:,end)=[];
Count(1:307)={0};
for i=1:size(A,1)
    B=[];
    B=find(A(i,:)==1);
    if (length(B)==1 && B~=103), Count(B)={cell2mat(Count(B))+1};
    elseif (length(B)==1 && B==103),Count(307)={cell2mat(Count(307))+1};
    else
        for j=1:276
            if (LandmarkType3_Events(j,1)==B(1)-30 && LandmarkType3_Events(j,2)==B(2)-66)
                Count(j+30)={cell2mat(Count(j+30))+1};
            end
        end
    end
end
C=cell2mat(Count);
for i=1:30
    Count(2,i)={i};
end

for i=1:276
    Count(2,i+30)={[LandmarkType3_Events(i,1),LandmarkType3_Events(i,2)]};
end

[s,I]=sort(C,'ascend');
for i=1:307
    Csorted(i)=Count(2,I(i));
end
Lanmarktype3_Count_Train.Count=Count;
Lanmarktype3_Count_Train.Csorted=Csorted;
Lanmarktype3_Count_Train.s=s;

save('Lanmarktype3_Count_Train','Lanmarktype3_Count_Train');
