%---------2019/3/12---------%
%步长计算主程序入口
clear;clc;
filename=strcat('B:\data_PDR\result\携带位置相同训练\handon\slow(1).csv');
% filename=strcat('B:\data_PDR\result\矩形路线\MiRecMix1.2.csv');
% filename=strcat('B:\data_PDR\result\携带位置混合\MiRecMix1.4.csv');
% filename=strcat('B:\data_PDR\Others\Pocket.txt');
% filename=strcat('B:\data_PDR\4.txt');
% filename=strcat('B:\data_PDR\result\Stair\19.txt');
% 读取加速度数据
RawData=load(filename);
% RawAcc=RawData(:,1:3);Time=[1:size(RawAcc,1)]*0.02;
Time=RawData(:,1);RawAcc=RawData(:,2:4);
% plot(Time,RawAcc);

%获取手机携带位置信息，并代入初始姿态
[Position,Kscale]=GetCarryPosition(RawAcc);

%打开图，设置左右y轴属性
% fig = figure;
% left_color = [0 0 0];
% right_color = [0 0 0];
% set(fig,'defaultAxesColorOrder',[left_color; right_color]);
% 
% % 激活左侧
% yyaxis left
% plot(Time,RawAcc(:,1),'b'); 
% hold on
% plot(Time,RawAcc(:,2),'g'); 
% plot(Time,RawAcc(:,3),'y'); 
% ylabel('加速度(m/s^2)')
%设置刻度
% axis([1 5 98.8 99.4]);
% set(gca,'YTick',[98.8 99 99.2 99.4]);
% 激活右侧
% yyaxis right
% plot(Time, Position,'b--s', 'LineWidth',1.5);
% ylabel('位置编号')
% xlabel('时间/s')
% set(gca,'YTick',[1 2 3 4]);


%MotionAcc是2Hz周期性运动引起的加速度  XXX
%更改为SSA分析得到的行走引起的加速度变化的模值
[MotionAcc,AccMo]=RawDataProcess(RawAcc);
%获得步频检测点与步数
% figure;hold on;
% subplot(2,2,1);hold on;
% plot(Time,AccMo);
% plot(Time,MotionAcc);
% [x] = GetStepNumber(MotionAcc);
% plot(x,MotionAcc(x),'rx');
% x=x';
% [Feachers0] = GetMachineFea(RawData(:,2:4),x);
% [Feachers1] = GetMachineFea(RawData(:,5:7),x);
% 
% Feachers=[Feachers0,Feachers1];
% 获取设备姿态
% [Att]=GetAtt(RawAcc,Position);
% TnbAcc=GetAccAngle(RawAcc(1:x(1),:));
% RawAcc=AngleFF(TnbAcc,RawAcc);
%获取水平方向加速度
%在检步点处进行分割
% MainAcc=GetMainAcc(RawAcc,Att);
% figure;plot(MainAcc(1:x(1),2));
% figure;hold on;
% plot(MainAcc(:,2));
% plot(x,MainAcc(x,2),'rx');
%对前进轴的数据进行SSA滤波
% MainAccy=SSAfit(MainAcc(:,2));
% figure;
% plot(MainAcc(:,2))
% figure;hold on;
% plot(MainAccy);
% plot(x,MainAccy(x,:),'rx');
%通过第一个加速度数据获取初速度
% V0=trapz(MainAcc(5:x(1),2));
% V0=GetV0(MainAcc(1:x(3),2),x(1));
% 参数设置
%   CanShu=[A,B,H,Q,R];
%对处理后的数据进行特征提取
% [DetV,Ts,SL0,Z,Label]=GetDetV(MainAcc(:,2),x,Position);
%获取步长
% SL=KalmanFit(SL0,[DetV,Ts],Z,Label);
% [SL,V]=GetStepLength(V0,DetV,Ts);
% figure;hist(SL);title('步长统计图');sum(SL)
% figure;hist(V);title('速度统计图');

