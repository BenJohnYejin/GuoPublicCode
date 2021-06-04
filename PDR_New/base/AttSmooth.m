function [Att] = AttSmooth(Att)
    Len=length(Att);
    for j=1:Len
        if (Att(j)>pi)    Att(j)=Att(j)-2*pi; end 
        if (Att(j)<-pi)    Att(j)=Att(j)+2*pi; end 
    end
end
