%通过  前面的加速度数据获得初始速度
%初始的加速度数据  步频检测点
%速度增量
%   2019/11/17
function [DetV,Time,SL0,Z,Label] = GetDetV(MainAcc,x,Position)
    Length=size(x,2);
    DetV=zeros(Length-1,1);
    Time=zeros(Length-1,1);
    Label=zeros(Length-1,2);
    Z=zeros(Length-2,1);
    %初始状态
    temp=MainAcc(x(1):x(1+1));
    SL0=0.5778*(max(temp)-min(temp)).^0.25;
    DetV(1)=trapz(temp)*length(temp)*0.02;
    Time(1)=length(temp)*0.02;
    Label(1,1)=Position(x(1));
    Label(1,2)=2;
    for i=2:Length-1
        temp=MainAcc(x(i):x(i+1));
        Z(i-1)=(max(temp)-min(temp)).^0.25;
        DetV(i)=trapz(temp)*length(temp)*0.02;
        Time(i)=length(temp)*0.02;
        Label(i,1)=Position(x(i));
        %默认为慢速前进
        Label(i,2)=2;
        
        if Time(i)<0.51
            Label(i,2)=1;
        end

        if Label(i,1)==4 && Time(i)>0.49
            Label(i,2)=2;
        end
    end
    DetV=DetV*0.02;
end