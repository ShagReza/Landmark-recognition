%--------------------------------------------------
% Length of different phonems in different bordwers
% Shaghayegh Reza
%--------------------------------------------------
clc, clear all, close all


%------------------------------------------------------------------
BordersLengthPathdir=dir('BordersLength');
load('AllEvents.mat'); 
AllEvents2= AllEvents;
AllEvents=cell2mat(AllEvents);
AllEvents2{1,4}=0; AllEvents2{1,5}=0;

for i=3:length(BordersLengthPathdir)
    load(['BordersLength','/',BordersLengthPathdir(i).name]);
    
    for j=1:size(AllEvents,1)
        indx=find((BorderLength(:,1)==AllEvents(j,1)) & (BorderLength(:,2)==AllEvents(j,2)) );
        if size(indx,1)>=1
            AllEvents2{j,4}=[AllEvents2{j,4},BorderLength(indx,3)'];
            AllEvents2{j,5}=[AllEvents2{j,5},BorderLength(indx,4)'];
        end
    end
end
M=AllEvents2{1,4}; M(1)=[]; AllEvents2{1,4}=M;
M=AllEvents2{1,5}; M(1)=[]; AllEvents2{1,5}=M;
%------------------------------------------------------------------



%------------------------------------------------------------------
for j=1:size(AllEvents,1)
    A=AllEvents2{j,4}; B=AllEvents2{j,5};
    AllEvents2{j,6}=[min(A),max(A),mean(A)];
    AllEvents2{j,7}=[min(B),max(B),mean(B)];    
end
save('AllEvents2','AllEvents2');
%-----------------------------------------------------------
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               



