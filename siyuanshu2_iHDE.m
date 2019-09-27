function []=siyuanshu2_iHDE(p11,p21,p31,p41,w1,w2,w3,w4,w5,w6,h)
dte=45;


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
    cnn=[p2*p2+p1*p1-p4*p4-p3*p3,2*(p2*p3-p1*p4),2*(p2*p4+p1*p3);
        2*(p2*p3+p1*p4),-p2*p2+p1*p1-p4*p4+p3*p3,2*(p3*p4-p1*p2);
        2*(p2*p4-p1*p3),2*(p3*p4+p1*p2),-p2*p2+p1*p1+p4*p4-p3*p3];
    %--------上正右正-n2b--zxy--hang-fu-heng---航向角偏西为正--可用----%
    xxx=0;      %用于判断“冻结”航向角还是横滚角；
    zitai(i,3)=asin(cnn(6));
    if abs(cnn(6))<=0.999999
        zitai(i,2)=-atan2(cnn(3),cnn(9));
        zitai(i,4)=-atan2(cnn(4),cnn(5));
    else
        xxx=xxx+1;
        if cnn(6)<0
            if(mod(xxx,2)==0)
                zitai(i,4)=zitai(i-1,4);
                zitai(i,2)=atan2((cnn(2)+cnn(7)),(cnn(1)-cnn(8)))-zitai(i,4);
            else
                zitai(i,2)=zitai(i-1,2);
                zitai(i,4)=atan2((cnn(2)+cnn(7)),(cnn(1)-cnn(8)))-zitai(i,2);
            end
        else
            if(mod(xxx,2)==0)
                zitai(i,4)= zitai(i-1,4);
                zitai(i,2)=zitai(i,4)-atan2((cnn(2)-cnn(7)),(cnn(1)+cnn(8)));
            else
                zitai(i,2)= zitai(i-1,2);
                zitai(i,4)=atan2((cnn(2)-cnn(7)),(cnn(1)+cnn(8)))+zitai(i,2);
            end
        end
    end;
    for j=1:Count+1
        if zitai(i,1)==StepPoint(j)
            theta(j)=zitai(i,4);
            theta0(j)=zitai(i,4)*180/pi;
            if(j>5)
                    date=(abs(theta0(j)-theta0(j-1))+abs(theta0(j)-theta0(j-2))+abs(theta0(j)-theta0(j-3))+abs(theta0(j)-theta0(j-4))+abs(theta0(j)-theta0(j-5)))/5;
                    if(abs(date)<9)                                                              %可以设置为9
                        theta1(j)=mod(theta0(j),dte);                                                %观测方程
                        if theta1(j)>dte/2
                            theta1(j)=theta1(j)-dte;
                        end;
                        theta2_(j)=theta2(j-1);                                                      %-----------------------预测方程
                        P_(j)=P(j-1)+Q(j);                                                           %-----------------------Q(i)还是Q（i-1）?噪声传递应该是Q（i）
                        R(j)=0.1/(exp(-5*abs(theta1(j)/dte)));
                        kt=P_(j)/(P_(j)+R(j));                                                       %------------------------卡尔曼系数（增益）
                        if abs(theta1(j))<9||theta2_(j)~=0
                            theta2(j)=theta2_(j)+kt*(theta1(j)-theta2_(j));                              %------------------------最优估计
                        else
                            theta2(j)=0;  
                        end
                        theta0(j)=theta0(j)-theta2(j);
                        P(j)=(1-kt)*P_(j);
                        zitai(i,4)=theta0(j)*pi/180;
                        chushihua=@chushisiyuanshu;
                        [p1,p2,p3,p4]=chushihua(zitai(i,2),zitai(i,3),zitai(i,4));
                    end;             
            end;            
        end;
    end; 
end