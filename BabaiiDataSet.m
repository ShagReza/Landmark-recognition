% Babaii 2018 DataSet
clc, clear all,close all
ValBabai=[9,18,36,46,49,63,80,98,103,113,115,118,135,144,149,150,159,162,168,169,190,206,209,214,222,226,239,254,255,259,263,270,271,272,276,277,278,281,282,284,285,286,287,289,290,291,292,294,296,299];
TestBabi=[7,10,32,37,44,90,97,125,139,143,152,155,167,172,181,212,213,219,225,233,236,242,250,273,274,275,280,283,288,295];
ValTest=[ValBabai,TestBabi];
k=0;
for i=1:304
    if isempty(find (ValTest==i))
        k=k+1;
        TrainBabai(k)=i;
    end
end

ValBabaiName=[];
for i=1:length(  ValBabai)
    ValBabaiName=[ValBabaiName,str2num(['1',num2str(ValBabai(i))]),str2num(['2',num2str(ValBabai(i))])];
end


TestBabiName=[];
for i=1:length(  TestBabi)
    TestBabiName=[TestBabiName,str2num(['1',num2str(TestBabi(i))]),str2num(['2',num2str(TestBabi(i))])];
end


TrainBabaiName=[];
for i=1:length(  TrainBabai)
    TrainBabaiName=[TrainBabaiName,str2num(['1',num2str(TrainBabai(i))]),str2num(['2',num2str(TrainBabai(i))])];
end

save('ValBabaiName','ValBabaiName')
save('TestBabiName','TestBabiName')
save('TrainBabaiName','TrainBabaiName')