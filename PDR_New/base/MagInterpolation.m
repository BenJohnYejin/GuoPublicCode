
%对磁力计进行插值
%使用线性插值  等间隔插入点
%输入的向量 @In 
%需要扩展的长度  @Length
%输出的向量 @Out
function Out=MagInterpolation(In,Length)
    Out=zeros(Length,1);
    %获取输入向量的长度
    Len1=length(In);
    %获取需要添加的个数
    AddCount=Length-Len1;
    %间隔个数
    BetweenCount=ceil(Len1/AddCount);
    
    k=1;
    for j=1:Len1-1
        Out(j+k-1)=In(j);
        %寻找到间隔个数之后
        if mod(j,BetweenCount)==0
            k=k+1; 
            Out(j+k-1)=(In(j)+In(j+1))/2; 
        end
    end
    
    if k<AddCount
%         disp(j);disp(k);disp(Length);
        disp(repmat(In(end),Length-k-j+1,1));
        Out(j+k:Length)=repmat(In(end),Length-k-j+1,1);
    end
end