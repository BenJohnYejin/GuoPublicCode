%使用加速度数据获取当前姿态
%无法获得航向角
% 2019/10/18
function [Tnb] = GetAccAngle(Acc)
    length=size(Acc,1);
    Angle=zeros(length,3);
    %获取这一段时间角度的平均值，以此作为旋转矩阵
    for i=1:length
        temp=Acc(i,:);
        p=norm(temp);
        temp=temp/p;
        Angle(i,1)=asin(-temp(1));
        Angle(i,2)=atan(temp(2)/temp(3));
    end
    temp=mean(Angle);
    a1=temp(1);a2=temp(2);a3=0;
    cosa1=cos(a1);cosa2=cos(a2);cosa3=cos(a3);
    sina1=sin(a1);sina2=sin(a2);sina3=sin(a3);
    Tnb =[cosa1*cosa2,cosa1*sina2,-sina1;...
        cosa3*sina1*sina2-sina3*cosa2,sina3*sina1*sina2+cosa3*cosa2,sina2*cosa1;...
        cosa3*sina1*cosa2+sina3*sina2,sina3*sina1*cosa2-cosa3*sina2,cosa2*cosa1] ;
end

