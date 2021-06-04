%2019/12/25
%根据行人的位置与速度得到模型的参数
%输入参数  Label=[Position,Speed]
%   1,2,3,4=发信息   打电话  口袋  摆臂
%   1,2=慢速 快速
%输出参数  模型参数
function [H] = GetH(Label)
    Label=num2str(Label);
    H=0.61;
    switch (Label)
        case '1 1'
            H=0.61;
        case '1 2'
            H=0.68;
        case '4 1'
            H=0.57;
        case '4 2'
            H=0.54;
        case '3 1'
            H=0.52;
        case '3 2'
            H=0.47;
        case '2 1'
            H=0.34;
        case '2 2'
            H=0.39;
    end
end