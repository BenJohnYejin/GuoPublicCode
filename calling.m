%StepPoint是从0开始计数，故size（StepPoint）=size（Count）+1；
%计算中用不着第一个StepPoint点，应从第二个点开始使用
%PDR+识别+HDE：thet [x3,y3]
%PDR+识别、自适应⊿：hagnxiang [x2,y2]
%PDR+HDE:theta0 [x1,y1]
%PDR:zi(i,4) [x4,y4]
%PDR+offset识别：
% function [ ]=calling()
clear all;
clc;
global h;
[Count,StepPoint,Lstep] = main;                                              %---------------------Count步数，StepPoint每一步结束时的时间点，Lstep步长
[FileName,PathName] = uigetfile('*.txt',...
    '选择陀螺仪数据文件');
file=fullfile(PathName,FileName);
BBB=load(file);
[Row,Col]=size(BBB);
j=1;
tuoluoyi(1,:)=BBB(1,:);
for i=2:Row
    if(BBB(i,1)~=tuoluoyi(j,1)) %按时间进行去重
        j=j+1;
        tuoluoyi(j,:)=BBB(i,:);
    end;
end;
[m,n]=size(tuoluoyi);
zitai=zeros(m,n);
zitai(:,1)=tuoluoyi(:,1);
% Count
%------------------------------假定初始姿态------------------------------%
% disp('1:0/0/90...2:0/0/-90...3:0/0/0...4:全部手动输入...')
% qingkuang=input('请手动输入请输入选择情况：');
% switch qingkuang
%     case 1
%         roll(1)=0;
%         pitch(1)=0;
%         yaw(1)=90;
%     case 2
%         roll(1)=0;
%         pitch(1)=0;
%         yaw(1)=-90;
%     case 3
%         roll(1)=0;
%         pitch(1)=0;
%         yaw(1)=0;
%     otherwise
%         roll(1)=input('请输入初始姿态横滚角为/°：');
%         pitch(1)=input('请输入初始姿态俯仰角为/°：');
%         yaw(1)=input('请输入初始姿态航向角为/°：');
% end
roll(1)=0;
pitch(1)=0;
yaw(1)=-90;
zitai(1,2:4)=[roll(1)*pi/180,pitch(1)*pi/180,yaw(1)*pi/180];                    %------------------------zitai以弧度为单位
theta(1)=zitai(1,4);
h=1/(m/(zitai(m,1)*60));
[p1(1),p2(1),p3(1),p4(1)]=initial_Quaternion(zitai(1,2),zitai(1,3),zitai(1,4));
%------------------------------------
% for i=1:Count+1;
%     P(i)=1;
%     Q(i)=0.3;
%     R(i)=0.5;                                                                        %观测方程误差
%     theta2(i)=0;
% end
for i=2:m
    h=1/(m/(zitai(m,1)*60));                                                   %修改化成秒为单位的时间进行计算
    [zitai(i,2),zitai(i,3),theta(i),cbn(1:3,1:3,i),p1(i),p2(i),p3(i),p4(i)]=Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
