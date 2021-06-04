%  2019/8/22
% 使用SSA数据提取三轴加速度数据
% 输入参数  三轴加速度数据
% 输出参数  处理好的加速度数据
function [Acc] = SSAfit(RawAcc)
        [~,r1,~]=SSA(RawAcc,50,2);
        [~,r2,~]=SSA(RawAcc,50,3);
        Acc=r2-r1; 
end