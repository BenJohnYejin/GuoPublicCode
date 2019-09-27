function Acc_But = Buttworth(Acc,n) 
[z,p,k]=buttap(10);        %设计butterworth滤波器
% [z,p,k]=buttap(1);        %设计butterworth滤波器
[b,a]=zp2tf(z,p,k); 
for i=1:11
   Acc_But(i,1)=Acc(i,1);
end
for  i=12:n
   Acc_But(i,1)=b(1,11)*Acc(i-11,1)-a(1,2)*Acc(i-1,1)-a(1,3)*Acc(i-2,1)-a(1,4)*Acc(i-3,1)-a(1,5)*Acc(i-4,1)-a(1,6)*Acc(i-5,1)-a(1,7)*Acc(i-6,1)-a(1,8)*Acc(i-7,1)-a(1,9)*Acc(i-8,1)-a(1,10)*Acc(i-9,1)-a(1,11)*Acc(i-10,1);
   end
end