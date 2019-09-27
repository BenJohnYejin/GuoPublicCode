clear all;
clc;
[FileName,PathName] = uigetfile('*.txt',...
                '小米5 加速度数据'); 
            file1=fullfile(PathName,FileName);                                                                                                                                                                                                             
            data1=load(file1);
 [FileName,PathName] = uigetfile('*.txt',...
                '小米5 陀螺仪数据'); 
            file1=fullfile(PathName,FileName);                                                                                                                                                                                                             
            data2=load(file1);
 [FileName,PathName] = uigetfile('*.txt',...
                '小米6 加速度数据'); 
            file1=fullfile(PathName,FileName);                                                                                                                                                                                                             
            data3=load(file1);
[FileName,PathName] = uigetfile('*.txt',...
                '小米6 陀螺仪数据'); 
            file1=fullfile(PathName,FileName);                                                                                                                                                                                                             
            data4=load(file1);
A1=data1;
A2=data2;
A3=data3;
A4=data4;

figure(1); 

  axis equal;  
subplot(3,1,1) 
plot(A1(:,1),A1(:,2),'-')  
xlabel('时间/min'), ylabel('X轴/m/s^2')
%     xlim([-3,123]); ylim([-0.05,0.05]);

grid on;
subplot(3,1,2)
plot(A1(:,1),A1(:,3),'-')  
xlabel('时间/min'), ylabel('Y轴/m/s^2')
%     xlim([-3,123]);ylim([-0.05,0.05]);
grid on;
subplot(3,1,3)
plot(A1(:,1),A1(:,4),'-')  
xlabel('时间/min'), ylabel('Z轴/m/s^2')
%     xlim([-3,123]);ylim([-0.2,0.2]);
grid on;
suptitle('小米5 加速度数据');

figure(2);   
title('小米5 陀螺仪数据');
  axis equal;
subplot(3,1,1) 
plot(A2(:,1),A2(:,2),'-')  
xlabel('时间/min'), ylabel('X轴/rad/s')
%     xlim([-3,123]);ylim([-0.005,0.005]);
grid on;
subplot(3,1,2)
plot(A2(:,1),A2(:,3),'-')  
xlabel('时间/min'), ylabel('Y轴/rad/s')
%     xlim([-3,123]);ylim([-0.01,0.01]);
grid on;
subplot(3,1,3)
plot(A2(:,1),A2(:,4),'-')  
xlabel('时间/min'), ylabel('Z轴/rad/s')
%     xlim([-3,123]);ylim([-0.002,0.002]);
grid on;
suptitle('小米5 陀螺仪数据');

figure(3);
  axis equal;
subplot(3,1,1) 
plot(A3(:,1),A3(:,2),'-')  
xlabel('时间/min'), ylabel('X轴/m/s^2')
%     xlim([-3,123]);ylim([-0.05,0.05]);
grid on;
subplot(3,1,2)
plot(A3(:,1),A3(:,3),'-')  
xlabel('时间/min'), ylabel('Y轴/m/s^2')
%     xlim([-3,123]);ylim([-0.05,0.05]);
grid on;
subplot(3,1,3)
plot(A3(:,1),A3(:,4),'-')  
xlabel('时间/min'), ylabel('Z轴/m/s^2')
%     xlim([-3,123]);ylim([-0.2,0.2]);
grid on;
suptitle('小米6 加速度数据');


figure(4); 
  axis equal;
subplot(3,1,1) 
plot(A4(:,1),A4(:,2),'-')  
xlabel('时间/min'), ylabel('X轴/rad/s')
%     xlim([-3,123]);ylim([-0.005,0.005]);
grid on;
subplot(3,1,2)
plot(A4(:,1),A4(:,3),'-')  
xlabel('时间/min'), ylabel('Y轴/m/rad/s')
%     xlim([-3,123]);ylim([-0.01,0.01]);
grid on;
subplot(3,1,3)
plot(A4(:,1),A4(:,4),'-')  
xlabel('时间/min'), ylabel('Z轴/rad/s')
%     xlim([-3,123]);ylim([-0.002,0.002]);
grid on;
suptitle('小米6 陀螺仪数据');
