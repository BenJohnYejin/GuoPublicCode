clear;clc;
deg=180/3.1415926;
%%
%2020/7/1  PDR解算程序
%%---------------------数据读取
% PathName="B://data_PDR/result/矩形路线/MiRecT1.3.csv";
% PathName="B://data_PDR/result/携带位置相同训练/Handon/Slow(1).csv";
% PathName="B://data_PDR/result/携带位置混合/mix3.csv";
% data=load(PathName);Fs=50;
% Acc=data(:,2:4);Gyr=data(:,5:7);Mag=data(:,8:10);

%  read the data form file
% PathName="B://data_PDR/result/圆形路线/2.txt";
% PathName="B://data_PDR/result/Swing3.txt";
% PathName="B://data_PDR/result/矩形路线/MiRecT1.1.txt";
PathName="B://temp//route6.txt";
Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
% Mag=MagAl(Mag);

% load('MagBase.mat');
% MagBase=MagBaseText;
%%
%%--------------------步频检测----------------------%%
%Detecte the Step
[TimeDete,Acc1]=StepDetecte(Acc,Fs);
Length=size(Acc,1);Ts=[1:Length]/Fs;
StepCount=length(TimeDete);

%%
%-------定义变量
Att=zeros(Length,3);Xk0=zeros(Length,7);
Pk0=zeros(Length,7);NaviAcc=zeros(Length,3);

V=zeros(StepCount,1);Time=zeros(StepCount,1);
Z=zeros(StepCount,1);

kfinitsl();
kfsl.xk=0.80;

Result=zeros(StepCount,4);
Result(1,:)=[kfsl.xk,kfsl.Qk,kfsl.Rk,kfsl.Pk];
Cor=zeros(StepCount,2);Cor(1,:)=[0,0];

%%
%Get the phone motion
[Position,Scale,Motion]=PhoneMotionRecon(Acc,TimeDete);

%%
%对数据进行处理
att0=[0,0,0];ahrs = AhrsInit(1/Fs,att0);
s=1;Start=TimeDete(s);

AccPiece =Acc(1:Start,:);GyrPiece =Gyr(1:Start,:);MagPiece=Mag(1:Start,:);
for k=1:Start
    ahrs=AhrsUpdate(ahrs,AccPiece(k,:), GyrPiece(k,:),MagPiece(k,:),4);  
    Xk0(k,:)=ahrs.kf.xk';
    Att(k,:)=q2att(Xk0(k,1:4));
    Att(k,3)=PitchSmooth(Att(k,3));
    Pk0(k,:)=diag(ahrs.kf.Pxk);
    NaviAcc(k,:)=(ahrs.Cnb*AccPiece(k,:)')';
end

%%
%%--------------------解算----------------------%%
%%-----------------------------------------------
for j=s:2:StepCount-2
    % 提取出数据片段
    Start=TimeDete(j);Mid = TimeDete(j+1);End=TimeDete(j+2);
    AccPiece =Acc(Start:End,:);GyrPiece =Gyr(Start:End,:);MagPiece=Mag(Start:End,:);
    
%     MagList=GetMagList(Cor(j,:),Att(Start-1,3),kfsl.xk,MagBase,Mid-Start+1);
    
    %对加速度信号进行处理
%     AccPiece=SSAProcess(AccPiece,1);
%     MagPiece=SSAProcess(MagPiece,2);

    %解算第一步姿态
    %对姿态进行解算
    for k=1:Mid-Start
        %使用卡尔曼滤波算法更新四元数
%         ahrs=AhrsUpdate(ahrs,AccPiece(k,:), GyrPiece(k,:),MagPiece(k,:),MagList(k));
        ahrs=AhrsUpdate(ahrs,AccPiece(k,:), GyrPiece(k,:),MagPiece(k,:),4);
        %获取姿态向量
        Xk0(Start+k-1,:)=ahrs.kf.xk';Pk0(Start+k-1,:)=diag(ahrs.kf.Pxk);
        Att(Start+k-1,:)=q2att(Xk0(Start+k-1,1:4))';
        Att(k,3)=PitchSmooth(Att(k,3));
        %获取导航坐标系下三轴加速度
        NaviAcc(Start+k-1,:)=(ahrs.Cnb*AccPiece(k,:)')';
    end
    %对行人步长进行估计
    [kfsl,V(j),Time(j),Z(j)] = kfupdatasl(kfsl,NaviAcc(Start:Mid,:),Position(j));
    Result(j+1,:)=[kfsl.xk,kfsl.Qk,kfsl.Rk,kfsl.Pk];
    Cor(j+1,:)=GetCor(Cor(j,:),kfsl.xk,Att(Start,3));
    
    %获取磁力计向量
%     MagList1=GetMagList(Cor(j+1,:),Att(Start-1,3),kfsl.xk,MagBase,End-Mid+1);
%     k1=0;
    %解算第二步姿态
    for k=Mid-Start:End-Start-1
%         k1=k1+1;
        %使用卡尔曼滤波算法更新四元数
%         ahrs=AhrsUpdate(ahrs,AccPiece(k,:), GyrPiece(k,:),MagPiece(k,:),MagList1(k1));
        ahrs=AhrsUpdate(ahrs,AccPiece(k,:), GyrPiece(k,:),MagPiece(k,:),4);
        %获取值
        Xk0(Start+k,:)=ahrs.kf.xk';Pk0(Start+k,:)=diag(ahrs.kf.Pxk);
        Att(Start+k,:)=q2att(Xk0(Start+k,1:4))';
        Att(k,3)=PitchSmooth(Att(k,3));
        %获取导航坐标系下三轴加速度
        NaviAcc(Start+k,:)=(ahrs.Cnb*AccPiece(k,:)')';
    end
    %第二步的步长
    [kfsl,V(j+1),Time(j+1),Z(j+1)] = kfupdatasl(kfsl,NaviAcc(Mid:End,:),Position(j+1));
    Result(j+2,:)=[kfsl.xk,kfsl.Qk,kfsl.Rk,kfsl.Pk];
    Cor(j+2,:)=GetCor(Cor(j+1,:),kfsl.xk,Att(Mid,3));
end

% Cor=GetCor([0,0],0.8,Att1(:,3));
% PlotPosition(Cor);
% Distance=sum(Result(:,1));
% disp("行走距离为"+Distance );

figure;
plot(Cor(:,1),Cor(:,2));
title("轨迹图");
xlabel("X坐标");ylabel("Y坐标");
grid on;
% hold on;
% % load('TureCor1.mat');
% load('TureCor.mat');
% plot(TureCor(:,1),TureCor(:,2));
% legend("预测轨迹","实测轨迹");

figure
ShowSignal(Ts,Att);
subplot(3,1,1);grid on;
% legend('二阶龙格-库塔法','文中方法');
xlabel("时间(s)");ylabel("俯仰角(°)");
subplot(3,1,2);grid on;
% legend('二阶龙格-库塔法','文中方法');
xlabel("时间(s)");ylabel("横滚角(°)");
subplot(3,1,3);grid on;
% legend('二阶龙格-库塔法','文中方法');
xlabel("时间(s)");ylabel("航向角(°)");
