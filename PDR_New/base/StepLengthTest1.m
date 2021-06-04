clc,clear;
glvf;
%读取文件
% PathName="B://DataForFinal/Data/Change.txt";
% Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
Data=load("B:\data_PDR\result\MiRecMix1.4.csv");
Acc=Data(:,2:4);Gyr=Data(:,5:7);Fs=50;
Len=size(Acc,1);Ts=(1:Len)/50;imu=[Gyr*0.02,Acc];
%获取步频
[TimeDete,~,AccMo]=StepDetecte(Acc,Fs);
%获取导航坐标系下的加速度值
att0=[0;0;pi/2];
avp=QEAHRSTest(imu,[], att0);
Att=avp(:,1:3);
%将加速度值转换到导航系下
AccH=AccTransform(Acc,Att);
%提取特征值
[Wenig,DetV,Fs,Kim,AccM]=GetFea(AccH,TimeDete);
%获取步数
StepCount=length(TimeDete);
figure;
plot(Att(TimeDete,3));
% End=5;
% Wenig(1:End)=[];DetV(1:End)=[];
% Fs(1:End)=[];Kim(1:End)=[];

% Wenig(end-4:end)=[];DetV(end-4:end)=[];
% Fs(end-4:end)=[];Kim(end-4:end)=[];
%473
% H=sum(Kim)/250;
% H1=sum(Wenig)/250;
% Texting
% H1=1.9901;
% H=2.5197;
% Call
% H1=1.1977;
H=2.6538;
% Weinberg
% H=2.1212;
% H1=2.1729;
% Pocket
% H=2.92;

kf.xk=0.70;
kf.Qk=0.025;kf.Qmax=0.1;kf.Qmin=0.01;
kf.Rk=0.010;kf.Rmax=0.1;kf.Rmin=0.001;
kf.Pk=0.031;kf.Pmax=1.0;kf.Pmin=0.001;
kf.Phkk_1=1;
SL=zeros(StepCount,1);SL(1)=0.70;

 
for j=1:50
% for j=51:124
% for j=129:176
% for j=181:260
% for j=391:562 
% for j=1:StepCount-1
    %一步预测
    kf.xkk_1=kf.xk+0.5*DetV(j)*Fs(j);
    %2. 预测方差阵
    kf.Pk=kf.Pk+kf.Qk;
    %3. 滤波增益
    kf.Kk=kf.Pk*H'/(H*kf.Pk*H'+kf.Rk);
    %4. 状态估计
%     r=Wenig(j)-H*kf.xkk_1;
    r=Kim(j)-H*kf.xkk_1;
    kf.xk=kf.xkk_1+kf.Kk*r;
    %5. 估计方差阵 
    kf.Pk=(1-kf.Kk*H)*kf.Pk;
   
    P(j+1)=kf.Pk;
    SL(j+1)=kf.xk;
end

% dlmwrite("B:\DataForFinal\步长\PocketRecSL.txt",SL);
% 
% SL0=load("B:\DataForFinal\步长\TextLongSL.txt");
% SL1=load("B:\DataForFinal\步长\CallLongSL.txt");
% SL2=load("B:\DataForFinal\步长\SwingLongSL.txt");
% SL3=load("B:\DataForFinal\步长\PocketLongSL.txt");
% 
% figure; hold on;
% Start=5;End=5;
% plot(SL0(Start:end-End),"LineWidth",2.0);
% plot(SL1(Start:end-End-4),"LineWidth",2.0);
% plot(SL2(Start:end-End-28),"LineWidth",2.0);
% plot(SL3(Start:end-End-8),"LineWidth",2.0);
% legend("发信息位置","打电话位置","摆臂位置","口袋位置")
% grid on;xlabel("步伐/步");ylabel("步长/m");

% figure; hold on;
% plot(Ts,Acc);xlabel("时间/s");ylabel("加速度/（m/s^2）");
% plot(Ts,AccMo);xlim([20,30]);grid on;
% legend("X轴加速度","Y轴加速度","Z轴加速度","加速度模值");


% figure;hold on;
% plot(Wenig,'LineWidth',2.0);
% plot(Kim,'LineWidth',2.0);
% plot(Fs,'LineWidth',2.0);
% plot(DetV,'LineWidth',2.0);
% grid on;xlabel("步伐/步");ylabel("值");
% legend("Weinberg模型特征","Kim模型特征");

%提取特定步数的信号
%写入到文件中
% for j=20:120
%     Start=TimeDete(j);
%     End=TimeDete(j+1);
%     [AccPiece]=Acc(Start:End,:);
%     [GyrPiece]=Gyr(Start:End,:);
%     dlmwrite("B://Accx.txt",AccPiece(:,1)','-Append');
%     dlmwrite("B://Accy.txt",AccPiece(:,2)','-Append');
%     dlmwrite("B://Accz.txt",AccPiece(:,3)','-Append');
%     
%     dlmwrite("B://Gyrx.txt",GyrPiece(:,1)','-Append');
%     dlmwrite("B://Gyry.txt",GyrPiece(:,2)','-Append');
%     dlmwrite("B://Gyrz.txt",GyrPiece(:,3)','-Append');
% end


% Length=size(Acc,1);Ts=(1:Length)/50;
% subplot(2,2,3);
% plot(Ts,AccMO);hold on;
% % plot(TimeDete/50,AccM(TimeDete),'ro');
% xlabel("时间/s");ylabel("加速度/(m/s^2)");
% grid on;
% legend("加速度模值");
% % legend("提取后的加速度信号","步频点");
% xlim([20,40]);

