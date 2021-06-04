%-------2019/7/5---------%
%根据位置信息  对加速度进行滤波处理
%对于  非Swing状态进行带通滤波
%Swing状态进行滑动平均或者低通滤波
%对不同位置的加速度数据进行滤波处理
%输入参数为   三轴加速度数据   位置向量
%输出参数为   用来判断步频的  加速度  
function [MotionAcc] = AccFilter(AccRaw,Position)
    %对加速度数据进行分割
    j=1;Acc=(AccRaw(:,1).^2+AccRaw(:,2).^2+AccRaw(:,3).^2).^0.5;
    MotionAcc(j).Data=Acc(1:50,:);MotionAcc(j).Flag=Position(1);
    for i=50:50:size(Position,1)
        if MotionAcc(j).Flag~=Position(i)
            j=j+1;
            MotionAcc(j).Flag=Position(i);
            if size(Position,1)<i+50
                MotionAcc(j).Data=[MotionAcc(j).Data;Acc(i+1:size(Position,1),:)];
            else
                MotionAcc(j).Data=[MotionAcc(j).Data;Acc(i+1:i+50,:)];
            end
        else
            if size(Position,1)<i+50
                MotionAcc(j).Data=[MotionAcc(j).Data;Acc(i+1:size(Position,1),:)];
            else
                MotionAcc(j).Data=[MotionAcc(j).Data;Acc(i+1:i+50,:)];
            end
        end
    end
    %设置带通滤波器参数
    %设置滤波参数
    fs=50;fpass=1;fstop=3;
    Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
    [c,d]=butter(n,Wn);
    %设置带通滤波器参数
    fpass1=0.5;fstop1=1.5;
    Wn=[fpass1/(fs/2) fstop1/(fs/2)];n=4;
    [c1,d1]=butter(n,Wn);
    
    %对加速度数据进行滤波处理
    %为了防止延迟过大，将有效数据给去除，对于小于6s的数据进行保留？？
    for i=1:j
        switch MotionAcc(i).Flag
            %若是无法分辨的状态 保留原始信号
            case 0
%                 MotionAcc(i)=Smooth(Acc(i),50);
            %若是
            case 1
                MotionAcc(i).Data=filter(c,d,MotionAcc(i).Data);
            case 2
                MotionAcc(i).Data=filter(c,d,MotionAcc(i).Data);
            case 3
                MotionAcc(i).Data=filter(c,d,MotionAcc(i).Data);
             %若是摆臂状态，使用带通获取1Hz数据
            case 4
                MotionAcc(i).Data=filter(c1,d1,MotionAcc(i).Data);
        end
    end
end