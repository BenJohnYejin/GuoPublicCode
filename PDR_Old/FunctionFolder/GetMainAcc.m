%获得主轴的加速度信号
%输入参数   Acc为三轴加速度
%输出参数   前进方向的加速度
%2019/9/3
%得到前进方向的加速度
function [MainAcc]=GetMainAcc(RawAcc,Att)
    
    Length=size(RawAcc,1);
    MainAcc=zeros(Length,3);
    for i=1:Length
        Cbn=a2mat(Att(i,:));
        MainAcc(i,:)=(Cbn*RawAcc(i,:)')';
    end
    
end