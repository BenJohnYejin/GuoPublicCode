clear all;
clc;
[FileName,PathName] = uigetfile('*.txt',...
                '小米5 加速度数据'); 
            file1=fullfile(PathName,FileName);                                                                                                                                                                                                             
            data1=load(file1);

A1(:,1)=data1(:,1);A1(:,2)=data1(:,4);A1(:,3)=data1(:,5);A1(:,4)=data1(:,6);

figure(1); 
subplot(4,1,1)
  axis equal;  
plot(A1(:,1))  
xlabel('时间/min'), ylabel('X轴/m/s^2')
%     xlim([-3,123]); ylim([-0.05,0.05]);

grid on;
subplot(4,1,2)
plot(A1(:,2))  
xlabel('时间/min'), ylabel('Y轴/m/s^2')
%     xlim([-3,123]);ylim([-0.05,0.05]);
grid on;
subplot(4,1,3)
plot(A1(:,3)')  
xlabel('时间/min'), ylabel('Z轴/m/s^2')
%     xlim([-3,123]);ylim([-0.2,0.2]);
grid on;
subplot(4,1,4)
plot(A1(:,4))  
xlabel('时间/min'), ylabel('Z轴/m/s^2')
%     xlim([-3,123]);ylim([-0.2,0.2]);
grid on;
suptitle('小米5 加速度数据');


