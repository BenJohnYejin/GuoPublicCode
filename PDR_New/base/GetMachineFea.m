%获取三轴传感器特征值
%特征值使用均值与能量
%
function [Feachers] = GetMachineFea(Array,StepDec)
%   向量值 与 分割点
%   三轴特征值 以及 模值的特征值
    Len=size(StepDec,1); 
    
    tmp=zeros(10,3);Feachers=zeros(Len-1,4);
    
    for i=2:Len
        %三轴传感器片段
        tmp=Array(StepDec(i-1):StepDec(i),:);
        %平均值
        Ave=mean(tmp);Ave(4)=mean(Ave);
        Feachers(i-1,1:4)=Ave;
        %获取差值
        tmp=GetDet(tmp,Ave);
        tmp=tmp.^2;
        Feachers(i-1,5:7)=sum(tmp);
        
        tmp=GetMo(Array);tmp=tmp-Ave(4);
        tmp=tmp.^2;
        Feachers(i-1,8)=sum(tmp);
    end
    
end


function Output=GetMo(Input)
    Len=size(Input,1);
    Output=zeros(Len,1);
    
    for i=1:Len
        Output(i)=(Input(i,1)^2+Input(i,2)^2+Input(i,3)^2).^0.5;
    end

end

function Output=GetDet(Input1,Input2)
    Len=size(Input1,1);Output=zeros(Len,3);
    
    for i=1:Len
        Output(:,1) = Input1(:,1)-Input2(1);
        Output(:,2) = Input1(:,2)-Input2(2);
        Output(:,3) = Input1(:,3)-Input2(3);
    end

end
