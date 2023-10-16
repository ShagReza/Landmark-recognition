%-----------------------------------------------------------
% Convert Landmarks to LandmarksType2
%-----------------------------------------------------------
clc,clear all,close all

load('LandmarkType2_Events.mat')
pathLandmarks='Landmarks';
dirLandmarks=dir(pathLandmarks);

for i=3:length(dirLandmarks)
    i
    LandmarkType2Name=[];
    load([pathLandmarks,'\',dirLandmarks(i).name])
    EventStateTag=Landmarks.EventStateTag;
    EventStateTag_LandmarksType2=EventStateTag;
    for j=1:size(EventStateTag,2)
        if EventStateTag_LandmarksType2{1,j}=='e'
            event=EventStateTag_LandmarksType2{3,j};
            event=cell2mat(event{1,1});
            EventTag=0; EventName=0;
            for k=1:size(LandmarkType2_Events,1)
                if (event(1)==LandmarkType2_Events(k,1)) && (event(2)==LandmarkType2_Events(k,2))
                    EventTag=1;
                    LandmarkType2Name(j)=30+k;
                end
            end
            if EventTag==0
                EventStateTag_LandmarksType2{3,j}=[];
                EventStateTag_LandmarksType2{1,j}='n';
            end
        end
        if EventStateTag_LandmarksType2{1,j}=='s'
            LandmarkType2Name(j)=EventStateTag_LandmarksType2{3,j};
        end
        if EventStateTag_LandmarksType2{1,j}=='d'
            LandmarkType2Name(j)=-100;
        end
    end
    Landmarks.EventStateTag_LandmarksType2=EventStateTag_LandmarksType2;
    Landmarks.LandmarkType2Name=LandmarkType2Name;
    save([pathLandmarks,'\',dirLandmarks(i).name],'Landmarks');
end