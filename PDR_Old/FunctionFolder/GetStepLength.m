%-------2019/3/12--------%
%步长估计
%输入参数  数据特征值  模型类型  参数 
%输出参数  每一步的步长
function [StepLengths,V] = GetStepLength(V0,DetV,Ts)
    Length=length(DetV);
    V=zeros(Length,1);
    StepLengths=zeros(Length,1);
    V(1)=V0;
    for i=2:Length
        V(i)=V(i-1)+DetV(i-1);
        StepLengths(i-1)=(V(i)+V(i-1))*Ts(i-1)/2;
    end
    StepLengths(end)=V(end)*Ts(end);
end

