% 通用卡尔曼滤波器
% 2019/11/23
% x=A x(k-1) + B U +W
% z=H x(k-1) + V
%输入参数为  滤波器初始化的参数  SL为最开始的步长  DetVT为时间和速度
%输出参数为  最佳估值的步长
function [SL_out] = KalmanFit(SL_in,DetVT,Z,Label)
    % CanShu为[A,B,H,Q,R]
    A=1;B=0.5;
    Q=0.025;R=0.010;
    Length=length(Z);
    X(1)=SL_in;U=DetVT(:,1).*DetVT(:,2);
    P=0.031;
    for i=1:Length
        %通过状态获取状态估计
        X_Predict=A*X(i)+B*U(i);
%         H=1/GetH(Label(i,:));
        %判断行人的速度
        if DetVT(i,2)<0.49
                H=1/0.47;
        else 
                H=1/0.52;
        end
%         if DetVT(i,2)<0.51
% %             H=1/0.54;
% %             H=1/0.39;
% %             H=1/0.68;
%         else 
% %             H=1/0.57;
% %             H=1/0.34;
% %             H=1/0.61;
%         end
        %计算P值
        P=A*P*A+Q;
        %计算卡尔曼增益
        Kg=P*H'/(H*P*H'+R);
        %计算最佳估计
        X(i+1,1)=X_Predict+Kg*(Z(i)-H*X_Predict);
        %重新计算P值
        P=(1-Kg*H)*P;
    end
    SL_out=X;
end

