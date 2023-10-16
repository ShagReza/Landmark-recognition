%--------------------------
% Landmarks type 2:
%-----------------------
clc,clear all,close all
V=[1,2,3,4,5,6];
C=[7:29,31:36];
S=30;
Cp=[7:29];


LandmarkType2_Events=[]; l=0;
for i=1:size(V,2)
    for j=1:size(C,2)
        l=l+1;
        LandmarkType2_Events(l,1:2)=[V(i),C(j)];
    end
end
        

for i=1:size(V,2)
    l=l+1;
    LandmarkType2_Events(l,1:2)=[V(i),30];
end


for i=1:size(Cp,2)
    for j=1:size(V,2)
        l=l+1;
        LandmarkType2_Events(l,1:2)=[Cp(i),V(j)];
    end
end

for j=1:size(Cp,2)
    l=l+1;
    LandmarkType2_Events(l,1:2)=[30,Cp(j)];
end


for j=1:size(Cp,2)
    l=l+1;
    LandmarkType2_Events(l,1:2)=[Cp(j),30];
end


save('LandmarkType2_Events.mat','LandmarkType2_Events');
