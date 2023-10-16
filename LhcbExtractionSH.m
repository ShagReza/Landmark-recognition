% LHCB extraction
%---------------------------------------------------------------
clc,clear all,close all


%For 18 parameters and freq:22050
% M=512
% L=175%175
% N=18   %18
% a=1
% stp=256;
% a1=1
% a2=18
% fs=22050


%For 64 parameters and freq:22050
% M=512
% L=175%175
% N=64 %18
% a=1
% stp=256;
% a1=0.3
% a2=64
% fs=22050


M=512
L=175%175
N=18 %18
a=1
stp=256;
a1=1
a2=18
fs=22050

%---------------------------------------------------------------
f=fs/M*(0:(L-1));
bark=6*log(f/600+sqrt((f/600).^2+1));
CBFBS=[];

for zk=1:a1:a2,         % 64 par.s
  bk=((bark>=zk-a)&(bark<zk+a));
  cbfb=[bk.*(.5+.5*cos(pi*(bark-zk)))];
  CBFBS=[CBFBS;cbfb];
end

for zk=1:N
    plot(CBFBS(zk,:)), hold on
end

CBFBS=CBFBS';
CBFBS=CBFBS.^2; % Han.^2
w=[.54+.46*cos(2*pi/(M-1)*(-1*stp:(stp-1)))];
%---------------------------------------------------------------
%pre processings:
Files=dir('D:\Shapar\ShaghayeghUni\AfterPropozal\SmalFarsdat\*.wav');
for i=1:length(Files)
    i
    [smp,fs]=audioread(['D:\Shapar\ShaghayeghUni\AfterPropozal\SmalFarsdat\',Files(i).name]);
    CB=[];
    cbn=1;
    while(length(smp)>=M)
        s=smp(1:M);
        smp(1:stp)=[];
        s=s-mean(s);
        s=s.*w;
        s=fft(s);
        s=s(1:L);
        s=real(s.*conj(s));
        
        lhcbp=(s*CBFBS);
        lhcbp=log(1+lhcbp);
        CB(cbn,:)=lhcbp;
        cbn=cbn+1;
    end
    name=Files(i).name;
    name=strrep(name,'.WAV','.mat');
    save(name, 'CB');
end
 %---------------------------------------------------------------


%normalization method?

%1024:24 mili secenond















