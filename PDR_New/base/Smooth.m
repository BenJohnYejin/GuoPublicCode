%-----------2019/7/2--------
%使用移动平滑去除脉冲与尖峰
%输入参数为一维向量与平滑窗口长度
%输入参数为
function [output] = Smooth(input,WinLength)
    output=zeros(1,size(input,1)-WinLength);
    for i=1:WinLength
        output(i)=input(i);
    end
    for i=WinLength+1:size(input,1)
        output(i)=sum(input(i-WinLength:i))/(WinLength+1);
    end
end