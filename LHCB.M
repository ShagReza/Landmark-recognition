echo on
%LHCB.m
%                << EXT. HANNING PERCEPTUAL CBFBs CODE BOOK >>
%                ********************************************
%                               ( TRAJECTORY )
%
%
%                                      seyyed salehi 74/1/8
%                                                    74/2/21
%      ---------------------------------------------------------------
%      - copy from hcba.m ( CB is the same ), FOR NEW CONTINOUS DATA
%      - step=512,                            ======================
%      -lfr=1024,size(fft)=1024 ,for DATA BASE  FARSDAT, fs=44100 Hz
%      - square HANNING CBFBs is used ,( 18 Par.s )
%      - OUTPUTS : CB ( TRAJECTORY ) , in : LHCB---.mat
%      - Z ( Desired    ) , in : Z---.mat
%      ---------------------------------------------------------------
echo off
clear
clg
%---------------------input primery information-----------------------
%frmno=3501;%input('First frame no. :   s');
%lfn=3535;%input('Last frame no. :   s');
load matlist
%-------------------------- preset values --------------------------
fs=44100;%Hz
f=fs/1024*(0:174);
% ..... Final freq. is : 7493.6 Hz
bark=6*log(f/600+sqrt((f/600).^2+1));
%plot(bark,f),xlabel('BARK Scale'),ylabel('Freq Scale'),
%title('bark=6*log(f/600+sqrt((f/600).^2+1))'),pause
CBFBS=[];

for zk=1:18,         % 18 par.s
  bk=((bark>=zk-1)&(bark<zk+1));
  cbfb=[bk.*(.5+.5*cos(pi*(bark-zk)))];
  CBFBS=[CBFBS;cbfb];
end


for zk=1:18
    plot(CBFBS(zk,:)), hold on
end

CBFBS=CBFBS';
CBFBS=CBFBS.^2; % Han.^2
w=[.54+.46*cos(2*pi/1023*(-512:511))];
% ..... CBFBs matrix production.
%plot(f,CBFBS,'-b'),title('NEW Hanning CBFBs , in HCBF.M  LIN. Scale'),pause
clear cbfb zk bark  fs
%semilogx(f,CBFBS),title('NEW Hanning CBFBs , in HCBF.M  LOG Scale'),
%xlabel('f, kHz '),pause
% ..... New Han. CBFBs matrix production.
stp=512;
%---------------------------LOOP---------------------------------------
disp('')
disp('====>CODE BOOK : LHCB=HCBA ( 74/1/8 ) is computing.')

%while(frmno<=lfn),
frmno=16;
while(frmno<=length(FN)),
%frmno=1;
%while(frmno<=15),
  fn=num2str(FN(frmno));
  eval(['l',fn]);
  ll=size(L);ll=ll(1);
  CB=zeros(5000,18);
  Z=zeros(1:5000);
  cbn=1;

smpl=[];
smpn=512;
for fpart=1:FNO(frmno),
  fn2=num2str(fpart);
  eval(['load s',fn,fn2]);
  smp=[smpl,smp(:)'];

  while(length(smp)>1023),
    s=smp(1:1024);
    smp(1:stp)=[];
    s=s-mean(s);
    s=s.*w;
    s=fft(s);
    s=s(1:175);
    s=real(s.*conj(s));

    lhcbp=(s*CBFBS);
    lhcbp=log(1+lhcbp);
    CB(cbn,:)=lhcbp;
% .....  LHCBP , Unnormalized Parameters ,sqrt(Energy of Every Filter).

%    axis([1 18 10 32])
%    plot(lhcbp),xlabel(num2str(cbn))

    [aa,bb]=max(L(:,3)<ones(1:ll)'*smpn & L(:,4)>=ones(1:ll)'*smpn);
    if aa==0,
      z=40;
    else
      z=L(bb,1);
    end
    Z(cbn)=z;

    cbn=cbn+1;
    smpn=smpn+stp;
  end
  smpl=smp;smp=[];
  disp([fn,fn2,'   ',num2str(cbn)])
end
  CB=CB(1:cbn-1,:);
  Z=Z(1:cbn-1);
  eval(['save lhcbun\lhcu',fn,' CB'])
  eval(['save lhcbun\z',fn,' Z']);
  frmno=frmno+1;
end
clear CBFBS smp smpl w s lhcbp stp frmno



