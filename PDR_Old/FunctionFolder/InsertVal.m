%对加速度数据进行插值
%2019/8/23
function [Output]=InsertVal(Input)
    Len=length(Input);
    Xi=[1:0.1:Len];
    Output=interp1(Input,Xi)';
end
