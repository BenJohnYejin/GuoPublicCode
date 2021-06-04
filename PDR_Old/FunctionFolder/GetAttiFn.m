%从开始的两秒中得到初始姿态角
%2019/11/13
%输入数据  初始加速度数据
%输出数据  姿态信息(弧度信息)
function [Att] = GetAttiFn(RawAcc)
    Att=zeros(3,1);
    Acc=mean(RawAcc);
    Acc=Acc/norm(Acc);
    Att(2)=asin(Acc(2));
    Att(1)=atan(-Acc(1)/Acc(3));
    Att=Att*180/3.14159265836;
end

