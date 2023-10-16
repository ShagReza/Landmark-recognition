% output of VajErrorComputation_with landmark.m for test file:1298
% vajTestCharacter and VajGold Character
%  we computed error for each setence seperately and compute the mean 
%  the error was approximately equall to computing 10 sentences together
%  so we conclude that computing leveneshtine distance,is not dependent to two strings' length

Er=[];
v1=VajGoldCharactor(1:26)
VajGoldCharactor(1:26)=[]
T1=VajTestCharactor(1:24)
VajTestCharactor(1:24)=[]
Er(1)=lev(v1,T1)/length(v1);

v1=[]; T1=[];
v1=VajGoldCharactor(1:28)
VajGoldCharactor(1:28)=[]
T1=VajTestCharactor(1:26)
VajTestCharactor(1:26)=[]
Er(2)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:34)
VajGoldCharactor(1:34)=[]
T1=VajTestCharactor(1:30)
VajTestCharactor(1:30)=[]
Er(3)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:24)
VajGoldCharactor(1:24)=[]
T1=VajTestCharactor(1:24)
VajTestCharactor(1:24)=[]
Er(4)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:25)
VajGoldCharactor(1:25)=[]
T1=VajTestCharactor(1:24)
VajTestCharactor(1:24)=[]
Er(5)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:20)
VajGoldCharactor(1:20)=[]
T1=VajTestCharactor(1:19)
VajTestCharactor(1:19)=[]
Er(6)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:29)
VajGoldCharactor(1:29)=[]
T1=VajTestCharactor(1:25)
VajTestCharactor(1:25)=[]
Er(7)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:30)
VajGoldCharactor(1:30)=[]
T1=VajTestCharactor(1:28)
VajTestCharactor(1:28)=[]
Er(8)=lev(v1,T1)/length(v1);


v1=[]; T1=[];
v1=VajGoldCharactor(1:32)
VajGoldCharactor(1:32)=[]
T1=VajTestCharactor(1:31)
VajTestCharactor(1:31)=[]
Er(9)=lev(v1,T1)/length(v1);



v1=[]; T1=[];
v1=VajGoldCharactor(1:end)
T1=VajTestCharactor(1:end)
Er(10)=lev(v1,T1)/length(v1);

