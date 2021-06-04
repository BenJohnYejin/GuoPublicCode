
function Mag=MagAl(MagIn)
Scalex=7.6409;Scaley=6.6482;Scalez=7.2533;
x0=-0.0069;y0=-0.0352;z0=-0.0145;

Mag(:,1)=(MagIn(:,1)-x0)/Scalex.^0.5;
Mag(:,2)=(MagIn(:,2)-y0)/Scaley.^0.5;
Mag(:,3)=(MagIn(:,3)-z0)/Scalez.^0.5;
end

