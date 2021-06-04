%-----------2019/3/11-----------%
%使用带通滤波器提取行为相关的加速度数据
%使用奇异谱分析获得
%输入数据  ax,ay,az为原始的三轴数据
%输出数据  a作为处理后的数据
function [a,temp] = RawDataProcess(Acc)
    %将三轴数据进行求模处理
    temp=(Acc(:,1).^2+Acc(:,2).^2+Acc(:,3).^2).^0.5;
    a=zeros(size(temp));
    %使用SSA分析获取步态相关信号
    if length(a)<100
        [~,r,~]=SSA(temp,25,3);
        [~,r1,~]=SSA(temp,25,4);
        a=r1-r;
    else
        for i=101:100:length(a)
            %SSA分析需要一个固定的窗口
            [~,r,~]=SSA(temp(i-100:i),25,3);
            [~,r1,~]=SSA(temp(i-100:i),25,4);
            a(i-100:i)=r1-r;
        end
        %对尾巴进行处理
        [~,r,~]=SSA(temp(length(a)-100:length(a)),25,3);
        [~,r1,~]=SSA(temp(length(a)-100:length(a)),25,4);
        a(length(a)-100:length(a))=r1-r;
    end
end

