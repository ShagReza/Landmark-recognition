% Computing Transition Matrix From farsdat
clc,clear all,close all
VajPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\36Labels';
dirVaj=dir(VajPath);
BigramCount=zeros(36,36);
for i=3:length(dirVaj)
    i
    VajFrame=[]; Vaj=[];
    Vajname=[VajPath,'\',dirVaj(i).name];
    VajFrame=load(Vajname);
    VajFrame=VajFrame.Z36;
    k=1;Vaj(k)=VajFrame(1);
    
    % keep only Vaj sequence and Count bigrmas:
    for j=2:length(VajFrame)
        if VajFrame(j)~=Vaj(k)
            k=k+1; Vaj(k)=VajFrame(j);
            BigramCount(Vaj(k-1),Vaj(k))=BigramCount(Vaj(k-1),Vaj(k))+1;
        end
    end    
end

%Convert to probability
SumB=sum(BigramCount');
for i=1:36
    BigramCount(i,:)=BigramCount(i,:)/SumB(i);
end

TransitionMatrix36=BigramCount;
save('TransitionMatrix36','TransitionMatrix36');