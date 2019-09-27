%% 加载数据

clear all;clc;close all;
[FileName,PathName] = uigetfile('*.txt',...
    '选择数据文件');
file=fullfile(PathName,FileName);
data=load(file);
Gx = data(:,2); Gy = data(:,3); Gz = data(:,4);%陀螺仪原始数据
N=length(data);
f=N/(data(N,1)*60);
t=(1:N)/f;
s={Gx,Gy,Gz};
%%
%尝试

%% 滤波器模型dee
% fp=0.6;              %通带截止频率
% % fp=1;
% fs=0.7;              %阻带截止频率
fp=3;              %通带截止频率;
fs=4;              %阻带截止频率
Wp=2*fp/f;           %标准化通带截止频率
Ws=2*fs/f;           %标准化阻带截止频率


Rp=1;                %通带最大衰减（dB）
Rs=3;                %阻带最小衰减（dB）

%% 巴特沃斯低通滤波

[n,Wn] = buttord(Wp,Ws,Rp,Rs);%得到巴特沃斯滤波器的最小阶数n和3dB截止角频率wn
[b,a] = butter(n,Wn);%得到低通数字巴特沃斯滤波器分子b和分母a(b、a均为n+1维行向量)
sf = cell(1,3);             % 滤波后信号
for k = 1:3
    sf{k} = filter(b,a,s{k});
end
%% 滤波前后陀螺仪信号绘图对比
h1 = figure('Name','陀螺仪图像','NumberTitle','off');
set(h1,'outerposition',get(0,'screensize'));
subplot(3,1,1);
plot(t,s{1});
hold on;
plot(t,sf{1},'r');
xlabel('时间/s'), ylabel('角速度/rad/s')
xlim([-10,170]);
legend('原始信号','去噪后信号');
grid on;
subplot(3,1,2);
plot(t,s{2});
hold on;
plot(t,sf{2},'r');
xlabel('时间/s'), ylabel('角速度/rad/s')
xlim([-10,170]);
legend('原始信号','去噪后信号');
grid on;
subplot(3,1,3);
plot(t,s{3});
hold on;
plot(t,sf{3},'r');
xlabel('时间/s'), ylabel('角速度/rad/s')
xlim([-10,170]);
legend('原始信号','去噪后信号');
grid on;
pro_s=cell2mat(s);
after_sf=cell2mat(sf);
%%
% %航向对比图
pro_zitai=zeros(N,3);
disp('1:0/0/90...2:0/0/-90...3:0/0/0...4:全部手动输入...')
qingkuang=input('请手动输入请输入选择情况：');
switch qingkuang
    case 1
        pro_zitai(1,1)=0;
        pro_zitai(1,2)=0;
        pro_zitai(1,3)=90;
    case 2
        pro_zitai(1,1)=0;
        pro_zitai(1,2)=0;
        pro_zitai(1,3)=-90;
    case 3
        pro_zitai(1,1)=0;
        pro_zitai(1,2)=0;
        pro_zitai(1,3)=0;
    otherwise
        pro_zitai(1,1)=input('请输入初始姿态横滚角为/°：');
        pro_zitai(1,2)=input('请输入初始姿态俯仰角为/°：');
        pro_zitai(1,3)=input('请输入初始姿态航向角为/°：');
end
pro_zitai(1,:)=pro_zitai(1,:).*(pi/180);
after_zi(1,:)=pro_zitai(1,:);
cbn=zeros(N,3,3);
cbn1=zeros(N,3,3);
[p1(1),p2(1),p3(1),p4(1)]=initial_Quaternion(pro_zitai(1,1),pro_zitai(1,2),pro_zitai(1,3));
[q1(1),q2(1),q3(1),q4(1)]=initial_Quaternion(after_zi(1,1),after_zi(1,2),after_zi(1,3));
for i=2:N
    h=1/f;%修改化成秒为单位的时间进行计算
    [pro_zitai(i,1),pro_zitai(i,2),pro_zitai(i,3),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),pro_s(i-1,1),pro_s(i-1,2),pro_s(i-1,3),pro_s(i,1),pro_s(i,2),pro_s(i,3),h);
    [after_zi(i,1),after_zi(i,2),after_zi(i,3),cbn1(i,1:3,1:3),q1(i),q2(i),q3(i),q4(i)]=Update_Quaternion2(q1(i-1),q2(i-1),q3(i-1),q4(i-1),after_sf(i-1,1),after_sf(i-1,2),pro_s(i-1,3),after_sf(i,1),after_sf(i,2),pro_s(i,3),h);
