%-----------------------------------------------------
%%% Dividing data to train test and validation
%-----------------------------------------------------
clc,clear all,close all

pTrain=60; % 60 percent of all data
pTest=20;
pVal=20;


load('SmalFarsdatTestNames.mat');
load('SmalFarsdatTrainNames.mat');

Names= [SmalFarsdatTrainNames,SmalFarsdatTestNames];
N=length(Names);

n=floor(N/100);
Test=1:pTest*n;
Val=pTest*n+1:pTest*n+pVal*n;
Train=pTest*n+pVal*n+1:N;

TestNames=Names(Test);
ValNames=Names(Val);
TrainNames=Names(Train);


save('TestNames','TestNames');
save('ValNames','ValNames');
save('TrainNames','TrainNames');
