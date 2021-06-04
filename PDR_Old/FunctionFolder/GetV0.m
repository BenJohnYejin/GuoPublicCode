%通过  前面的加速度数据获得初始速度
%初始的加速度数据
%初始速度
%   2019/10/14
function [V0] = GetV0(FirstAcc,IndexEnd)

    temp=FirstAcc(5:end);    
%     fs=50;fpass=0.1;fstop=1;
%     Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%     %进行滤波
%     [c,d]=butter(n,Wn);
%     acc=filter(c,d,temp);
    [~,r1,~]=SSA(temp,50,1);
    [~,r2,~]=SSA(temp,50,2);
    acc=r2-r1;
    
    figure;hold on;
    plot(FirstAcc(1:IndexEnd));
    plot(acc);
    
%     TureAcc=acc(1:IndexEnd);
%     plot(TureAcc);
    V0=trapz(acc(15:IndexEnd+20))*(IndexEnd-5)*0.02;
%     V0=trapz(FirstAcc(5:IndexEnd))*(IndexEnd-5)*0.02;
%     disp(V0);
end

