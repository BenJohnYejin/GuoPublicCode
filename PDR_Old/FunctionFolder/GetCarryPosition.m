%----------2019/7/3-----%
%使用重力分解法得到手机携带位置
%输入参数   三轴加速度数据 [accx,accy,accz]
%输出参数   携带位置编号(向量)  0未知位置  1发信息   2打电话  3口袋  4摆臂
%                重力向量与各轴的正弦角度值(误差极大)矩阵
function [Position,Kscale]=GetCarryPosition(Acc)
    %定义位置向量
    Position=zeros(size(Acc,1),1);
    %对Acc进行求取模值
    G=(Acc(:,1).^2+Acc(:,2).^2+Acc(:,3).^2).^0.5;
    Kscale=Acc./G;
    for i=1:3
        Kscale1(:,i)=Smooth(Kscale(:,i),50);
    end
    %判断携带位置编号
    %这里使用循环而不是find命令
    for i=1:size(Acc,1)
        %若  (x,y)-(0,0)<e 或者 z-1<e  那么为发信息位置
        if abs(Kscale1(i,3)-1)<0.2
            Position(i)=1; 
        %若  z-(-0.6)<e ? 且 x-(-0.6)<e 且  y-0.6<e 那么为打电话状态
        elseif abs(Kscale1(i,2)+0.6)<0.2  && abs(Kscale1(i,1)-0.6)<0.2
%         if abs(Kscale(i,3)+0.1)<0.2 
             Position(i)=4;  
        elseif abs(Kscale1(i,1)+0.6)<0.2
            %abs(Kscale1(i,3)+0.6)<0.2  &&
            
%         if abs(Kscale(i,3)+0.35)<0.2 
            Position(i)=2; 
        %口袋位置有很多 包括上衣和裤子  裤子又包括前后  那么是否详细区分这些状态呢？
        %这里认为是在上衣的右上口袋
        %若  x-(-0.2)<e  且 y-(-0.8)<e  且  z-0<e
        elseif  abs(Kscale1(i,2)-0)<0.2   && abs(Kscale1(i,1)-0.8)<0.2
% abs(Kscale(i,3)+0.45)<0.2 
            Position(i)=3;         
         else
             Position(i)=0; 
         end
    end
    %由于向量之间不稳定 分窗口对位置进行处理
    for i=1:50:size(Position,1)
        if i+50>size(Position,1)
            temp=Position(i:size(Position,1));
        else
            temp=Position(i:i+50);
        end
        count0=numel(temp,temp==0);
        count1=numel(temp,temp==1);
        count2=numel(temp,temp==2);
        count3=numel(temp,temp==3);
        count4=numel(temp,temp==4);
        Value=max([count0,count1,count2,count3,count4]);
        
        if size(Position,1)<i+50
            Length=size(Position,1);
        else
            Length=i+50;
        end            
        switch Value
            case count0
                Position(i:Length)=0;
            case count1
                 Position(i:Length)=1;
            case count2
                 Position(i:Length)=2;
             case count3
                 Position(i:Length)=3;
             case count4
                 Position(i:Length)=4;
        end
    end
end
