%通过位置与初始姿态获取手机姿态
%2019/11/14
%输入数据  初始姿态  手机携带位置
%输出数据  手机当前姿态
function [Att] = GetAtt(RawAcc,Position)
    %获取初始姿态
    Att0=GetAttiFn(RawAcc(5:50,:));
    Length=size(Position,1);
    Att=repmat(Att0',Length,1);
    load('Att.mat');
    for i=1:50:Length
        %截取这一秒的加速度数据
        if i+49<Length
            Acc_sub=RawAcc(i:i+49,:);
        else
            Acc_sub=RawAcc(i:Length+1-i,:);
        end
        
        
        %获取俯仰角与横滚角
        Att_sub=GetAttiFn(Acc_sub);
        switch Position(i)
            %发信息位置下
            case 1
                Att_sub(3)=0;
            %打电话位置下
            case 2
                Att_sub(3)=166;
            case 3
                %口袋位置下手机姿态
                Att_sub(3)=-20;
            otherwise
                %其他情况
                %目前尚未考虑其他情况
        end
        
        %是否为摆臂状态
        if  Position(i)~=4
            temp=repmat(Att_sub',50,1);
        else
            temp=Att0'+Att4;
        end
        
        %是否到了尾部
        if i+49<Length
            Att(i:i+49,:)=temp;
        else
            Att(i:Length,:)=temp(1:Length+1-i,:);
        end
    end
    
end

