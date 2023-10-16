%--------------------------
% Landmarks type 2:
%-----------------------
clc,clear all,close all
V=[1,2,3,4,5,6];
C=[7:29];
B=[31:36];
D=[7:11,22:29];
S=30;
Cp=[7:29];
DB=[D,B];
A=[9,10,18,24,26]; % s,$,t,n,m

LandmarkType3_Events=[]; l=0;
for i=1:size(V,2)
    for j=1:size(DB,2)
        l=l+1;
        LandmarkType3_Events(l,1:2)=[V(i),DB(j)];
    end
end
        

for i=1:size(V,2)
    l=l+1;
    LandmarkType3_Events(l,1:2)=[V(i),30];
end


for i=1:size(Cp,2)
    for j=1:size(V,2)
        l=l+1;
        LandmarkType3_Events(l,1:2)=[Cp(i),V(j)];
    end
end

for j=1:size(D,2)
    l=l+1;
    LandmarkType3_Events(l,1:2)=[30,D(j)];
end


for j=1:size(A,2)
    l=l+1;
    LandmarkType3_Events(l,1:2)=[A(j),30];
end


save('LandmarkType3_Events.mat','LandmarkType3_Events');
