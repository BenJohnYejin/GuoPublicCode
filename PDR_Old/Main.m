%---------2019/3/12---------%
% clc;clear;
% filename=strcat('B:\data_PDR\result\携带位置相同训练\slow(1).csv');
% RawData=load(filename);
% Time=RawData(:,1);
% a=RawDataProcess(RawData(:,2),RawData(:,3),RawData(:,4));
% [x,y]=GetStepNumber(Time,a);
%模型的参数
%Handon情况下----------------
%     % 1. SL=a*Fs+b*Var+c
%     a1=0.079;b1=0.015;c1=0.620;
%     % 2. SL=a2*Fa1+b2
%     a2=0.7228;b2=-0.4111;
%     % 3. SL=a3*Fa2+b3
%     a3=0.6625;b3=-0.0986;
%     % 4. SL=a4*Fa2+b4+c4
%     a4=0.085;b4=0.4089;
%----------------------------
%Call情况下
%     % 1. SL=a*Fs+b*Var+c
%     a1=0.018;b1=0.008;c1=0.6772;
%     % 2. SL=a2*Fa1+b2
%     a2=0.4055;b2=0.0778;
%     % 3. SL=a3*Fa2+b3
%     a3=0.3655;b3=0.2615;
%     % 4. SL=a4*Fa2+c4
%     a4=0.0444;b4=0.5252;
%-----------------------------
%Pocket情况下
%     % 1. SL=a*Fs+b*Var+c
%     a1=0.1057;b1=0.0007;c1=0.7438;
%     % 2. SL=a2*Fa1+b2
%     a2=0.5833;b2=-0.2372;
%     % 3. SL=a3*Fa2+b3
%     a3=0.5164;b3=0.0782;
%     % 4. SL=a4*Fa2+b4*T+c4
%     a4=0.0549;b4=0.3182;
%-----------------------------
%     LengthPredict1=a1*test(:,1)+b1*test(:,2)+c1;
%     LengthPredict2=a2*test(:,3)+b2;
%     LengthPredict3=a3*test(:,4)+b3;
%综合模型的步长训练
% 读取数据
for i=1:1
%     RawData=load(strcat('B:\data_PDR\Train\Handon(',num2str(i),').csv'));
    Time=RawData(:,1);
    a=RawDataProcess(RawData(:,2),RawData(:,3),RawData(:,4));
    [x,y]=GetStepNumber(Time,a);
    count(i,1)=size(x,2);
    [test]=GetAccFeacher(a,y);
     
%     LengthPredict1=a1*test(:,1)+b1*test(:,2)+c1;
%     LengthPredict2=a2*test(:,3)+b2;
%     LengthPredict3=a3*test(:,4)+b3;
%     LengthPredict4=a4*abs(test(:,5))+b4;
%     SL(i).Length=LengthPredict2;
%     d=LengthPredict1(1);b=LengthPredict2(1);
%     c=LengthPredict3(1);e=LengthPredict4(1);
%     if i==1
% %         Feachers=Feacher;
%         Length=[sum(LengthPredict1)+d,sum(LengthPredict2)+b,sum(LengthPredict3)+c...
%             ,sum(LengthPredict4)+e];
%     else
% %         Feachers=[Feachers;Feacher];
%         Length=[Length;sum(LengthPredict1)+d,sum(LengthPredict2)+b,sum(LengthPredict3)+c...
%             ,sum(LengthPredict4)+e];
%     end 
end
%-----------2019/3/11-----------%
%对原始数据进行处理
%输入数据  ax,ay,az为原始的三轴数据
%输出数据  a作为处理后的数据
function [a,temp] = RawDataProcess(ax,ay,az)
%将三轴数据进行求模处理
temp=(ax.^2+ay.^2+az.^2).^0.5;
% plot(temp);hold on;
% [~,r,~]=SSA(temp,50,3);
% [~,r1,~]=SSA(temp,50,4);
% a=r1-r;
%设置滤波参数
fs=50;fpass=1;fstop=3;
Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%进行滤波
[c,d]=butter(n,Wn);
a=filter(c,d,temp);
end
%---------2019/3/11------------%
%使用峰值探测算法进行步频探测
%输入参数  a为滤波后的加速度数据 Time为滤波后的时间信息
%输出参数  y为探测到的峰值点  x为峰值点对应的时间点
function [x,y] = GetStepNumber(Time,a)
    Fs=50;
    x=zeros(1,10);
    j=1;temp_y=a;x(j)=1;
    
    for i = 1:max(size(temp_y))-21
        %划分窗口
        temp=temp_y(i:i+20);
        %找到峰值点 %这一步的时间大于0.45
        if (min(temp)==temp_y(i) && i-x(j)>0.4*Fs ...
                && temp_y(i)<-0.3 )
                x(j+1)=i;
                j=j+1;
        end
    end  

    x(1)=[];y=temp_y(x);
% temp_x=Time;temp_y=a;
% x=zeros(1,10);y=zeros(1,10);
% j=1;
% 
%     for i =11: max(size(temp_y))-10
%         temp=temp_y(i-10:i+10);
%         %找到峰值点 %这一步的时间大于0.45
%         if (max(temp)==temp_y(i) && temp_x(i)-x(j)>0.4  && temp_y(i)>2 )
%                 x(j+1)=temp_x(i);y(j+1)=temp_y(i);
%                 j=j+1;
%         end
%     end  
%     %由于第一步是预先设置的点 所以去除第一步的标志点
%     x(1)=[];y(1)=[];
%     %发信息,打电话状态需要删除第一步
%     x(1)=[];y(1)=[];
    
    plot(a);hold on;
    plot(x,y,'.','MarkerSize',20);
end

%-------2019/3/11-------%
%获取加速度的特征值
%输入  处理后的加速度数据 a  步频检测点 y
%输出  各类特征向量 分别为 步频 方差  加速度长度四次方 平均面积的三次方 面积
function [Feachers] = GetAccFeacher(a,y)

    %对y进行二次处理
    tempa=a;tempy=y(1:end);
    
    %1将加速度按照步频分割数据 
    Fs=zeros(10,1);
    %data为一个结构体，其中的RawData为数据片段
    %j为计数器，pre为前置标志点
    j=1;pre=1;
    
    for i=1:max(size(tempa))
        if(j<=max(size(tempy)) && tempa(i)==tempy(j))         
            data(j).RawData=tempa(pre:i);
            %获得步频
            Fs(j,1)=(i-pre)/50;
            pre=i;
            j=j+1;
        end
    end
    
    %将第一个值去掉
    Fs(1)=[];
    %将RawData数据进行特征提取
    count=max(size(data));
    Fa1=zeros(count-1,1);
    Var=Fa1;Fa2=Fa1;Area=Fa1;
    
    %2 获取特征值
    for i=2:count
        temp=data(i).RawData;
        Fa1(i-1,1)=(max(temp)-min(temp)).^0.25;%加速度长度
        Var(i-1,1)=var(temp);%方差
        Fa2(i-1,1)=(sum(abs(temp))/size(temp,1)).^(1/3);
        Area(i-1,1)=sum(temp);
    end
    
    Feachers=[Fs,Var,Fa1,Fa2,Area];
end