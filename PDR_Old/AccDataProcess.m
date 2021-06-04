function [a,temp] = AccDataProcess(Acc)
ax=Acc(:,1);ay=Acc(:,2);az=Acc(:,3);
%将三轴数据进行求模处理
temp=(ax.^2+ay.^2+az.^2).^0.5;
% plot(temp);hold on;
% [~,r,~]=SSA(temp,50,3);
% [~,r1,~]=SSA(temp,50,4);
% a=r1-r;
%设置滤波参数
fs=50;fpass=1;fstop=3;
Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%进行滤波
[c,d]=butter(n,Wn);
a=filter(c,d,temp);
end