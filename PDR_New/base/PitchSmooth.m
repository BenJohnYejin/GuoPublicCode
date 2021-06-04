
%阻止180度跳变

function Out=PitchSmooth(In)
    %获取向量长度
    Length=length(In);
    Out=In;
    %设定阈值
    Thr=7/180*3.1415926;
    
    for j=1:Length
        if In(j)<0
            Det=In(j)+3.1415926;
        else
            Det=3.1415926-In(j);
        end
        if Det<Thr
            Out(j)=3.1415926-abs(Det);
        end
    
    end

end