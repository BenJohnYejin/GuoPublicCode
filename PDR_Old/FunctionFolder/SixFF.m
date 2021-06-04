%    使用六面较准法进行较准
%    2019/10/16
function [AccOut] = SixFF(AccIn)
    %读取较准参数
    load('Jiaozhun.mat');
    AccOut=zeros(size(AccIn));
    %对数据进行滤波
    for i=1:size(AccIn,1)
        temp=AccIn(i,:);
        temp=[temp,1];
        AccOut(i,:)=(temp*C)';
    end
end

