%对分割的数据进行SSA滤波
%输入数据为  分割后的加速度片段序列  步频检测点
%输出数据为  经过处理后的加速度数据片段
function [ArrayAccOut,FristAcc,EndAcc] = ArrayAccPocess(ArrayAccIn)
    %遍历加速度数据片段
    %选取SSA 第四层  
    Length=length(ArrayAccIn);
    FristAcc=[ArrayAccIn(1).Acc];
    for i=2:Length-1
        temp=[ArrayAccIn(i-1).Acc;ArrayAccIn(i).Acc;ArrayAccIn(i+1).Acc];
        IndexBegin=length(ArrayAccIn(i-1).Acc);
        IndexEnd=IndexBegin+length(ArrayAccIn(i).Acc);
        %使用SSA分析得到第四层数据
        %设置滤波参数
%         fs=50;fpass=1;fstop=3;
%         Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%         %进行滤波
%         [c,d]=butter(n,Wn);
%         temp=filter(c,d,temp);
        [~,r,~]=SSA(temp,25,3);
        [~,r1,~]=SSA(temp,25,4);
        temp=r1-r;
        out=temp(IndexBegin:IndexEnd);
        ArrayAccOut(i-1).Acc=out;
    end
    EndAcc=[ArrayAccIn(i).Acc;ArrayAccIn(i+1).Acc];
end

