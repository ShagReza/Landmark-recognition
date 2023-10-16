%--------------------------------------------------------------------------
% Borders Data: for CNTK
% Shaghyegh Reza
%--------------------------------------------------------------------------

clc, clear all, close all, fclose all



%--------------------------------------------------------------------------
load('AllEvents2.mat')
A=cell2mat(AllEvents2(:,3));
[sorted, idx] = sort(A,'descend');
AllEvents2 = AllEvents2(idx,:);

% Event's number
AllEvents3=AllEvents2;
for i=1:size(A,1)
    AllEvents3(i, 8)={i};
end
save('AllEvents3','AllEvents3');
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
load('AllEvents3.mat');
K=[];
for i=1:size(AllEvents3,1)
    k=0;
    if ((AllEvents3{i,1}==31) && (AllEvents3{i,2}==13 || AllEvents3{i,2}== 18)) , k=1; end
    if ((AllEvents3{i,1}==32) && (AllEvents3{i,2}==12 || AllEvents3{i,2}== 17)) , k=1; end
    if ((AllEvents3{i,1}==33) && (AllEvents3{i,2}==15 || AllEvents3{i,2}== 19)) , k=1; end
    if ((AllEvents3{i,1}==34) && (AllEvents3{i,2}==14)) , k=1; end
    if ((AllEvents3{i,1}==35) && (AllEvents3{i,2}==16)) , k=1; end
    if ((AllEvents3{i,1}==36) && (AllEvents3{i,2}==20 || AllEvents3{i,2}== 21)) , k=1; end
    
    if k==1, K=[K,i]; end
end
AllEvents4=AllEvents3;
AllEvents4(K,:)=[];
save('AllEvents4','AllEvents4');

c=0;
for i=1:10
    c=c+AllEvents3{K(i),3};
end


c=0;
for i=1:size(AllEvents4,1)
    c=c+AllEvents4{i,3};
end
%--------------------------------------------------------------------------