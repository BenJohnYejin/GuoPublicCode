
%四元数更新，不考虑误差影响
function qk=qupdate(qk_1,Gyr0,Gyr1)
    DetT=0.02;
%     wn0=Gyr0*0.02;wn1=Gyr1*0.02;
    wn0=Gyr0;wn1=Gyr1;
    
    %求K1
    Omega0=0.5*[0,-wn0;wn0',-askew(wn0)];
    k1=Omega0*qk_1;
    
    %求K2
    Omega1=0.5*[0,-wn1;wn1',-askew(wn1)];
    tmp=qk_1+k1*DetT;
    k2=Omega1*tmp;
        
    qk=qk_1+(k1+k2)*DetT/2;
    
    qk=qk/norm(qk);
end