end;
after_zi=after_zi*(180/pi);

pro_zitai=pro_zitai*(180/pi);
% combin=zeros(N,2);
% combin(:,1)=t(1,:);
% combin(:,2)=after_zi(:,3);
% for i=1:N
%     if combin(i,1)>58.63&combin(i,1)<68.20
%         combin(i,2)=combin(i,2)-4;
%     end
%     if combin(i,1)>71.82&combin(i,1)<93.56
%         combin(i,2)=combin(i,2)-6;
%         if combin(i,2)<-180
%             combin(i,2)=180-(-180-combin(i,2));
%         end
%     end
%     if combin(i,1)>96.65&combin(i,1)<116
%         combin(i,2)=combin(i,2)-10;
%     end
%     if combin(i,1)>=116&combin(i,1)<135
%         combin(i,2)=combin(i,2)-13;
%     end
% end
% ideal=combin;
j=1;
% after_error=zeros(N,1);pro_error=zeros(N,1);
h2 = figure('Name','航向解算对比','NumberTitle','off');
plot(t,pro_zitai(:,3),'b')
hold on;
% plot(t,combin(:,2),'r')
% plot(t,ideal(:,2),'k')
plot(t,after_zi(:,3),'r')
legend('滤波前数据','滤波后数据');
xlabel('time(sec)');ylabel('rotation(deg)');
% axes('position',[0.2 0.65 0.3 0.2]);  % 控制小图大小和位置
% plot(t(1750:2250),pro_zitai(1750:2250,3),'b',t(1750:2250),combin(1750:2250,2),'r',t(1750:2250),ideal(1750:2250,2),'k');
% axes('position',[0.55 0.55 0.3 0.3]);  % 控制小图大小和位置
% plot(t(5400:end),pro_zitai(5400:end,3),'b',t(5400:end),combin(5400:end,2),'r',t(5400:end),ideal(5400:end,2),'k');

grid on;
%%
%航向误差图
avg_pro=sum(abs(pro_error))/5539;
avg_after=sum(abs(after_error))/5539;
h3 = figure('Name','航向误差图','NumberTitle','off');
plot(t(1:5539),pro_error(:),'-r','linewidth',2)
hold on;
plot(t(1:5539),after_error(:),'-b','linewidth',2)
legend('滤波前数据','滤波后数据');
xlabel('time(sec)');ylabel('rotation(deg)');
% zoom on;
grid on;

%%
% %参与定位运算
% pro_zitai(:,3)=pro_zitai(:,3).*(pi/180);
% after_zi(:,3)=after_zi(:,3).*(pi/180);
% combin(:,2)=combin(:,2).*(pi/180);
% pro_x1(1)=0;
% pro_y1(1)=0;
% after_x2(1)=0;
% after_y2(1)=0;
% S=209/N;
% for i=1:N
%     [pro_x1(i+1),pro_y1(i+1)]=zuobiao(S,pro_zitai(i,3),pro_x1(i),pro_y1(i));
%     [after_x2(i+1),after_y2(i+1)]=zuobiao(S,combin(i,2),after_x2(i),after_y2(i));
% end;
% h4 = figure('Name','路线对比','NumberTitle','off');
% plot(pro_y1(1:N+1),pro_x1(1:N+1),'-r*','linewidth',2)
% hold on;
% axis equal;
% xlabel('单位 /m');ylabel('单位 /m');
% plot(after_y2(1:N+1),after_x2(1:N+1),'-b*','linewidth',2)
% %    plot(zzi(1:209),zzy(1:209),'k','linewidth',2)
% legend('原始','滤波');
% zoom on;
% grid on;
% %   [xt,yt]=ginput(5);