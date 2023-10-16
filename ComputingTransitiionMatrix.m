% Computing Transition Matrix From farsdat
clc,clear all,close all
VajPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\Vaj';
dirVaj=dir(VajPath);
BigramCount=zeros(30,30);
for i=3:length(dirVaj)
    VajFrame=[]; Vaj=[];
    Vajname=[VajPath,'\',dirVaj(i).name];
    VajFrame=load(Vajname);
    VajFrame=VajFrame.Vaj;
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
for i=1:30
    BigramCount(i,:)=BigramCount(i,:)/SumB(i);
end

TransitionMatrix=BigramCount;
save('TransitionMatrix','TransitionMatrix');