
%卡尔曼滤波步长更新
%输入参数 @ kfsl  卡尔曼滤波结构体
%              @ AccPiece 
%输出参数 @ kfsl 卡尔曼滤波结构体

function [kfsl,DetV,Time,Meshdata]=kfupdatasl(kfsl,AccPiece,Motion)
    %对加速度片段进行处理
    MainAcc=AccPiece(:,2);
    ZAcc=AccPiece(:,3);
    %获取Z值
    Meshdata=(max(ZAcc)-min(ZAcc)).^0.25;
    %获取速度增量
    DetV=trapz(MainAcc);
    Time=length(MainAcc)*0.02;
    
    [H]=GetH(Motion,Time);
    %进行卡尔曼滤波
    %1. 状态一步预测
    kfsl.xkk_1=kfsl.Phkk_1*kfsl.xk+0.5*DetV*Time;
    %2. 预测方差阵
    kfsl.Pk=kfsl.Phkk_1*kfsl.Pk*kfsl.Phkk_1'+kfsl.Qk;
    %3. 滤波增益
    kfsl.Kk=kfsl.Pk*H'/(H*kfsl.Pk*H'+kfsl.Rk);
    %4. 状态估计
    r=Meshdata-H*kfsl.xkk_1;
    kfsl.xk=kfsl.xkk_1+kfsl.Kk*r;
    %5. 估计方差阵 
    kfsl.Pk=(1-kfsl.Kk*H)*kfsl.Pk;
    
    if kfsl.Pk>kfsl.Pmax
        kfsl.Pk=kfsl.Pmax;
    elseif (kfsl.Pk<kfsl.Pmin)
        kfsl.Pk=kfsl.Pmin;
    end
end

%

function [H]=GetH(Motion,Time)        
    switch  Motion
        case   {1}
            if (Time<0.51 )  H=0.47 ;
            else  H=0.45 ;
            end
        case  {2}
            if (Time<0.51)  H=0.45;
            else  H=0.42 ;
            end
        case  {3}
            if (Time<0.51 )  H= 0.34;
            else  H=0.39 ;
            end
        case {4}
            if (Time<0.51 )  H=0.52 ;
            else  H=0.47 ;
            end
        otherwise
            if (Time<0.51 )  H=0.54 ;
            else  H=0.57 ;
            end
    end
    
    H=1/H;
end
