function P = Pinghua(Acc,n) 
a=3;   %Æ½»¬½×Êý
P=zeros(n,1); 
for i=1:n-a
    for j=0:a-1
        P(i,1)=Acc(i+a,4)/a+P(i,1);
    end
end
end
