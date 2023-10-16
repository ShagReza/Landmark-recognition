clc, clear all, close all

LhcbPath='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LHCB';
LhcbPlusDelta='D:\Shapar\ShaghayeghUni\AfterPropozal\Step1-EventLandmark\Programs\MyPrograms\EventExtraction\SmallFarsdat\LhcbPlusDelta';
dir=dir(LhcbPath);
for i=3:length(dir)
    name=dir(i).name;
    load([LhcbPath,'\',name]);
    
    deltaCB=zeros(length(CB),18);
    for j=2:length(CB)
        deltaCB(j,:)=CB(j,:)-CB(j-1,:);
    end
    deltaCB(1,:)=deltaCB(2,:);
    
    deltadeltaCB=zeros(length(CB),18);
    for j=2:length(CB)
        deltadeltaCB(j,:)=deltaCB(j,:)-deltaCB(j-1,:);
    end
    deltadeltaCB(1,:)=deltadeltaCB(3,:);
    deltadeltaCB(2,:)=deltadeltaCB(3,:);
    
    CB=[CB,deltaCB,deltadeltaCB];
    save([LhcbPlusDelta,'\',name], 'CB');
end