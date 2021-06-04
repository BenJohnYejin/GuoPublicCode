
%磁力计HDE算法
function [AttMagAlig] = MagHDE(AttMag,Det)
    AttMagAlig=AttMag;
    %确定主导方向
    MainHeading=pi*[-1:2/Det:1];
    theat=2*pi/180;
    Len=length(AttMag);
    %
    for j=2:Len
        %获取差值
        Det=abs(AttMag(j)-AttMag(j-1));
        if (Det>2*3.1415) 
            Det=Det-2*3.1415; end

        if (Det<theat)
            AttMagAlig(j)=AttMag(j-1);
        elseif (Det>pi/4)
            Det=abs(AttMag(j)-MainHeading);
            [~,Index]=min(Det);
            AttMagAlig(j)=Det(Index);
        else
            AttMagAlig(j)=AttMag(j);
        end        
        
    end
    
end

