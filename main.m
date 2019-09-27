% function[Count,StepPoint,Lstep] = main()
clear all;
clc;
[A,n,T]=caiyang;   
P_Acc=Pinghua(A,n);         %数据平滑处理
Kal_Acc=Kaerman(P_Acc,n);   %卡尔曼滤波
But_Acc=Buttworth(P_Acc,n); %巴特沃斯滤波
[Count,StepPoint,Lstep] = Jianbu(P_Acc,n,T);%检步
% a=length(StepPoint)
% b=length(Lstep)
% c=Count
% end
