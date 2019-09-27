% function [ ] =Swing_arm( )
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
% %重力计滤波处理
% fp=2;              %通带截止频率;
% fs=2.2;              %阻带截止频率
% Wp=2*fp/50;           %标准化通带截止频率
% Ws=2*fs/50;           %标准化阻带截止频率
% Wp=2*fp/100;           %标准化通带截止频率
% Ws=2*fs/100;           %标准化阻带截止频率
% Rp=1;                %通带最大衰减（dB）
% Rs=3;                %阻带最小衰减（dB）
% 巴特沃斯低通滤波
% [n,Wn] = buttord(Wp,Ws,Rp,Rs);%得到巴特沃斯滤波器的最小阶数n和3dB截止角频率wn
% [b,a] = butter(n,Wn);%得到低通数字巴特沃斯滤波器分子b和分母a(b、a均为n+1维行向量)
% filter_Grav= filter(b,a,Grav(:,1));
% 时间延迟问题
% time_filter_Grav=filter_Grav(19:end);
% 重力计幅值频谱分析
% x=Grav(:,1);      %加速度
% x=x-mean(x);
% ff=50;
% N=length(x);    %采样频率和数据点数
% n=0:N-1;
% t=n/ff;    %时间序列
% y=fft(x,N);     %对信号进行快速Fourier变换
% mag=abs(y);      %求得Fourier变换后的振幅
% f=n*ff/N; 
% h14= figure('Name','重力计幅值频谱分析','NumberTitle','off');
% plot(f(1:N/2),mag(1:N/2)*2/N); %绘出Nyquist频率之前随频率变化的振幅
% hold on;
% [H,w]=freqz(b,a);
% plot(w/pi*ff/2,0.3*abs(H),'r')
% xlabel('频率/Hz');
% ylabel('振幅');title('x轴');grid on
% h1= figure('Name','滤波前后重力计数据对比','NumberTitle','off');
% axis equal;
% plot(Grav(:,1),'-b')
% xlabel('历元'), ylabel('m/s^2')
% grid on;
% filter_Grav=Grav;
% time_filter_Grav=Grav;
%%
count=0;
for i=3:m-19
        if((Grav(i-1)<Grav(i)&&Grav(i)>Grav(i+1))&&Grav(i)>9.6)
%         if((time_filter_Grav(i-1)<time_filter_Grav(i)&&time_filter_Grav(i)>time_filter_Grav(i+1))&&time_filter_Grav(i)>9.6)
% %         if((filter_Grav(i-1)<filter_Grav(i)&&filter_Grav(i)>filter_Grav(i+1))&&filter_Grav(i)>9.6)
        count=count+1;
        number(count)=i;
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
    yaw(i)=zitai(number(i),3);
end      
%% 加速度计匹配航向
% 加速度幅值频谱分析
% x=Acce_amp;      %加速度
% x=x-mean(x);
% ff=50;
% N=length(x);    %采样频率和数据点数
% n=0:N-1;
% t=n/ff;    %时间序列
% y=fft(x,N);     %对信号进行快速Fourier变换
% mag=abs(y);      %求得Fourier变换后的振幅
% f=n*ff/N; 
% h12= figure('Name','加速度幅值频谱分析','NumberTitle','off');
% plot(f(1:N/2),mag(1:N/2)*2/N); %绘出Nyquist频率之前随频率变化的振幅
% xlabel('频率/Hz');
% ylabel('振幅');title('x轴');grid on
% 低通滤波器模型
% fp=3;              %通带截止频率;
% fs=4;              %阻带截止频率
fp=3;              %通带截止频率;
fs=4;              %阻带截止频率
Wp=2*fp/50;           %标准化通带截止频率
Ws=2*fs/50;           %标准化阻带截止频率
% Wp=2*fp/100;           %标准化通带截止频率
% Ws=2*fs/100;           %标准化阻带截止频率
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
st=1;zzz=1;
for j=1:count
    for i=st:number(j)
        temporary_accer(zzz,:)=But_accer(i,:);
        zzz=zzz+1;
        if i==number(j);
            st=number(j)+1;
            [COEFF, ~,  ~]=princomp(temporary_accer);
            [y(j,:,:)]= COEFF(1,:);
            roll_(j)=rad2deg(zitai(i,3));
            a=[y(j,1,1),y(j,1,2)];
            sita(j)=rad2deg(acos(dot(a,b)/(norm(a)*norm(b))));
            zzz=1;    
        end
    end
