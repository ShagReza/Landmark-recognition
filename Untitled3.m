load('TrainBabaiName.mat')
for i=1:length(TrainBabaiName)
   fid=fopen(['D:\Shapar\ShaghayeghUni\Data\SmallFarsDat\All\S',num2str(TrainBabaiName(i)),'.SNT'],'r');
    
   S=textscan(fid,'%s');
    
end