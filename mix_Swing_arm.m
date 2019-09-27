clc
clear all
%——--------------------------读入数据---------------------------------%
[FileName,PathName] = uigetfile('*.txt',...
    '数据文件');
file=fullfile(PathName,FileName);
data=load(file);
Acce=data(:,1:3);
Grav=data(:,4:6);
Gyro=data(:,10:12);
[m,n]=size(Grav);
for i=1:m
    Acce_amp(i)=sqrt(Acce(i,1)*Acce(i,1)+Acce(i,2)*Acce(i,2)+Acce(i,3)*Acce(i,3));
%         Acce_amp(i)=Acce(i,1);
end
Acce_g=9.8*ones(m);
%% 重力计匹配航向
% h1= figure('Name','滤波前后重力计数据对比','NumberTitle','off');
% axis equal;
% plot(Grav(:,1),'-b')
% xlabel('历元'), ylabel('m/s^2')
% grid on;
%--------峰值检测，获取步数、检步点
count=0;
for i=3:m
        if((Grav(i-1)<Grav(i)&&Grav(i)>Grav(i+1))&&Grav(i)>9.6)
        count=count+1;
        steppoint(count)=i;
    end
end
%航向解算
zitai(1,1:3)=[-90*pi/180,0*pi/180,-90*pi/180];                    %------------------------zitai以弧度为单位
h=1/50;
% h=1/100;
[p1(1),p2(1),p3(1),p4(1),cbn(1:3,1:3,1)]=initial_Quaternion(zitai(1,1),zitai(1,2),zitai(1,3));
for i=2:m
    [zitai(i,1),zitai(i,2),zitai(i,3),cbn(1:3,1:3,i),p1(i),p2(i),p3(i),p4(i)]...
        =Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),Gyro(i-1,1),Gyro(i-1,2),Gyro(i-1,3),Gyro(i,1),Gyro(i,2),Gyro(i,3),h);
end;
%匹配捡起航向
for i=1:count
    yaw(i)=zitai(steppoint(i),3);
end      
%% 加速度计匹配航向
fp=3;              %通带截止频率;
fs=4;              %阻带截止频率
Wp=2*fp/50;           %标准化通带截止频率
Ws=2*fs/50;           %标准化阻带截止频率
Rp=1;                %通带最大衰减（dB）
Rs=3;                %阻带最小衰减（dB）
[n,Wn] = buttord(Wp,Ws,Rp,Rs);%得到巴特沃斯滤波器的最小阶数n和3dB截止角频率wn
[b,a] = butter(n,Wn);%得到低通数字巴特沃斯滤波器分子b和分母a(b、a均为n+1维行向量)
filter_Acce_amp = filter(b,a,Acce_amp);
% time_filter_Acce_amp=filter_Acce_amp(5:end);
time_filter_Acce_amp=filter_Acce_amp(19:end);
% h2= figure('Name','滤波前后加速度幅值对比','NumberTitle','off');
% axis equal;
% plot(time_filter_Acce_amp,'-r')
% hold on
% plot(Acce_amp,'-b')
% xlabel('历元'), ylabel('m/s^2')
% grid on;
st=1;
time_filter_Acce_amp_m=length(time_filter_Acce_amp);
for i=1:time_filter_Acce_amp_m
    if time_filter_Acce_amp(i)-9.8>-0.1&&time_filter_Acce_amp(i)-9.8<0.1
        Accer_yaw(st)=zitai(i,3);
        st=st+1;
    end
end
L=length(Accer_yaw);
%% PCA估算航向
accer_=Acce;
for i=1:m
%     Rot_accer(i,1:3)=accer_(i,1:3)*cbn(:,:,i);
%     exRot_accer(i,1:2)= Rot_accer(i,1:2);
     exRot_accer(i,1)= accer_(i,2);
     exRot_accer(i,2)= accer_(i,3);
end
%巴特沃斯低通滤波
    But_accer(:,1)=Butterworth_Lowpass_Filter(exRot_accer(:,1),1/h);
    But_accer(:,2)=Butterworth_Lowpass_Filter(exRot_accer(:,2),1/h);
% But_accer(:,1)=Buttworth(exRot_accer(:,1),m);
% But_accer(:,2)=Buttworth(exRot_accer(:,2),m);
% b=[0 1];%20°是否跟他相关
b=[1 0];%20°是否跟他相关
%-------------------------------------尝试匹配检步点-------------%
temper_j=1;st=1;
for j=2:2:count 
    [COEFF, ~,  ~]=princomp(But_accer(st:steppoint(j),:));
    [y(:,temper_j)]= COEFF(:,1);%第一列为第一特征向量
    a=[y(1,temper_j),y(2,temper_j)];
    roll_1(temper_j)=rad2deg(zitai(steppoint(j),3));%roll其实利用的是航向角
    yaw_PC(temper_j)=rad2deg(acos(dot(a,b)/(norm(a)*norm(b))));
    st=steppoint(j)+1;
    temper_j=temper_j+1;