end;
%%
% -----------------------------iHDE更新四元数------------------------------------%
% dte=45;
% for i=1:Count;
%     P(i)=1;
%     Q(i)=0.3;
%     R(i)=0.5;                                                                        %观测方程误差
%     theta2(i)=0;
% end
% for i=2:m
%     p11=p1(i-1);
%     p21=p2(i-1);
%     p31=p3(i-1);
%     p41=p4(i-1);
%     w1=tuoluoyi(i-1,2);
%     w2=tuoluoyi(i-1,3);
%     w3=tuoluoyi(i-1,4);
%     w4=tuoluoyi(i,2);
%     w5=tuoluoyi(i,3);
%     w6=tuoluoyi(i,4);
%     k10=(1/2)*(-w1*p21-w2*p31-w3*p41);
%     k11=(1/2)*(w1*p11+w3*p31-w2*p41);
%     k12=(1/2)*(w2*p11-w3*p21+w1*p41);
%     k13=(1/2)*(w3*p11+w2*p21-w1*p31);
%     Y1=p11+h*k10;
%     Y2=p21+h*k11;
%     Y3=p31+h*k12;
%     Y4=p41+h*k13;
%     k20=(1/2)*(-w4*Y2-w5*Y3-w6*Y4);
%     k21=(1/2)*(w4*Y1+w6*Y3-w5*Y4);
%     k22=(1/2)*(w5*Y1-w6*Y2+w4*Y4);
%     k23=(1/2)*(w6*Y1+w5*Y2-w4*Y3);
%     p1=p11+(h/2)*(k10+k20);
%     p2=p21+(h/2)*(k11+k21);
%     p3=p31+(h/2)*(k12+k22);
%     p4=p41+(h/2)*(k13+k23);
%     p1=p1/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
%     p2=p2/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
%     p3=p3/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
%     p4=p4/(sqrt(p1*p1+p2*p2+p3*p3+p4*p4));
%     cnn=[p2*p2+p1*p1-p4*p4-p3*p3,2*(p2*p3-p1*p4),2*(p2*p4+p1*p3);
%         2*(p2*p3+p1*p4),-p2*p2+p1*p1-p4*p4+p3*p3,2*(p3*p4-p1*p2);
%         2*(p2*p4-p1*p3),2*(p3*p4+p1*p2),-p2*p2+p1*p1+p4*p4-p3*p3];
%     %     %--------上正右正-n2b--zxy--hang-fu-heng---航向角偏西为正--可用----%
%     %---------------------------------由C求欧拉角--------------------------%
%     %     xxx=0;      %用于判断“冻结”航向角还是横滚角；
%     %     zitai(i,3)=asin(cnn(6));
%     %     if abs(cnn(6))<=0.999999
%     %         zitai(i,2)=-atan2(cnn(3),cnn(9));
%     %         zitai(i,4)=-atan2(cnn(4),cnn(5));
%     %     else
%     %         xxx=xxx+1;
%     %         if cnn(6)<0
%     %             if(mod(xxx,2)==0)
%     %                 zitai(i,4)=zitai(i-1,4);
%     %                 zitai(i,2)=atan2((cnn(2)+cnn(7)),(cnn(1)-cnn(8)))-zitai(i,4);
%     %             else
%     %                 zitai(i,2)=zitai(i-1,2);
%     %                 zitai(i,4)=atan2((cnn(2)+cnn(7)),(cnn(1)-cnn(8)))-zitai(i,2);
%     %             end
%     %         else
%     %             if(mod(xxx,2)==0)
%     %                 zitai(i,4)= zitai(i-1,4);
%     %                 zitai(i,2)=zitai(i,4)-atan2((cnn(2)-cnn(7)),(cnn(1)+cnn(8)));
%     %             else
%     %                 zitai(i,2)= zitai(i-1,2);
%     %                 zitai(i,4)=atan2((cnn(2)-cnn(7)),(cnn(1)+cnn(8)))+zitai(i,2);
%     %             end
%     %         end
%     %     end;
%     %------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ---------------另一种方法由C求欧拉角--------------------------%
%     if(abs(cnn(6))<=0.999999)
%         zitai(i,3)=asin(cnn(6));
%         zitai(i,2)=-atan2(cnn(3),cnn(9));
%         zitai(i,4)=-atan2(cnn(4),cnn(5));
%     else
%         zitai(i,3)=asin(cnn(6));
%         zitai(i,2)=atan2(cnn(7),cnn(1));
%         zitai(i,4)=0;
%     end;
%     for j=1:Count
%         if zitai(i,1)==StepPoint(j+1)
%             theta0(j)=zitai(i,4)*180/pi;
%             if j>6
%                 date=(abs(theta0(j)-theta0(j-1))+abs(theta0(j)-theta0(j-2))+abs(theta0(j)-theta0(j-3))+abs(theta0(j)-theta0(j-4))+abs(theta0(j)-theta0(j-6)))/6;
%                 if abs(date)<8                                                              %可以设置为9
%                     theta1(j)=mod(theta0(j),dte);                                                %观测方程
%                     if theta1(j)>dte/2
%                         theta1(j)=theta1(j)-dte;
%                     end;
%                     theta2_(j)=theta2(j-1);                                                      %-----------------------预测方程
%                     P_(j)=P(j-1)+Q(j);                                                           %-----------------------Q(i)还是Q（i-1）?噪声传递应该是Q（i）
%                     R(j)=0.1/(exp(-5*abs(theta1(j)/dte)));
%                     kt=P_(j)/(P_(j)+R(j));                                                       %------------------------卡尔曼系数（增益）
%                     if abs(theta1(j))<9||theta2_(j)~=0
%                         theta2(j)=theta2_(j)+kt*(theta1(j)-theta2_(j));                              %------------------------最优估计
%                     else
%                         theta2(j)=0;
%                     end
%                     P(j)=(1-kt)*P_(j);
%                 end;
%             end;
%             theta0(j)=theta0(j)-theta2(j);
%             %         zitai(i,4)=theta0(j)*pi/180;
%             %         [p1,p2,p3,p4]=chushihua(zitai(i,2),zitai(i,3),zitai(i,4));
%         end;
%     end;
%     p1(i)=p1;
%     p2(i)=p2;
%     p3(i)=p3;
%     p4(i)=p4;
% end;
% for i=1:Count
%     theta0(i)=theta0(i)*pi/180;
% end
%-------------------------------------------iHDE更新四元数结束-----------------------------------------------%
%------------------------------------------识别--------------------------%

