%使用姿态校正
%---2019/10/25
function [AccOut] = AngleFF(Tnb,AccIn)
    AccOut=zeros(size(AccIn));
    %对数据进行滤波
    for i=1:size(AccIn,1)
        temp=AccIn(i,:)';
        AccOut(i,:)=(Tnb*temp)';
    end
end

