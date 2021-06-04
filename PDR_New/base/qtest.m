% clear;clc;
% deg=180/3.1415926;
% pi=3.141592658;
% CorTure0=[-357.738,62.764,-182.252,36.548,-36.798,276.486,-139.7,348,-244.3,284.5];
% load("Route.mat")
%之前的格式
% PathName="B://data_PDR/result/携带位置混合/mix1.csv";
% PathName="B://data_PDR/result/携带位置相同训练/Handon/Slow(1).csv";
% PathName="B://data_PDR/result/矩形路线/MiRecMix1.2.csv";
% PathName="B://temp/Input.txt";
% data=load(PathName);Fs=50;Ts=data(:,1);
% Acc=data(:,2:4);Gyr=data(:,5:7);Mag=data(:,8:10);

% PathName="B://data_PDR/result/矩形路线/MiRecT1.1.txt";
% PathName="B://data_PDR/result/圆形路线/9.txt";
% PathName="B://temp/Alig2.txt";
% Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
% Time=(1:size(Acc,1))/Fs;
%双矢量定姿
gn=-[0,0,1]';hn=[0,1,0]';
Ts=[1:2000]/50;
for j=1:size(Acc(1:2000,:),1)
    AccTmp=Acc(j,:)/norm(Acc(j,:));
    MagTmp=Mag(j,:)/norm(Mag(j,:));
    Cbn=TwoVectorAlig(gn,hn,AccTmp,MagTmp);
    Att(j,:)=m2att(Cbn')*57.3;
end
figure;
subplot(2,1,1);
plot(Ts,Att(:,1:2),'LineWidth',2.0);xlim([0.2,5]);
xlabel("时间/s");ylabel("俯仰角，横滚角/°");grid on;
subplot(2,1,2);
plot(Ts,Att(:,3)+180,'LineWidth',2.0);xlim([0.2,5]);
xlabel("时间/s");ylabel("方位角/°");grid on;
% % plot(Time,Heading);
% % hold on;plot(Time,Att(:,1));
% figure;plot(Time,Att);
% 
% 
% [TimeDete,Acc1]=StepDetecte(Acc,Fs);
% Length=size(Acc,1);Ts=[1:Length]/Fs;
% StepCount=length(TimeDete);
% 
% Mag=MagAl(Mag);
% Mag(:,1)=SSA(Mag(:,1),25,1);
% Mag(:,2)=SSA(Mag(:,2),25,1);
% Mag(:,3)=SSA(Mag(:,3),25,1);

% Acc(:,1)=SSA(Acc(:,1),25,1);
% Acc(:,2)=SSA(Acc(:,2),25,2);
% Acc(:,3)=SSA(Acc(:,3),25,2);

% % 二阶算法
% q=a2qua([0,0,-10]/57.3);
for i=1:Len-1
    q=qupdate(q,Gyr(i,:),Gyr(i+1,:));
    att(i,:)=q2att(q)*57.3;
%     att_mag(i,1)=atan2(Mag(i,2),Mag(i,1))*deg;
end
att(end+1,:)=att(end,:);
% figure;
% plot(Ts,att);grid on;
% att_mag(end+1,:)=att_mag(end,:);

att0=[0,0,-90]/57.3;
ahrs = AhrsInit(1/Fs,att0);
% att=zeros(Length,3);
% att_Mag=zeros(Length,3);
MagYaw=4;
% 
% MagYaw=70/deg;
for i=1:Length
    [ahrs]=AhrsUpdate(ahrs,Acc(i,:),Gyr(i,:),Mag(i,:),MagYaw);
    att(i,:)=q2att(ahrs.kf.xk(1:4));
    
%     att_mag(i,1)=atan2(Mag(i,2),Mag(i,1))*deg;
%     att(i,3)=PitchSmooth(att(i,3));
%     att_Mag(i)=atan2(Mag(i,2),Mag(i,1));
end
% figure;
% ShowSignal(Ts,att*deg);
% figure;
% % ShowSignal(Ts,Mag_New)
% ShowSignal(Ts,Mag)
% figure;hold on;
% % plot(Ts,tmp_New);
% 

% Heading=att(TimeDete,3);
% zhuanhuan=Heading;
% StepCount=length(TimeDete);
% for i=3:StepCount
%     date=(abs(Heading(i)-Heading(i-1))+abs(Heading(i)-Heading(i-2)))/2;
%     if(abs(date)<8)
%         theta=mod(Heading(i),90);
%         if(theta<45)
%             zhuanhuan(i)=Heading(i)-0.5*date-0.8*theta;
%         end
%         if(theta>45)
%             zhuanhuan(i)=Heading(i)-0.5*date+0.8*(90-theta);
%         end
%     end
% end
% 
% figure;
% plot(att(TimeDete,3));
% hold on;
% % plot(att1(TimeDete,3));
% plot(zhuanhuan);
% 
% H1=att1(TimeDete,3);
H2=att(TimeDete,3)/57.3;
% H3=zhuanhuan/57.3;
Cor1(1,:)=[0,0];SL=0.80;
Cor2=Cor1;Cor3=Cor1;
for j=1:StepCount
%     P=GetCor(Cor1(j,:),SL,H1(j));
%     Cor1(j+1,:)=P';
    
    P=GetCor(Cor2(j,:),SL,H2(j));
    Cor2(j+1,:)=P';
    
%     P=GetCor(Cor3(j,:),SL,H3(j));
%     Cor3(j+1,:)=P';
end
% figure;
% plot(TimeDete,H2*57.3)
% figure;
% plot(Cor2(:,1), Cor2(:,2));
% plot(Cor2(:,1), Cor2(:,2));
grid on;
TureCor1=[];
TureCor1(:,1)=Cor2(:,1)+CorTure0(1);
TureCor1(:,2)=Cor2(:,2)+CorTure0(2);
plot(TureCor1(:,1),TureCor1(:,2));
hold on;
plot(TureCor(:,1),TureCor(:,2));
% plot(Cor3(:,1),Cor3(:,2));
