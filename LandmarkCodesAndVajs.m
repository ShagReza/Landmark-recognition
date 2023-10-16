

clc,clear all,close all
%----------------------------------------------------------------------
% Landmark Number (landmark number and its codes)
V=1:6;
C=7:29;
B=31:36;
D=[7,8,9,10,11,19,22,23,24,25,26,27,28,29];
DB=[D,B]
A=[9,10,18,26,29];
S=30;

LandmarkCode=[];
LandmarkVaj=[];
k=0;
for i=1:length(V)
    for j=1:length(DB)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(V(i))=1; L3(DB(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[V(i),DB(j)];
    end
end
for i=1:length(V)
    for j=1:length(S)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(V(i))=1; L3(S(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[V(i),S(j)];
    end
end
for i=1:length(C)
    for j=1:length(V)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(C(i))=1; L3(V(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[C(i),V(j)];
    end
end
for i=1:length(S)
    for j=1:length(D)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(S(i))=1; L3(D(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[S(i),D(j)];
    end
end
for i=1:length(A)
    for j=1:length(S)
        L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
        k=k+1;
        L2(A(i))=1; L3(S(j))=1;
        LandmarkCode(k,1:103)=[L1,L2,L3,L4];
        LandmarkVaj(k,1:2)=[A(i),S(j)];
    end
end
for i=1:30
    L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=0;
    L1(i)=1;
    k=k+1;
    LandmarkCode(k,1:103)=[L1,L2,L3,L4];
    LandmarkVaj(k,1:2)=[i,0];
end

L1(1:30)=0; L2(1:36)=0; L3(1:36)=0; L4=1;
k=k+1;
LandmarkCode(k,1:103)=[L1,L2,L3,L4];
LandmarkVaj(k,1:2)=[0,0];

FinalLandmarkCode=LandmarkCode; save('FinalLandmarkCode','FinalLandmarkCode');
FinalLandmarkVaj=LandmarkVaj; save('FinalLandmarkVaj','FinalLandmarkVaj');
%----------------------------------------------------------------------