clear;clc;

PathName="B://data_PDR/result/矩形路线/MiRecS1.2.csv";
data=load(PathName);Fs=50;
Acc=data(:,2:4);Gyr=data(:,5:7);Mag=data(:,8:10);
Length=size(Gyr,1);Ts=[1:Length]/Fs;

% PathName="B://data_PDR/result/矩形路线/MiRecP1.1.txt";
% Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
% Length=size(Gyr,1);Ts=[1:Length]/Fs;

Acc=Acc(:,1).^2+Acc(:,2).^2+Acc(:,3).^2;
Acc=Acc.^0.5;
% %设置滤波参数
% fs=50;fpass=1;fstop=3;
% Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
% %进行滤波
% [c,d]=butter(n,Wn);
% a=filter(c,d,Acc);
[~,r,~]=SSA(Acc,25,3);
[~,r1,~]=SSA(Acc,25,4);
a=r1-r;
% subplot(2,2,3);
plot(Ts,Acc);
hold on;plot(Ts,a);
xlabel("时间(s)");ylabel("加速度模值(m/s^2)");
xlim([95,100]);
% %低通滤波器
% %设置阻带开始频率与阻带截止频率
% Wp=3/50;Ws=5/50;
% %巴特沃斯滤波器设计
% %[阶数，参数]=buttord[开始频率，截止频率，最小容许噪声，最大噪声]
% [~,Wn]=buttord(Wp,Ws,1,50); 
% %双线性代换参数  [分子，分母]=butter[阶数，参数]
% [c,d]=butter(4,Wn);
% %进行滤波
% %[滤波后]=filter[分子，分母，滤波前数据]
% temp_y=filter(c,d,temp_y1);