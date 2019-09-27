%%%%--------------------------此程序为ｉＨＤＥ单纯修正航向的程序，未涉及四元数的更新计算－－－－－－－－－－－％％％％
%StepPoint是从0开始计数，故size（StepPoint）=size（Count）+1；
%计算中用不着第一个StepPoint点，应从第二个点开始使用
function []=try_iHDE()                %-------------------------------在最优估计处公式选择还存在疑问，在均方误差更新公式还存在问题。
clear all;
clc;
[Count,StepPoint,Lstep] = main;
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
%---------陀螺仪计算变量----------%
[m,n]=size(tuoluoyi);
zitai=zeros(m,n);
zitai(:,1)=tuoluoyi(:,1);
disp('1:0/0/90...2:0/0/-90...3:0/0/0...4:全部手动输入...')
qingkuang=input('请手动输入请输入选择情况：');
switch qingkuang
    case 1
        zitai(1,2)=0;
        zitai(1,3)=0;
        zitai(1,4)=90;
    case 2
        zitai(1,2)=0;
        zitai(1,3)=0;
        zitai(1,4)=-90;
    case 3
        zitai(1,2)=0;
        zitai(1,3)=0;
        zitai(1,4)=0;
    otherwise
        zitai(1,2)=input('请输入初始姿态横滚角为/°：');
        zitai(1,3)=input('请输入初始姿态俯仰角为/°：');
        zitai(1,4)=input('请输入初始姿态航向角为/°：');
end

zitai(1,2)=zitai(1,2)*pi/180;
zitai(1,3)=zitai(1,3)*pi/180;
zitai(1,4)=zitai(1,4)*pi/180;