end
z=count+1;
j=1;
for i=1:2:z-2
    yaw_PCA(j)=(sita(i)+sita(i+1))/2;
    roll_1(j)=roll_(i);
    dudu(j)=i;
    j=j+1;
end
avg=mean(yaw_PCA);
yaw_PCA=yaw_PCA-ones(1,j-1)*avg;
yaw_PCA=yaw_PCA-90;
offset=0;
am=1;
for i=3:j-1
    if i>am&&((abs(roll_1(i)-roll_1(i-1))>40&&abs(roll_1(i)-roll_1(i-1))<300)...
    ||(roll_1(i-1)-roll_1(i-2)>30&&roll_1(i)-roll_1(i-1)>30)||(roll_1(i-1)-roll_1(i-2)<-30&&roll_1(i)-roll_1(i-1)<-30))
    offset=offset+1;
    am=i+1;
    end
    yaw_PCA(i)=yaw_PCA(i)+90*offset;
end;


  dte=45;
    for i=1:j-1;
        P(i)=1;
        Q(i)=0.3;
        R(i)=0.5;                                                                        %观测方程误差
        thet2(i)=0;                                                                     %航向偏角
    end
%     for i=6:j-1
%         date=(abs(yaw_PCA(i)-yaw_PCA(i-1))+abs(yaw_PCA(i)-yaw_PCA(i-2))+abs(yaw_PCA(i)-yaw_PCA(i-3))+abs(yaw_PCA(i)-yaw_PCA(i-4))+abs(yaw_PCA(i)-yaw_PCA(i-5)))/5;
           for i=4:j-1
        date=(abs(yaw_PCA(i)-yaw_PCA(i-1))+abs(yaw_PCA(i)-yaw_PCA(i-2))+abs(yaw_PCA(i)-yaw_PCA(i-3)))/3; 
if abs(date)<9                                                               %可以设置为9
            thet1(i)=mod(yaw_PCA(i),dte);                                                %观测方程
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
    for i=1:j-1
        yaw_PCA_iHDE(i)=yaw_PCA(i)-thet2(i);
    end


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
    for i=1:count
        YYY(i)=mod(rad2deg(yaw(i)),90);
        if YYY(i)>45
            YYY(i)=90-YYY(i);
        end;
    end;
        for i=1:L
        UUU(i)=mod(rad2deg(Accer_yaw(i)),90);
        if UUU(i)>45
            UUU(i)=90-UUU(i);
        end;
    end;
        for i=1:j-1
        WWW(i)=mod(yaw_PCA(i),90);
        NNN(i)=mod(yaw_PCA_iHDE(i),90);
        if WWW(i)>45
            WWW(i)=90-WWW(i);
        end;
        if NNN(i)>45
            NNN(i)=90-NNN(i);
        end;
    end;
    disp('ACCER')
    avg_UUU=sum(UUU(:))/L
    disp('GRAV')
    avg_YYY=sum(YYY(:))/count
    disp('PCA')
    avg_WWW=sum(WWW(:))/(j-1)
    disp('PCA-O-iHDE')
    avg_NNN=sum(NNN(:))/(j-1)
    YYY=sort(YYY);
    UUU=sort(UUU);
    WWW=sort(WWW);
    NNN=sort(NNN);
    for i=1:count
        q_count(i)=100*i/count;
    end;
        for i=1:L
        q_L(i)=100*i/L;
    end;
        for i=1:j-1
        q_j(i)=100*i/(j-1);
    end;
    figure(9)
    plot(NNN,q_j,'r','linewidth',2)
    hold on;
    plot(WWW,q_j,'g','linewidth',2)
    plot(YYY,q_count,'b','linewidth',2);
    plot(UUU,q_L,'y','linewidth',2)
    xlabel('航向角误差/°','FontSize',16,'FontName','Times?New?Roman');
    set(gca,'FontSize',14,'FontName','Times?New?Roman');
    ylabel('百分比/%','FontSize',16,'FontName','Times?New?Roman');
    legend({'PCA+O-iHDE','PCA','重力计识别','加速度计识别'},'FontSize',14,'FontName','Times?New?Roman');
    grid on;
