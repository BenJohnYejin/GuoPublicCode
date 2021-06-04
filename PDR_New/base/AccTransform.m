
function [Acc] = AccTransform(Acc,Att)
    %ÀúÔªÊý
    Len=size(Acc,1);
    for j=1:Len
        Cnb=a2mat(Att(j,:));
        Acc(j,:)=(Cnb*Acc(j,:)')';
    end
end