%%
%------------------------------------------PDR&识别--------------------------%
% pianjiao=0;
% am=0;
% for i=1:Count
%     for j=1:m
%         if zitai(j,1)==StepPoint(i+1)         % 航向角为人体航向/弧度
%             hangxiang(i)=theta(j)*180/pi-pianjiao;
%             henggun(i)=zitai(j,2)*180/pi;
%             fuyang(i)=zitai(j,3)*180/pi;
%             if i>2 && am~=i
%                if (abs(hangxiang(i-1)-hangxiang(i-2))>20||abs(hangxiang(i)-hangxiang(i-1))>20) && (abs(henggun(i-1)-henggun(i-2))>10||abs(henggun(i)-henggun(i-1))>10) && (abs(fuyang(i-1)-fuyang(i-2))>10||abs(fuyang(i)-fuyang(i-1))>10);
%                pianjiao=pianjiao+hangxiang(i)-hangxiang(i-2);
%                hangxiang(i)=theta(j)*180/pi-pianjiao;
%                am=i+1;
%               end
%             end
%             if i==am
%                 pianjiao=pianjiao+hangxiang(i)-hangxiang(i-1);
%                 hangxiang(i)=theta(j)*180/pi-pianjiao;
%             end
%             thet(i)=hangxiang(i);
%             zi(i)=theta(j);
%         end;
%     end;
% end;
%%
%------------------------------------------PDR&新识别--------------------------%
pianjiao=0;
am=0;
for i=1:Count
    for j=1:m
        if zitai(j,1)==StepPoint(i+1)         % 航向角为人体航向/弧度
            hangxiang(i)=theta(j)*180/pi-pianjiao;
            henggun(i)=zitai(j,2)*180/pi;
            fuyang(i)=zitai(j,3)*180/pi;
            if i>2 && i>am
