clear;

PathName="B://DataForFinal/Data/TextingRec.txt";
Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
[TimeDete,Acc,AccM]=StepDetecte(Acc,Fs);

subplot(2,2,4);
title("(d) 口袋位置")
Len=size(Gyr,1);Ts=[1:Len]/50;
plot(Ts,AccM,'LineWidth',2.0);hold on;
plot(Ts,Acc,'LineWidth',2.0);
plot(Ts(TimeDete),Acc(TimeDete),'blacko')
xlim([30,40]);grid on;
xlabel("时间/s");ylabel("加速度值/m/s^2");
legend("原始信号","奇异谱分析信号","步频点")

%文件路径
fs=50;fpass=1;fstop=3;
Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%进行滤波
[c,d]=butter(n,Wn);
Acc1=filter(c,d,AccM);
plot(Ts,Acc1,'LineWidth',2.0);
% 低通滤波器
% 设置阻带开始频率与阻带截止频率
Wp=3/50;Ws=5/50;
% 巴特沃斯滤波器设计
% [阶数，参数]=buttord[开始频率，截止频率，最小容许噪声，最大噪声]
[~,Wn]=buttord(Wp,Ws,1,50); 
% 双线性代换参数  [分子，分母]=butter[阶数，参数]
[c,d]=butter(4,Wn);
% 进行滤波
% [滤波后]=filter[分子，分母，滤波前数据]
Acc2=filter(c,d,AccM);
plot(Ts,Acc2,'LineWidth',2.0);
plot(Ts,Acc,'LineWidth',2.0);

legend("原始信号","带通滤波","低通滤波","奇异谱分析")
