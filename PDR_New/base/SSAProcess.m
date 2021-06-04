
%对三轴信号进行SSA滤波
function [SignalOut]=SSAProcess(SignalIn,Flag)
    %对加速度信号进行处理
    if Flag==1
        SignalOut(:,1)=SSA(SignalIn(:,1),25,1);
        SignalOut(:,2)=SSA(SignalIn(:,2),25,2);
        SignalOut(:,3)=SSA(SignalIn(:,3),25,2);
    %对磁力计信号进行处理
    elseif Flag==2
        SignalOut(:,1)=SSA(SignalIn(:,1),25,1);
        SignalOut(:,2)=SSA(SignalIn(:,2),25,1);
        SignalOut(:,3)=SSA(SignalIn(:,3),25,1);
    %未知信号
    else
        SignalOut=SignalIn;
    end
        
end