%leveneshtein distance

function d=lev(s,t)



s=char(s);
t=char(t);
m=length(s);
n=length(t);
x=0:n;
y=zeros(1,n+1);

for i=1:m
    y(1)=i;
    for j=1:n
        c=(s(i)~=t(j));
        y(j+1)=min([y(j)+1,x(j+1)+1,x(j)+c]);
    end
    [x,y]=deal(y,x);
end
d=x(n+1);


end