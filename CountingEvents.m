%-----------------------------
% Counting Events
% Shaghayegh Reza
%-----------------------------
clc, clear all, close all

%-------------------------------------------------------------------------
%Extraction All Events (Borders) of small mic farsdat
EventsPathdir=dir('Events');
AllEvents={0,0,0};
l=1;
for i=3:length(EventsPathdir)
    load(['Events','/',EventsPathdir(i).name]);
    for j=1:size(Event,1)
        NewEvent=1;
        for k=1:size(AllEvents,1)
            if (Event(j,2)== AllEvents{k,1}) &&  (Event(j,3)== AllEvents{k,2})
                AllEvents{k,3}= AllEvents{k,3}+1;
                NewEvent=0;
            end
        end
        if NewEvent==1
            l=l+1;
            AllEvents{l,1}=Event(j,2);
            AllEvents{l,2}=Event(j,3);
            AllEvents{l,3}=1;
        end
    end
end
AllEvents(1,:)=[];
save('AllEvents','AllEvents');
%-------------------------------------------------------------------------



%-------------------------------------------------------------------------
AllEvents=cell2mat(AllEvents);
[sorted, idx] = sort(AllEvents(:,3),'descend');
AllEvents = AllEvents(idx,:);
%-------------------------------------------------------------------------


%-------------------------------------------------------------------------
% which borders didn't happened?
Missed=[];
for i=1:36
    for j=1:36
        if isempty (find((AllEvents(:,1)==i) & (AllEvents(:,2)==j)))
            if i~=j
                Missed=[Missed;[i,j]];
            end
        end
    end
end
%-------------------------------------------------------------------------


% %-------------------------------------------------------------------------
% j=1:1018;
% bar (j,AllEvents(:,3));















