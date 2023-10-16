%-----------------------------------------------------------
% Convert Landmarks to LandmarksType3
%-----------------------------------------------------------
clc,clear all,close all
load('LandmarkType3_Events.mat')
pathLandmarks='Landmarks';
dirLandmarks=dir(pathLandmarks);




%-----------------------------------------------------------
%Convert (VowelORsilence)+busrt to (VowelORsilence)+bast:
for i=3:length(dirLandmarks)
    i
    load([pathLandmarks,'\',dirLandmarks(i).name])
    EventStateTag3=Landmarks.EventStateTag;
    for j=1:size(EventStateTag3,2)
        if EventStateTag3{1,j}=='e'
            event=EventStateTag3{3,j};
            event=cell2mat(event{1,1});
            if (event(1)<7 || event(1)==30) && (event(2)>11 && event(2)<22)
                if event(2)==12, event(2)=32; end;
                if event(2)==13, event(2)=31; end;
                if event(2)==14, event(2)=34; end;
                if event(2)==15, event(2)=33; end;
                if event(2)==16, event(2)=35; end;
                if event(2)==17, event(2)=32; end;
                if event(2)==18, event(2)=31; end;
                if event(2)==19, event(2)=33; end;
                if event(2)==20, event(2)=36; end;
                if event(2)==21, event(2)=36; end;
                b=[]; b{1,1}{1,1}=event(1); b{1,1}{1,2}=event(2);
                EventStateTag3{3,j}=b;
            end
        end
    end
     Landmarks.EventStateTagType3=EventStateTag3;
    save([pathLandmarks,'\',dirLandmarks(i).name],'Landmarks');
end


%-----------------------------------------------------------
clc,clear all,close all
load('LandmarkType3_Events.mat')
pathLandmarks='Landmarks';
dirLandmarks=dir(pathLandmarks);
for i=3:length(dirLandmarks)
    i
    LandmarkType3Name=[];
    load([pathLandmarks,'\',dirLandmarks(i).name])
    EventStateTag3=Landmarks.EventStateTagType3;
    EventStateTag_LandmarksType3=EventStateTag3;
    for j=1:size(EventStateTag3,2)
        if EventStateTag_LandmarksType3{1,j}=='e'
            event=EventStateTag_LandmarksType3{3,j};
            event=cell2mat(event{1,1});
            EventTag=0; EventName=0;
            for k=1:size(LandmarkType3_Events,1)
                if (event(1)==LandmarkType3_Events(k,1)) && (event(2)==LandmarkType3_Events(k,2))
                    EventTag=1;
                    LandmarkType3Name(j)=30+k;
                end
            end
            if EventTag==0
                LandmarkType3Name(j)=0;
                EventStateTag_LandmarksType3{3,j}=[];
                EventStateTag_LandmarksType3{1,j}='n';
            end
        end
        if EventStateTag_LandmarksType3{1,j}=='s'
            LandmarkType3Name(j)=EventStateTag_LandmarksType3{3,j};
        end
        if EventStateTag_LandmarksType3{1,j}=='d'
            LandmarkType3Name(j)=-100;
        end
    end
    Landmarks.EventStateTag_LandmarksType3=EventStateTag_LandmarksType3;
    Landmarks.LandmarkType3Name=LandmarkType3Name;
    save([pathLandmarks,'\',dirLandmarks(i).name],'Landmarks');
end