cbn=zeros(m,3,3);
[p1(1),p2(1),p3(1),p4(1)]=initial_Quaternion(zitai(1,2),zitai(1,3),zitai(1,4));
for i=2:m

    h=1/(m/(zitai(m,1)*60));                                                   %修改化成秒为单位的时间进行计算
    [zitai(i,2),zitai(i,3),zitai(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
end;
for i=2:Count+1
    for j=1:m
        if zitai(j,1)==StepPoint(i)
            thet(i-1)=zitai(j,4)*180/pi;
            theta0(i-1)=thet(i-1);                                                          % 航向角为人体航向/弧度
        end;
    end;
end;
zhuanhuan=theta0;
%----------HDE--------------%(参考赵辉的程序设计/经验参数)
for i=3:Count
    date=(abs(theta0(i)-theta0(i-1))+abs(theta0(i)-theta0(i-2)))/2;
    if(abs(date)<8)
        theta=mod(theta0(i),90);
        if(theta<45)
            zhuanhuan(i)=theta0(i)-0.5*date-0.8*theta;
        end
        if(theta>45)
            zhuanhuan(i)=theta0(i)-0.5*date+0.8*(90-theta);
        end;
    end;
end;
% %--------------------iHDE---------------%
    dte=45;
for i=1:Count;
    P(i)=1;
    Q(i)=0.3;
    R(i)=0.5;                                                                        %观测方程误差
    theta2(i)=0;                                                                     %航向偏角
end
for i=7:Count
    date=(abs(theta0(i)-theta0(i-1))+abs(theta0(i)-theta0(i-2))+abs(theta0(i)-theta0(i-3))+abs(theta0(i)-theta0(i-4))+abs(theta0(i)-theta0(i-5))+abs(theta0(i)-theta0(i-6)))/6;
    if(abs(date)<9)                                                              %可以设置为8
        theta1(i)=mod(theta0(i),dte);                                                %观测方程
        if theta1(i)>dte/2
            theta1(i)=theta1(i)-dte;
        end;
        theta2_(i)=theta2(i-1);                                                      %-----------------------预测方程
        P_(i)=P(i-1)+Q(i);                                                           %-----------------------Q(i)还是Q（i-1）?噪声传递应该是Q（i）
        R(i)=0.1/(exp(-5*abs(theta1(i)/dte)));
        kt=P_(i)/(P_(i)+R(i));                                                       %------------------------卡尔曼系数（增益）
        if abs(theta1(i))<5||theta2_(i)~=0
            theta2(i)=theta2_(i)+kt*(theta1(i)-theta2_(i));                              %------------------------最优估计
        else
            theta2(i)=0;
        end
        P(i)=(1-kt)*P_(i);
    end;
end
for i=1:Count
    theta0(i)=theta0(i)-theta2(i);
end
%----------航向角角度变化对比-------%
    figure(1)
    subplot(3,1,1)
    plot(StepPoint(2:Count+1),thet(:),'k')
    xlabel('时间 /min');
    ylabel('修正前航向角  /°');
    grid on;
    subplot(3,1,2)
    plot(StepPoint(2:Count+1),zhuanhuan(:),'k') 
    xlabel('时间 /min');
    ylabel('HDE航向角  /°');
    grid on;
    subplot(3,1,3)
    plot(StepPoint(2:Count+1),theta0(:),'k') 
    xlabel('时间 /min');
    ylabel('iHDE航向角  /°');
    grid on;
%----------姿态角单位转换为弧度-------%
    zhuanhuan=zhuanhuan*pi/180;
    theta0=theta0*pi/180;
    thet=thet*pi/180;

%------------理想行走路线------%
    zzi(1)=0;zzy(1)=0;
    % for i=2:51
    %     zzi(i)=i-1;zzy(i)=0;
    % end;
    for i=2:43
        zzi(i)=i-1;zzy(i)=0;
    end
    for i=44:105
        zzi(i)=42;zzy(i)=i-43;
    end
    for i=106:147
        zzi(i)=42-(i-105);zzy(i)=62;
    end
    for i=148:209
        zzi(i)=0;zzy(i)=62-(i-147);
    end
%----------坐标计算------------%
    fprintf('您走的步数为:%d\n',Count);
    ss=0;
for i=1:Count
    ss=ss+Lstep(i);
end;
    fprintf('您走的距离为:%d\n',ss);
    x1(1)=0;
    x6(1)=0;
    x7(1)=0;
    y1(1)=0;
    y6(1)=0;
    y7(1)=0;   
%------------恒定步长----------%
      S=209/Count;
      for i=1:Count
     [x1(i+1),y1(i+1)]=zuobiao(S,theta0(i),x1(i),y1(i));
     [x6(i+1),y6(i+1)]=zuobiao(S,thet(i),x6(i),y6(i));
     [x7(i+1),y7(i+1)]=zuobiao(S,zhuanhuan(i),x7(i),y7(i));
      end;

%-----------输出闭合差-------------%
    fprintf('iHDE:%d\n',x1(Count+1),y1(Count+1));
    fprintf('原始:%d\n',x6(Count+1),y6(Count+1));
    fprintf('HDE:%d\n',x7(Count+1),y7(Count+1));
  
%-------------路线图对比-----------------%
    figure(2)
    plot(y1(1:Count+1),x1(1:Count+1),'-r*','linewidth',2)
    hold on;
    axis equal; 
      title('航向解法对比路线图'); 
    xlabel('单位 /m');ylabel('单位 /m');
    plot(y6(1:Count+1),x6(1:Count+1),'-g*','linewidth',2) 
    plot(y7(1:Count+1),x7(1:Count+1),'-b*','linewidth',2) 
    plot(zzi(1:209),zzy(1:209),'k','linewidth',2)
    legend('iHDE','原始','HDE','参考路径'); 
    zoom on;
    grid on;
%------------------------------画出最优估计值的方差
%     figure(3);
%     valid_iter = [1:Count+1];             %  
%     plot(valid_iter,P,'LineWidth',1);     %画出最优估计值的方差
%     legend('Kalman估计的误差估计');
%     xl=xlabel('时间(分钟)');
%     yl=ylabel('℃^2');
%     set(xl,'fontsize',14);
%     set(yl,'fontsize',14);
%     set(gca,'FontSize',14);

end