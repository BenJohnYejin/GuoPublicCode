% function [ ] =Swing_arm( )
clc
clear all
%——--------------------------读入数据---------------------------------%
[FileName,PathName] = uigetfile('*.txt',...
    '数据文件');
file=fullfile(PathName,FileName);
data=load(file);
Acce=data(:,1:3);
Grav=data(:,4:6);
Gyro=data(:,10:12);
[m,n]=size(Grav);
for i=1:m
    Acce_amp(i)=sqrt(Acce(i,1)*Acce(i,1)+Acce(i,2)*Acce(i,2)+Acce(i,3)*Acce(i,3));
%         Acce_amp(i)=Acce(i,1);
end
Acce_g=9.8*ones(m);



%%
%航向解算
zitai(1,1:3)=[-90*pi/180,0*pi/180,-90*pi/180];                    %------------------------zitai以弧度为单位
h=1/50;
% h=1/100;
[p1(1),p2(1),p3(1),p4(1),cbn(1:3,1:3,1)]=initial_Quaternion(zitai(1,1),zitai(1,2),zitai(1,3));
for i=2:m
    [zitai(i,1),zitai(i,2),zitai(i,3),cbn(1:3,1:3,i),p1(i),p2(i),p3(i),p4(i)]...
        =Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),Gyro(i-1,1),Gyro(i-1,2),Gyro(i-1,3),Gyro(i,1),Gyro(i,2),Gyro(i,3),h);
end; 
%% 重力计匹配航向
h1= figure('Name','滤波前后重力计数据对比','NumberTitle','off');
axis equal;
subplot(211)
plot(Grav(:,1),'-b')
xlabel('历元'), ylabel('m/s^2')
subplot(212)
plot(zitai(:,3)*180/pi,'-b')
title('陀螺仪解算航向')
xlabel('历元'), ylabel('度/°')
%% 加速度计匹配航向
fp=3;              %通带截止频率;
fs=4;              %阻带截止频率
% fp=2;              %通带截止频率;
% fs=2.2;              %阻带截止频率
Wp=2*fp/50;           %标准化通带截止频率
Ws=2*fs/50;           %标准化阻带截止频率
Rp=1;                %通带最大衰减（dB）
Rs=3;                %阻带最小衰减（dB）
[n,Wn] = buttord(Wp,Ws,Rp,Rs);%得到巴特沃斯滤波器的最小阶数n和3dB截止角频率wn
[b,a] = butter(n,Wn);%得到低通数字巴特沃斯滤波器分子b和分母a(b、a均为n+1维行向量)
filter_Acce_amp = filter(b,a,Acce_amp);

% time_filter_Acce_amp=filter_Acce_amp(5:end);
% % time_filter_Acce_amp=filter_Acce_amp(19:end);
% h2= figure('Name','滤波前后加速度幅值对比','NumberTitle','off');
% axis equal;
% plot(time_filter_Acce_amp,'-r')
% hold on
% plot(Acce_amp,'-b')
% xlabel('历元'), ylabel('m/s^2')
% grid on;
% 
% % 
time_filter_Acce_amp=filter_Acce_amp(5:end);
h2= figure('Name','滤波前后加速度幅值对比','NumberTitle','off');
axis equal;
subplot(211)
plot(time_filter_Acce_amp,'-r')
hold on
xlabel('历元'), ylabel('m/s^2')
subplot(212)
plot(zitai(:,3)*180/pi,'-b')
title('陀螺仪解算航向')
xlabel('历元'), ylabel('度/°')



