clc,clear all,close all

load('AmaxOfEachLandmark.mat')
load('IndexOfEachLandmark.mat')
IndexBestLandmarks=[]; k=0;
for i=1:307
    MaxI=AmaxOfEachLandmark(i,:);
    IndexI=IndexOfEachLandmark(1,:);
    [a,b]=sort(MaxI,'descend');
    for j=1:15
        if MaxI(j)>0, IndexBestLandmarks=[IndexBestLandmarks,b(j)]; end
        if MaxI(j)==0, i, end
    end
end
save('IndexBestLandmarks','IndexBestLandmarks');