%-----------------2019/4/18-----------------%
clear;clc;
%文件打开窗口
[accFileName,accPathName]=uigetfile('*.csv','MultiSelect','on');
if accPathName==0
    return ;     
end

fileList=fullfile(accPathName,accFileName);
nFile=size(fileList,2);
%读取文件操作
for i=1:nFile
    if nFile==1
        RawData=load(char(fileList)); 
        Time=RawData(:,1);
        a=RawDataProcess(RawData(:,2),RawData(:,3),RawData(:,4));
        [x,y]=GetStepNumber(Time,a);
%         [Feacher,test]=GetAccFeacher(a,y);
    else
        RawData=load(char(fileList(i))); 
        Time=RawData(:,1);
        a=RawDataProcess(RawData(:,2),RawData(:,3),RawData(:,4));
        [x,y]=GetStepNumber(Time,a);
%         [Feacher,test]=GetAccFeacher(a,y);
    end
end

%-----------2019/3/11-----------%
%对原始数据进行处理
%输入数据  ax,ay,az为原始的三轴数据
%输出数据  a作为处理后的数据
function [a] = RawDataProcess(ax,ay,az)
%将三轴数据进行求模处理
temp=(ax.^2+ay.^2+az.^2).^0.5;
% plot(temp);hold on;

%设置滤波参数
fs=50;fpass=1;fstop=3;
Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%进行滤波
[c,d]=butter(n,Wn);
a=filter(c,d,temp);
% plot(a);
end
%---------2019/3/11------------%
%使用峰值探测算法进行步频探测
%输入参数  a为滤波后的加速度数据 Time为滤波后的时间信息
%输出参数  y为探测到的峰值点  x为峰值点对应的时间点
function [x,y] = GetStepNumber(Time,a)

temp_x=Time;temp_y=a;
x=zeros(1,10);y=zeros(1,10);
j=1;

for i =50*5+11: max(size(temp_y))-10-3*50
    temp=temp_y(i-10:i+10);
    %找到峰值点 %这一步的时间大于0.45
    if (max(temp)==temp_y(i) && temp_x(i)-x(j)>0.4  && temp_y(i)>2 )
            x(j+1)=temp_x(i);y(j+1)=temp_y(i);
            j=j+1;
    end
end  
    %由于第一步是预先设置的点 所以去除第一步的标志点
    x(1)=[];y(1)=[];
    %发信息,打电话状态需要删除第一步
%     x(1)=[];y(1)=[];
    
    plot(Time,a);hold on;
    plot(x,y,'.','MarkerSize',20);
end