%                 if (abs(hangxiang(i-1)-hangxiang(i-2))>20||abs(hangxiang(i)-hangxiang(i-1))>20)...
%                         && (abs(henggun(i-1)-henggun(i-2))>20||abs(henggun(i)-henggun(i-1))>20) ...
%                         && (abs(fuyang(i-1)-fuyang(i-2))>10||abs(fuyang(i)-fuyang(i-1))>10);
                if (abs(hangxiang(i-1)-hangxiang(i-2))>20||abs(hangxiang(i)-hangxiang(i-1))>20)...
                        && (abs(henggun(i-1)-henggun(i-2))>20||abs(henggun(i)-henggun(i-1))>20) ;
                    
                    hangxiang(i-1)=hangxiang(i-2);
                    hangxiang(i)=hangxiang(i-2);
                    am=i+2;
                end
                %                     if abs(hangxiang(i)-hangxiang(i-1))>20 ...
                %                    && abs(henggun(i-1)-henggun(i-2))<20 ...
                %                    &&abs(henggun(i)-henggun(i-1))<20 ...
                %                    && abs(fuyang(i-1)-fuyang(i-2))<10 ...
                %                    &&abs(fuyang(i)-fuyang(i-1))<10;
                %                hangxiang(i)=hangxiang(i-1);
                %                end
            end
            if i==am-1
                hangxiang(i)=hangxiang(i-3);
            end
            if i==am
                pianjiao=pianjiao+hangxiang(i)-hangxiang(i-4);
                hangxiang(i)=theta(j)*180/pi-pianjiao;
            end
            thet(i)=hangxiang(i);
            zi(i)=theta(j);
        end;
    end;
end;
%%
%--------------------------------------------------PDR&识别+iHDE------------------------------%
for i=1:Count;
    P(i)=1;
    Q(i)=0.3;
    R(i)=0.5;                                                                        %观测方程误差
    thet2(i)=0;                                                                     %航向偏角
end
dte=45;
for i=7:Count
    %     date=(abs(thet(i)-thet(i-1))+abs(thet(i)-thet(i-2))+abs(thet(i)-thet(i-3))+abs(thet(i)-thet(i-4))+abs(theta0(i)-theta0(i-6)))/6;
    date=(abs(thet(i)-thet(i-1))+abs(thet(i)-thet(i-2))+abs(thet(i)-thet(i-3))+abs(thet(i)-thet(i-4))+abs(thet(i)-thet(i-5))+abs(thet(i)-thet(i-6)))/6;
    if abs(date)<8                                                              %可以设置为9
        thet1(i)=mod(thet(i),dte);                                                %观测方程
        if thet1(i)>dte/2
            thet1(i)=thet1(i)-dte;
        end;
        thet2_(i)=thet2(i-1);                                                        %-----------------------预测方程
        P_(i)=P(i-1)+Q(i);                                                           %-----------------------Q(i)还是Q（i-1）?噪声传递应该是Q（i）
        R(i)=0.1/(exp(-5*abs(thet1(i)/dte)));
        kt=P_(i)/(P_(i)+R(i));                                                       %------------------------卡尔曼系数（增益）
        if abs(thet1(i))<9||thet2_(i)~=0
            thet2(i)=thet2_(i)+kt*(thet1(i)-thet2_(i));                              %------------------------最优估计
        else
            thet2(i)=0;
        end
        P(i)=(1-kt)*P_(i);
    end;
end
for i=1:Count
    thet(i)=(thet(i)-thet2(i))*pi/180;
    hangxiang(i)=hangxiang(i)*pi/180;
end
%%
%------------------------------坐标计算-----------------------%
% x1=zeros(1,Count+1); %x坐标
% y1=zeros(1,Count+1); %y坐标
x2=zeros(1,Count+1); %x坐标
y2=zeros(1,Count+1); %y坐标
x3=zeros(1,Count+1); %x坐标
y3=zeros(1,Count+1); %y坐标
x4=zeros(1,Count+1); %x坐标
y4=zeros(1,Count+1); %y坐标
% S=208/Count;
S=50/Count;
% S=100/Count;
for i=1:Count
    %     [x1(i+1),y1(i+1)]=zuobiao(S,theta0(i),x1(i),y1(i));
    [x2(i+1),y2(i+1)]=zuobiao(S,hangxiang(i),x2(i),y2(i));
    [x3(i+1),y3(i+1)]=zuobiao(S,thet(i),x3(i),y3(i));
    [x4(i+1),y4(i+1)]=zuobiao(S,zi(i),x4(i),y4(i));
end;
%%
%----------------------------理想行走路线--------------------%
zzi(1)=0;zzy(1)=0;
for i=2:51
    zzi(i)=i-1;zzy(i)=0;
