%--------------------------------------------------------
%----------- Computing CNTK output accuracy -------------
%--------------------------------------------------------




%--------------------------------------------------------
fclose all; clc; clear all; close all;
Nlbl_l1=30; Nlbl_l2=36; Nlbl_l3=36;

NumTest=35272;
LblDim=102;
%-----------
load('LandmarkLabels_Test.mat');
LBL_part1=LBL(:,1:Nlbl_l1);  LBL_part1=LBL_part1';
[sortd,LBL_part1_SortIndex]=sort(LBL_part1,'descend'); LBL_part1_SortIndex=LBL_part1_SortIndex';
%-----------
LBL_part2=LBL(:,Nlbl_l1+1:Nlbl_l1+Nlbl_l2);  LBL_part2=LBL_part2';
[sortd,LBL_part2_SortIndex]=sort(LBL_part2,'descend'); LBL_part2_SortIndex=LBL_part2_SortIndex';
%-----------
LBL_part3=LBL(:,Nlbl_l1+Nlbl_l2+1:Nlbl_l1+Nlbl_l2+Nlbl_l3);  LBL_part3=LBL_part3';
[sortd,LBL_part3_SortIndex]=sort(LBL_part3,'descend'); LBL_part3_SortIndex=LBL_part3_SortIndex';
%-----------
fid=fopen('.\TrainWithCntk\temp\NetTest.txt.HLast','r');
NetOut=textscan(fid,'%f');
NetOut=reshape(NetOut{1,1},LblDim,NumTest);
NetOut=NetOut';
NetOut1=NetOut(:,1:Nlbl_l1);
NetOut2=NetOut(:,Nlbl_l1+1:Nlbl_l1+Nlbl_l2);
NetOut3=NetOut(:,Nlbl_l1+Nlbl_l2+1:Nlbl_l1+Nlbl_l2+Nlbl_l3);
[NetOut1_Sort,NetOut1_SortIndex]=sort(NetOut1','descend'); NetOut1_Sort=NetOut1_Sort'; NetOut1_SortIndex=NetOut1_SortIndex';
[NetOut2_Sort,NetOut2_SortIndex]=sort(NetOut2','descend'); NetOut2_Sort=NetOut2_Sort'; NetOut2_SortIndex=NetOut2_SortIndex';
[NetOut3_Sort,NetOut3_SortIndex]=sort(NetOut3','descend'); NetOut3_Sort=NetOut3_Sort'; NetOut3_SortIndex=NetOut3_SortIndex';
%--------------------------------------------------------




% 
% %--------------------------------------------------------
%                         %Results:
%wihhout threshold
Part1_correct=NetOut1_SortLbl(:,1)==AllLabels2_train_part1_lbl(:,1);
Part2_correct=NetOut2_SortLbl(:,1)==AllLabels2_train_part2_lbl(:,1);
NumBorders=size(Part1_correct,1);
Accuracy_Vaj1OfBorder=sum(Part1_correct)/NumBorders*100;
Accuracy_Vaj2OfBorder=sum(Part2_correct)/NumBorders*100;
Border_correct=((Part1_correct==Part2_correct) & (Part1_correct==1));
Accuracy_Border=sum(Border_correct)/NumBorders*100;
% %------
% %with threshold:
% thr=0;
% ThrScr1=NetOut1_Sort(:,1)>=thr;
% a1=(Part1_correct==ThrScr1) & (Part1_correct==1);
% Accuracy_Vaj1OfBorder_withThr=sum(a1)/NumBorders*100;
% 
% ThrScr2=NetOut2_Sort(:,1)>=thr;
% a2=(Part2_correct==ThrScr2) & (Part2_correct==1);
% Accuracy_Vaj2OfBorder_withThr=sum(a2)/NumBorders*100;
% 
% Border_correct_withThreshold=((a1==a2) & (Part1_correct==1));
% Accuracy_Border_withThreshold=sum(Border_correct_withThreshold)/NumBorders*100;
% %----------------------------------
% % Accuracy of each border separately:
% load('AllEvents4.mat');
% BordersAccuracy=[]; NumberOfEachBorderInTrain=[];
% for i=1:size(AllEvents4,1)
%     a3=(AllLabels2_train_part1_lbl(:,1)==AllEvents4{i,1}) & (AllLabels2_train_part2_lbl(:,1)==AllEvents4{i,2});
%     NumberOfEachBorderInTrain(i)=sum(a3);
%     a4=a3 & Border_correct_withThreshold;
%     if NumberOfEachBorderInTrain(i)==0, 
%         BordersAccuracy(i)=-1;
%     else
%         BordersAccuracy(i)=sum(a4)/NumberOfEachBorderInTrain(i)*100;
%     end
% end
% 
% BordersAccuracy0=sum(BordersAccuracy==0);
% BordersAccuracy50=sum(BordersAccuracy>50);
% BordersAccuracy70=sum(BordersAccuracy>70);
% 
% a5=(BordersAccuracy>70); 
% a6=[]; k=0;
% for i=1:size(AllEvents4,1)
%     if a5(i)==1
%         i,k=k+1;
%         a6(k,1:4)=[i,AllEvents4{i,1}, AllEvents4{i,2},NumberOfEachBorderInTrain(i)];
%     end
% end
% 
% for i=1:size(AllEvents4,1)
%      a7(i,1:4)=[AllEvents4{i,1}, AllEvents4{i,2},NumberOfEachBorderInTrain(i),BordersAccuracy(i)];
% end
% [sorted, idx] = sort(a7(:,4),'descend');
% TrainSortedLearnedEvents= a7(idx,:);
% 
% %sokoot:
% indx=find (TrainSortedLearnedEvents(:,2)==30 & TrainSortedLearnedEvents(:,4)>50);
% TrainSortedLearnedEvents(indx,1)
% indx=find (TrainSortedLearnedEvents(:,1)==30 & TrainSortedLearnedEvents(:,4)>50);
% TrainSortedLearnedEvents(indx,2);
% 
% % Bast - Bast Events:
% indx=find (TrainSortedLearnedEvents(:,1)>30 & TrainSortedLearnedEvents(:,2)>30)
% a8=TrainSortedLearnedEvents(indx,3);
% NumberOfBastBastEvents=sum(a8);
% AccuracyOfBastBastEvents=sum(TrainSortedLearnedEvents(indx,4))/size(a8,1);
% %--------------------------------------------------------
% 
% 
% 
% 
% 
% 
% %--------------------------------------------------------
%                         %Writing Results:
% fid =fopen('Results.txt','w');
% fprintf(fid,'\nwithout threshold:  \n');
% fprintf(fid,'Accuracy_Vaj1OfBorder: %f \n',Accuracy_Vaj1OfBorder);
% fprintf(fid,'Accuracy_Vaj2OfBorder: %f \n',Accuracy_Vaj2OfBorder);
% fprintf(fid,'Accuracy_Border: %f \n',Accuracy_Border);
% 
% fprintf(fid,'\n\n\nwith threshold:  \n');
% fprintf(fid,'Threshold: %f \n',NumBorders);
% fprintf(fid,'Accuracy_Vaj1OfBorder_withThr: %f \n',Accuracy_Vaj1OfBorder_withThr);
% fprintf(fid,'Accuracy_Vaj2OfBorder_withThr: %f \n',Accuracy_Vaj2OfBorder_withThr);
% fprintf(fid,'Accuracy_Border_withThreshold: %f \n',Accuracy_Border_withThreshold);
% 
% 
% fprintf(fid,'\n\n');
% fprintf(fid,'NumBorders: %d \n',NumBorders);
% fprintf(fid,'NumBEvents: %d \n',size(AllEvents4,1));
% fprintf(fid,'sum(BordersAccuracy==0): %d \n',BordersAccuracy0);
% fprintf(fid,'sum(BordersAccuracy>50): %d \n',BordersAccuracy50);
% fprintf(fid,'sum(BordersAccuracy>70): %d \n',BordersAccuracy70);
% 
% 
% fprintf(fid,'\n\n\n\n');
% fprintf(fid,'NumberOfBastBastEvents: %d \n',NumberOfBastBastEvents);
% fprintf(fid,'AccuracyOfBastBastEvents: %f \n',AccuracyOfBastBastEvents);
% 
% 
% fprintf(fid,'\n\n\n\n');
% fprintf(fid,'\n\tVaj1 \t\t Vaj2 \t\t NumberOfEachBorder \t\t Accuracy\n');
% for i=1:size(AllEvents4,1)
%     fprintf(fid,'\t%d \t\t %d \t\t\t %d \t\t\t %f\n',TrainSortedLearnedEvents(i,1),TrainSortedLearnedEvents(i,2),TrainSortedLearnedEvents(i,3),TrainSortedLearnedEvents(i,4));
% end
% fclose (fid);
% %--------------------------------------------------------
% 

