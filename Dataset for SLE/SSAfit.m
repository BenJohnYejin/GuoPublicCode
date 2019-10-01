%  2019/8/22
% 使用SSA数据提取三轴加速度数据
% 输入参数  三轴加速度数据
% 输出参数  处理好的加速度数据
function [Acc] = SSAfit(RawAcc)
    for i=1:3
        [~,r0,~]=SSA(RawAcc(:,i),50,2);
        [~,r1,~]=SSA(RawAcc(:,i),50,3);
        [~,r2,~]=SSA(RawAcc(:,i),50,4);
        Acc(:,i)=r2-r1;
    end
    
end