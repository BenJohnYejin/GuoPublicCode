%---------2019/3/11------------%
%使用峰值探测算法进行步频探测
%输入参数  a为滤波后的加速度数据 Time为滤波后的时间信息
%输出参数  y为探测到的峰值点  x为峰值点对应的时间点
function [x,y] = GetStepNumber(a)
    Fs=50;
    x=zeros(1,10);
    j=1;temp_y=a;x(j)=1;
    
    for i = 1:2:max(size(temp_y))-16
        %划分窗口
        temp=temp_y(i:i+15);
        %找到峰值点 
        %这一步的时间大于0.45
        if (min(temp)==temp_y(i) && i-x(j)>0.4*Fs && temp_y(i)<-0.2 )
                x(j+1)=i;
                j=j+1;
        end
    end  

    x(1)=[];y=temp_y(x);
end


