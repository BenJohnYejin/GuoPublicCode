%Ë«Ê¸Á¿¶¨×Ë

function Cbn=TwoVectorAlig(Vr1,Vr2,Vb1,Vb2)
    [Vr1,Vr2,Vr3]=Build(Vr1,Vr2);
    [Vb1,Vb2,Vb3]=Build(Vb1,Vb2);

    Cbn =[Vr1,Vr2,Vr3]*[Vb1',Vb2',Vb3'];
end

function [V1_,V2_,V3_]=Build(V1,V2)
    V1_=V1/norm(V1);
    
    V2_=cross(V1,V2);    
    V2_=V2_/norm(V2_);
    
    V3_=cross(cross(V1,V2),V1);
    V3_=V3_/norm(V3_);
end