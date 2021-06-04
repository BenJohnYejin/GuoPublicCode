%----2019/10/13----
%    步长特征的提取
%    输入数据为  处理后的加速度序列
%    输出数据为  得到的特征值序列
function [Feachers] = GetFeachers(ArrayAcc)
    Length=length(ArrayAcc);
    Feachers=zeros(Length,7);
    % 面积   有效值   短时平均幅度差  时间  信号变化范围
    %  信号绝对值的平均值  波形因子
    for i=1:Length
        temp=ArrayAcc(i).Acc;
        L=length(temp);
%         L2=round(L/2);
%         a1=sum(temp(1:L2));
%         a2=sum(temp(L2:end));
%         a0=0.5*a1+0.25*a2;
        
        b=sum(temp.^2)/L;
        b=nthroot(b,2);
        
        c=GetC(temp);
        
        d=L*0.02;
                
        a=trapz(temp)*d;
        
        e=(max(temp)-min(temp))^0.25;
        
        f=sum(abs(temp))/L;
        
        h=b/f;
        
        Feachers(i,:)=[a,b,c,d,e,f,h];
        
    end
end

function  Fea=GetC(Acc)
    temp=0;Fea=0;
    for i=2:length(Acc)
        temp=abs(Acc(i)-Acc(i-1));
        Fea=Fea+temp;
    end
end
