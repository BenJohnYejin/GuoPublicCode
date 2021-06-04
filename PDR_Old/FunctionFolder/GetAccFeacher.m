%-------2019/3/11-------%
%获取加速度的特征值
%输入  处理后的加速度数据 a  步频检测点(历元) x
%输出  各类特征向量 分别为 步频 方差  
%加速度长度四次方 平均面积的三次方 面积
function [Feachers,data] = GetAccFeacher(a,x)
    fs=50;
    %对y进行二次处理
    tempa=a;
    %1将加速度按照步频分割数据 
    Fs=zeros(10,1);
    %data为一个结构体，其中的RawData为数据片段
    %j为计数器，pre为前置标志点
    j=1;
    
    data(1).Data=tempa(1:x(1));
    for i=1:length(x)-1
        data(i+1).Data=tempa(x(i):x(i+1));
        Fs(i,1)=(x(i+1)-x(i))/fs;
    end
%     for i=1:max(size(tempa))
%         if(j<=max(size(tempy)) && tempa(i)==tempy(j))
%             data(j).RawData=tempa(pre:i);
%             %获得步频
%             Fs(j,1)=(i-pre)/50;
%             pre=i;
%             j=j+1;
%         end
%     end
    
%     %将第一个值去掉
%     Fs(1)=[];
    %将RawData数据进行特征提取
    count=max(size(data));
    Area=zeros(count-1,2);
%     Fa1=zeros(count-1,1);
%     Var=Fa1;Fa2=Fa1;Area=Fa1;Fa3=Fa1;Power=Fa1;
    
    %2 获取特征值
    for i=2:count
        temp=data(i).Data;
        Fa1(i-1,1)=(max(temp)-min(temp));%加速度长度
        Index=round(length(temp)/2);
        Area(i-1,:)=[sum(temp(1:Index)),sum(temp(Index:end))];
%         Power(i-1,1)=sum(temp.^2);
    end
    Fa1=Fa1.^0.25;
    Feachers=[Fs,Area,Fa1];
%     Feacher=mean([Fs,Var,Fa1,Fa2,Area]);
%     Feachers=[Fs,Var,Fa1,Fa2,Area,Power];
end

