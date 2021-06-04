
function Cor=GetCor(Cor,SL,Heading)
    Length=size(Heading,1);
    if (length(SL)==1)
        SL=repmat(SL,Length,1);
    end
    if Length>2
        for j=1:Length-1
            Cor(j+1,1)=Cor(j,1)+SL(j)*cos(Heading(j));
            Cor(j+1,2)=Cor(j,2)+SL(j)*sin(Heading(j));
        end
    else 
        Cor(1)=Cor(1)+SL*cos(Heading);
        Cor(2)=Cor(2)+SL*sin(Heading);
    end
end