%  将数据按照步频点分割
%  Acc 为单轴加速度数据  x为步频分割点
%  Data为分割后的数据
function  [Data]=SplitAcc(Acc,x) 
    Data(1).Acc=Acc(1:x(1),:);
    for i=2:length(x)
        Data(i).Acc=Acc(x(i-1):x(i),:);
    end
    Data(i+1).Acc=Acc(x(i):end,:);
end