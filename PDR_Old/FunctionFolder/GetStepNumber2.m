%使用零点探测算法进行步频探测
%输入参数  a为滤波后的加速度数据 Time为滤波后的时间信息
%输出参数  y为探测到的峰值点  x为峰值点对应的时间点
%------  2019/9/19  第一次编写----%
function [x,y] = GetStepNumber2(a)
    Fs=50;
    x=zeros(1,10);y=zeros(1,10);
    j=1;temp_y=a;x(j)=1;
    for i = 1:max(size(temp_y))-21
        %划分窗口
        temp=temp_y(i:i+20);
        %找到零点
        if (i-x(j)>0.3*Fs  && abs(temp_y(i))<=0.09)
            %如果零点之后值是下降的  那么确定这个点
            if (temp_y(i)-temp_y(i+1)>0  && temp_y(i+5)<-0.1)
                x(j+1)=i;
                j=j+1;
            end
        end
    end

    x(1)=[];
    y=temp_y(x);
end