%路线图
% S=220/count;
% S=208/count;
% S_L=208/L;
% P_S=208/(j-1);
% S=100/count;
% S_L=100/L;
% P_S=100/(j-1);
S=50/count;
S_L=50/L;
P_S=50/(j-1);
x1=0;
y1=0;
x2=0;
y2=0;
x3=zeros(1,j); %x坐标
y3=zeros(1,j); %y坐标
x4=0;
y4=0;



    zzi(1)=0;zzy(1)=0;
%         for i=2:101
%         zzy(i)=i-1;zzi(i)=0;
%     end;
    for i=2:51
        zzy(i)=i-1;zzi(i)=0;
    end;
%     for i=2:43
%         zzi(i)=i-1;zzy(i)=0;
%     end
%     for i=44:105
%         zzi(i)=42;zzy(i)=i-43;
%     end
%     for i=106:147
%         zzi(i)=42-(i-105);zzy(i)=62;
%     end
%     for i=148:209
%         zzi(i)=0;zzy(i)=62-(i-147);
%     end
    
    
for i=1:count
    [x1(i+1),y1(i+1)]=zuobiao(S,yaw(i),x1(i),y1(i));
end;
for i=1:L
    [x2(i+1),y2(i+1)]=zuobiao(S_L,Accer_yaw(i),x2(i),y2(i));
end
for i=1:(j-1)
    [x3(i+1),y3(i+1)]=zuobiao(P_S,yaw_PCA(i)*pi/180,x3(i),y3(i));
    [x4(i+1),y4(i+1)]=zuobiao(P_S,yaw_PCA_iHDE(i)*pi/180,x4(i),y4(i));
end
figure(5)
plot(y4(1:j),x4(1:j),'-r*','MarkerSize',4,'linewidth',1)
hold on
axis equal;
xlabel('单位/m','FontSize',16,'FontName','Times?New?Roman');ylabel('单位/m','FontSize',16,'FontName','Times?New?Roman');
set(gca,'FontSize',14,'FontName','Times?New?Roman')
plot(y3(1:j),x3(1:j),'-g*','MarkerSize',4,'linewidth',1)
plot(y1(1:count+1),x1(1:count+1),'-b*','MarkerSize',4,'linewidth',1)
plot(y2(1:L+1),x2(1:L+1),'-y*','MarkerSize',4,'linewidth',1)
plot(zzy(1:51),zzi(1:51),'k','MarkerSize',4,'linewidth',1)
%          plot(zzy(1:101),zzi(1:101),'k','MarkerSize',4,'linewidth',1)
%     plot(zzi(1:209),zzy(1:209),'k','MarkerSize',4,'linewidth',1)
plot(zzi(1),zzy(1),'ks','MarkerSize',8,'MarkerFaceColor',[0 0 1]);
legend({'PCA+O-iHDE','PCA','重力计识别','加速度计识别','参考路径','起始位置'},'FontSize',14,'FontName','Times?New?Roman');
zoom on;
grid on;
    disp('加速度计')
    x2(end)
    y2(end)
    disp('重力计')
    x1(end)
    y1(end)
    disp('PCA')
    x3(end)
    y3(end)
    disp('PCA+O-iHDE')
    x4(end)
    y4(end)
% end