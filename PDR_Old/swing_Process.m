clc;clear;
filename=strcat('B:\data_PDR\result\携带位置相同训练\pocket\slow(1).csv');
RawData=load(filename);
[a,~,~,a1]=GetStep(RawData(:,1),RawData(:,2),RawData(:,3),RawData(:,4));
Time=RawData(:,1);
%     % 1. SL=a*Fs+b*Var+c
%     a1=0.4806;b1=0.0273;c1=0.3940;
%     % 2. SL=a2*Fa1+b2
%     a2=0.5472;b2=-0.0543;
%     % 3. SL=a3*Fa2+b3
%     a3=0.2164;b3=1.1246;
%     % 4. SL=a4*Fa2+b4*T+c4
%     a4=0.0012;b4=0.5700;
% for i=1:1
% %     RawData=load(strcat('B:\data_PDR\result\A_Swing(',num2str(i),').csv'));
%     [a,x,y]=GetStep(RawData(:,1),RawData(:,2),RawData(:,3),RawData(:,4));
%     count(i,1)=length(x); 
%     [Feacher,test]=GetAccFeacher(a,y);
%     LengthPredict1=a1*test(:,1)+b1*test(:,2)+c1;
%     LengthPredict2=a2*test(:,3)+b2;
%     LengthPredict3=a3*test(:,4)+b3;
%     LengthPredict4=a4*test(:,5)+b4;
%     d=LengthPredict1(1);b=LengthPredict2(1);
%     c=LengthPredict3(1);e=LengthPredict4(1);
% %     cout(i,1)=size(y,2);
% %     if i==1
% %             Feachers=Feacher;
% %             Length=[sum(LengthPredict1)+d,sum(LengthPredict2)+b,sum(LengthPredict3)+c...
% %             ,sum(LengthPredict4)+e];
% %     else
% %             Feachers=[Feachers;Feacher];
% %             Length=[Length;sum(LengthPredict1)+d,sum(LengthPredict2)+b,sum(LengthPredict3)+c...
% %             ,sum(LengthPredict4)+e];
% %     end
% end
%-----获取Swing的步频探测点---%
function [a,x,y,temp_y1] = GetStep(Time,ax,ay,az)
    temp_y1=(ax.^2+ay.^2+az.^2).^0.5;temp_x=Time;   
%     plot(Time,temp_y);hold on;
    %设置滤波参数
    
%     fs=50;fpass=1;fstop=3;
%     Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%     %进行滤波
%     [c,d]=butter(n,Wn);
%     temp_y=filter(c,d,temp_y);
    
    %低通滤波器
    %设置阻带开始频率与阻带截止频率
    Wp=3/50;Ws=5/50;
    %巴特沃斯滤波器设计
    %[阶数，参数]=buttord[开始频率，截止频率，最小容许噪声，最大噪声]
    [~,Wn]=buttord(Wp,Ws,1,50); 
    %双线性代换参数  [分子，分母]=butter[阶数，参数]
    [c,d]=butter(4,Wn);
    %进行滤波
    %[滤波后]=filter[分子，分母，滤波前数据]
    temp_y=filter(c,d,temp_y1);
    temp_y=temp_y-10;
    x=zeros(1,10);y=zeros(1,10);
    a=temp_y;
    j=1;
    for i = 11: max(size(temp_y))-10
        temp=temp_y(i-10:i+10);
        %找到峰值点 %这一步的时间大于0.45
        if (max(temp)==temp_y(i) && temp_x(i)-x(j)>0.2  && temp_y(i)>3)
%         if (max(temp)==temp_y(i) && temp_x(i)-x(j)>0.8)
                x(j+1)=temp_x(i);y(j+1)=temp_y(i);
                j=j+1;
        end
    end  
    %由于第一步是预先设置的点 所以去除第一步的标志点
%     x(1)=[];y(1)=[];
% 
%     plot(Time,a);hold on;
%     plot(x,y,'.','MarkerSize',20);
    
end

%-----获取Swing的特征值---%
function [Feacher,Feachers] = GetAccFeacher(a,y)
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
    
    Feacher=mean([Fs,Var,Fa1,Fa2,Area]);
    Feachers=[Fs,Var,Fa1,Fa2,Area];
end
