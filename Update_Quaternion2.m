function [heng,fu,hang,cbn,p1,p2,p3,p4]=Update_Quaternion2(p11,p21,p31,p41,w1,w2,w3,w4,w5,w6,h)

k10=(1/2)*(-w1*p21-w2*p31-w3*p41);
k11=(1/2)*(w1*p11+w3*p31-w2*p41);
k12=(1/2)*(w2*p11-w3*p21+w1*p41);
k13=(1/2)*(w3*p11+w2*p21-w1*p31);
Y1=p11+h*k10;
Y2=p21+h*k11;
Y3=p31+h*k12;
Y4=p41+h*k13;
k20=(1/2)*(-w4*Y2-w5*Y3-w6*Y4);
k21=(1/2)*(w4*Y1+w6*Y3-w5*Y4);
k22=(1/2)*(w5*Y1-w6*Y2+w4*Y4);
k23=(1/2)*(w6*Y1+w5*Y2-w4*Y3);
p1=p11+(h/2)*(k10+k20);
p2=p21+(h/2)*(k11+k21);
p3=p31+(h/2)*(k12+k22);
p4=p41+(h/2)*(k13+k23);
p1=p1/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
p2=p2/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
p3=p3/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
p4=p4/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
cbn=[p2*p2+p1*p1-p4*p4-p3*p3,2*(p2*p3-p1*p4),2*(p2*p4+p1*p3);
    2*(p2*p3+p1*p4),-p2*p2+p1*p1-p4*p4+p3*p3,2*(p3*p4-p1*p2);
    2*(p2*p4-p1*p3),2*(p3*p4+p1*p2),-p2*p2+p1*p1+p4*p4-p3*p3];
%--------上正右正-n2b--zxy--hang-fu-heng---航向角偏西为正--可用----%
if(abs(cbn(6))<=0.999999)  
fu=asin(cbn(6));
heng=-atan2(cbn(3),cbn(9));
hang=-atan2(cbn(4),cbn(5));
else
 fu=asin(cbn(6));
heng=atan2(cbn(7),cbn(1));
hang=0;
end;
%%处理高俯仰角情况
% pitch(i)=asin(cnn(6));
% if abs(cnn(6))<=0.9699
%     roll(i)=-atan2(cnn(3),cnn(9));
%     yaw(i)=-atan2(cnn(4),cnn(5));
%     %     else
%     %      pitch(i)=asin(cnn(6));
%     %     roll(i)=atan2(cnn(7),cnn(1));
%     %     yaw(i)=0;
%     %     end;
% elseif cnn(6)>0.9699
%     if mod(i,2)==0
%         yaw(i)=yaw(i-1);
%         roll(i)=atan2((cnn(2)+cnn(7)),(cnn(1)-cnn(8)))-yaw(i);
%     else
%         roll(i)=roll(i-1);
%         yaw(i)=atan2((cnn(2)+cnn(7)),(cnn(1)-cnn(8)))-roll(i);
%     end
% elseif cnn(6)<-0.9699
%    if mod(i,2)==0
%         yaw(i)=yaw(i-1);
%         roll(i)=atan2((cnn(2)-cnn(7)),(cnn(1)+cnn(8)))+yaw(i);
%     else
%         roll(i)=roll(i-1);
%         yaw(i)=atan2((cnn(2)-cnn(7)),(cnn(1)+cnn(8)))+roll(i);
%     end    
% end
%--------上正右正-n2b--zxy--hang-fu-heng---航向角偏东为正--可用----%
% if(abs(cbn(6))<=0.999999)   
%  fu=asin(cbn(6));
% heng=-atan2(cbn(3),cbn(9));
% hang=atan2(cbn(4),cbn(5));
% else
%  fu=asin(cbn(6));
% heng=atan2(cbn(7),cbn(1));
% hang=0;
% end;
%--------下正左正-n2b--zyx-hang-fu-heng--航向角偏西为正--可用----%
% if(abs(cbn(3))<=0.999999)  
%  {fu=asin(-cbn(3));
% heng=-atan2(cbn(6),cbn(9));
% hang=atan2(cbn(2),cbn(1));}
% else
%  { fu=asin(-cbn(3)）;
% heng=atan2(cbn(5),cbn(8));
% hang=0;}
% end;
%  heng=heng*180/pi;
%  fu=fu*180/pi;
%  hang=hang*180/pi;
end
