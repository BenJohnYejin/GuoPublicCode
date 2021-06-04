
% 位置匹配算法获取磁场航向修正值
% 输入参数 @PositionStart 二维位置
%               @PositionEnd 二维位置
%               @MagBase 磁场指纹库
% 输出参数 @Mag 匹配得到的磁航向指纹库
function [Mag]=MagAlig(PositionStart,PositionEnd,MagBase)
    %位置列表
    PositionList=MagBase(:,1:2);
    MagList=MagBase(:,3);
    %获取位置序号
    IndexStart=PositionAlig(PositionStart,PositionList);
    IndexEnd=PositionAlig(PositionEnd,PositionList);
    %截取向量
    Mag=MagList(IndexStart:IndexEnd);
end

%二维位置匹配
function [Index]=PositionAlig(Position,PositionList)
    Det=Position-PositionList;
    Distance=sqrt(Det(:,1).^2+Det(:,2).^2);
    [~,Index]=min(Distance);
end