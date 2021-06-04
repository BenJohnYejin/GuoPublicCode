
function [Wenig,DetV,Fs,Kim,AccM] = GetFea(AccH,TimeDete)
    Len=length(TimeDete);
    %获取模值
    AccM=(AccH(:,1).^2+AccH(:,2).^2+AccH(:,3).^2).^0.5;
    %初始化
    DetV=zeros(Len-1,1);
    Wenig=zeros(Len-1,1);Kim=zeros(Len-1,1);
    Fs=diff(TimeDete)/50;
    %获取特征值
    for j=1:Len-1
        Start=TimeDete(j);End=TimeDete(j+1);
%         disp(End-Start);
        DetV(j)=trapz(AccH(Start:End,2))*0.02;
        Kim(j)=(sum(AccM(Start:End))/(End-Start)).^(1/3);
        Wenig(j)=((max(AccM(Start:End))-min(AccM(Start:End))).^0.25);
    end
    
end