end
j=1; 
for i=1:2:count-1
    dudu(j)=i;
    j=j+1;
end
yaw_PCA=yaw_PC;
avg=mean(yaw_PCA);
yaw_PCA=yaw_PCA-ones(1,j-1)*avg;
yaw_PCA=yaw_PCA-90;
offset=0;
am=1;
for i=3:j-1
%     if i>am&&((abs(roll_1(i)-roll_1(i-1))>50&&abs(roll_1(i)-roll_1(i-1))<330)...
%             ||(roll_1(i-1)-roll_1(i-2)>30&&roll_1(i)-roll_1(i-1)>30)||(roll_1(i-1)-roll_1(i-2)<-30&&roll_1(i)-roll_1(i-1)<-30)...
%  ||abs(roll_1(i)-roll_1(i-2))>50)
    if i>am&&((abs(roll_1(i)-roll_1(i-1))>50&&abs(roll_1(i)-roll_1(i-1))<330)...
            ||(roll_1(i-1)-roll_1(i-2)>30&&roll_1(i)-roll_1(i-1)>30)||(roll_1(i-1)-roll_1(i-2)<-30&&roll_1(i)-roll_1(i-1)<-30))
        offset=offset+1;
        am=i+4;
    end
    yaw_PCA(i)=yaw_PCA(i)+90*offset;
end;
%--------尝试解决180°模糊问题

%航向估计对比图
% h3 = figure('Name','航向估计对比图','NumberTitle','off');
% subplot(411)
% plot(zitai(:,3)*180/pi,'-b')
% title('陀螺仪解算航向')
% xlabel('历元'), ylabel('度/°')
% grid on;
% subplot(412)
% plot(yaw*180/pi,'-r')
% title('重力计匹配航向图')
% xlabel('步数'), ylabel('度/°')
% grid on;
% subplot(413)
% plot(Accer_yaw*180/pi,'-r')
% title('加速度计匹配航向')
% xlabel('步数'), ylabel('度/°')
% grid on;
% subplot(414)
% plot(yaw_PCA,'-r') 
% title('PCA估计航向')
% xlabel('窗口'), ylabel('度/°')
% grid on;
%-----------------------航向误差---------------%
%     for i=1:k
%         YYY(i)=mod(yaw_PCA_error(i),90);
%         UUU(i)=mod(ya_PCA_error(i),90);
%         NNN(i)=mod(yaw_PCA_iHDE_error(i),90);
%         if YYY(i)>45
%             YYY(i)=90-YYY(i);
%         end;
%         if UUU(i)>45
%             UUU(i)=90-UUU(i);
%         end;
%         if NNN(i)>45
%             NNN(i)=90-NNN(i);
%         end;
%     end;
%     YYY=sort(YYY);
%     UUU=sort(UUU);
%     NNN=sort(NNN);
%     for i=1:k
%         qqq(i)=100*i/k;
%     end;
%     figure(9)
%     plot(NNN,qqq,'r','linewidth',2)
%     hold on;
%     plot(YYY,qqq,'g','linewidth',2);
%     hold on;
%     plot(UUU,qqq,'b','linewidth',2)
%     xlabel('\bf航向角误差  °','FontSize',12,'FontName','Times?New?Roman');
%     ylabel('\bf百分比 %','FontSize',12,'FontName','Times?New?Roman');
%     legend({'\bfiHDE+滤波+PCA','\bf滤波+PCA','\bfPCA'},'FontSize',12,'FontName','Times?New?Roman');
%     grid on;
%路线图
% S=220/count;
S=208/count;
S_L=208/L;
P_S=208/(j-1);
% S=50/count;
% S_L=50/L;
% P_S=50/(j-1);
x1=0;
y1=0;
x2=0;
y2=0;
x3=zeros(1,j); %x坐标
y3=zeros(1,j); %y坐标

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
    
    
for i=1:count
    [x1(i+1),y1(i+1)]=zuobiao(S,yaw(i),x1(i),y1(i));
end;
for i=1:L
    [x2(i+1),y2(i+1)]=zuobiao(S_L,Accer_yaw(i),x2(i),y2(i));
end
for i=1:(j-1)
    [x3(i+1),y3(i+1)]=zuobiao(P_S,yaw_PCA(i)*pi/180,x3(i),y3(i));
end
h4 = figure('Name','路线图','NumberTitle','off');
plot(y1(1:count+1),x1(1:count+1),'-r*','linewidth',1)
axis equal;
xlabel('单位 /m');ylabel('单位 /m');
hold on
plot(y2(1:L+1),x2(1:L+1),'-b*','linewidth',1)
plot(y3(1:j),x3(1:j),'-k*','linewidth',1)
% plot(zzi(1:209),zzy(1:209),'k','linewidth',1)
% legend('重力计匹配','加速度计匹配','PCA估计','实际路线');
legend('重力计匹配','加速度计匹配','PCA估计');
zoom on;
grid on;