end;
% for i=2:43
%     zzi(i)=i-1;zzy(i)=0;
% end
% for i=44:105
%     zzi(i)=42;zzy(i)=i-43;
% end
% for i=106:147
%     zzi(i)=42-(i-105);zzy(i)=62;
% end
% for i=148:209
%     zzi(i)=0;zzy(i)=62-(i-147);
% end

%----------------路线图对比------------------%
zi=zi*180/pi;
hangxiang=hangxiang*180/pi;
thet=thet*180/pi;
%----------------航向误差图-------------%
theterror(1)=thet(1);
hangxiangerror(1)=hangxiang(1);
j=2;
for i=2:Count
    if thet(i)-thet(i-1)<20
        j=j+1;
        theterror(j)=thet(i);
        hangxiangerror(j)=hangxiang(i);
    else
    end;
end;
for i=1:j
    YYY(i)=mod(theterror(i),90);
    UUU(i)=mod(hangxiangerror(i),90);
    if YYY(i)>45
        YYY(i)=90-YYY(i);
    end;
    if UUU(i)>45
        UUU(i)=90-UUU(i);
    end;
end;
avg_YYY=sum(YYY(:))/j
avg_UUU=sum(UUU(:))/j
YYY=sort(YYY);
UUU=sort(UUU);
for i=1:j
    qqq(i)=100*i/j;
end;
figure(1)
plot(YYY,qqq,'r','linewidth',2)
hold on;
plot(UUU,qqq,'b','linewidth',2);
xlabel('航向角误差/°','FontSize',16,'FontName','Times?New?Roman');
set(gca,'FontSize',14,'FontName','Times?New?Roman');
ylabel('百分比/%','FontSize',16,'FontName','Times?New?Roman');
legend({'PDR+识别+iHDE','PDR+识别'},'FontSize',14,'FontName','Times?New?Roman');
grid on;

% figure(2)
% subplot(2,1,1)
% plot(zi(:),'k','linewidth',1)
% xlabel('\bf时间 /min','FontSize',12,'FontName','Times?New?Roman');
% ylabel('\bf航向角 °','FontSize',12,'FontName','Times?New?Roman');
% grid on;
% % hold on;
% subplot(2,1,2)
% plot(hangxiang(:),'k','linewidth',1)
% xlabel('\bf时间 /min','FontSize',12,'FontName','Times?New?Roman');
% ylabel('\bf航向角  °','FontSize',12,'FontName','Times?New?Roman');
% grid on;

figure(3)
% plot(y1(1:Count+1),x1(1:Count+1),'-r*','linewidth',2)
plot(y3(1:Count+1),x3(1:Count+1),'r','linewidth',2)
hold on;
xlabel('单位/m','FontSize',16,'FontName','Times?New?Roman');ylabel('单位/m','FontSize',16,'FontName','Times?New?Roman');
set(gca,'FontSize',14,'FontName','Times?New?Roman')
plot(y2(1:Count+1),x2(1:Count+1),'b','linewidth',2)
plot(y4(1:Count+1),x4(1:Count+1),'g','linewidth',2)
% plot(zzi(1:209),zzy(1:209),'k','linewidth',1)
plot(zzi,zzy,'k','linewidth',2)
plot(zzi(1),zzy(1),'ks','MarkerSize',8,'MarkerFaceColor',[0 0 1]); % marcar posicion inicial标记初始位置
% plot(zzi(end),zzy(end),'bo','MarkerSize',8,'MarkerFaceColor',[0 0 1]); % marcar paso final标记最后一步
% legend('PDR+iHDE(更新四元数)','PDR','PDR+iHDE','参考路径','起始位置','结束位置');
% legend('PDR','PDR+HDE','参考路径','起始位置','结束位置');
legend({'PDR+识别+O-iHDE','PDR+识别','PDR','参考路径','起始位置'},'FontSize',14,'FontName','Times?New?Roman');
% legend('PDR','PDR+iHDE','参考路径');
axis equal;
zoom on;
grid on;
disp('PDR+HDE')
x3(Count+1)
y3(Count+1)
disp('PDR')
x2(Count+1)
y2(Count+1)
% end