clc;clear;
glvf;

%读取文件
PathName="B://DataForFinal/Data/SwingRec.txt";
Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
[TimeDete,AccM]=StepDetecte(Acc,Fs);
Len=size(Gyr,1);Ts=[1:Len]/50;imu=[Gyr*0.02,Acc];
StepCount=length(TimeDete);
%
% 初始对准
T0=2000;
gn=-[0,0,1]';hn=[0,-1,0]';
Ts0=[1:T0]/50;
Att0=zeros(T0,3);
for j=1:size(Acc(1:T0,:),1)
    AccTmp=Acc(j,:)/norm(Acc(j,:));
    MagTmp=Mag(j,:)/norm(Mag(j,:));
    Cbn=TwoVectorAlig(gn,hn,AccTmp,MagTmp);
    Att0(j,:)=m2att(Cbn');
end
% % Att0Det=[0,0,-0.290];
% 
% att0=[0;0;pi/2];
% avp=QEAHRSTest(imu,[], att0);
% att=avp(:,1:3);
% AttEKF=avp(:,3);
% AttMag=AttEKF;
% AttEKF=AttEKF(TimeDete);
% %将磁场从机体坐标系转到导航坐标系下
% % 获取磁航向
% for j=2:Len
%     att(j,3)=0;
%     MagAl(j,:)=(a2mat(att(j,:))*Mag(j,:)')';
%     AttMag(j)=atan2(MagAl(j,1),MagAl(j,2))+pi;
%     
% %     if (AttMag(j)>pi)    AttMag(j)=AttMag(j)-2*pi; end
% %     if (AttMag(j)<-pi)    AttMag(j)=AttMag(j)+2*pi; end
% end
% AttMag=AttMag(TimeDete);
% 
% Det=-1.0965;
% AttMag=AttMag+Det;
% AttMag=AttSmooth(AttMag);
% % for j=1:395
% % % for j=1:Len
% %     if (AttMag(j) <(0+pi/4) && AttMag(j) >(0-pi/4))     AttMag(j) =0;
% %     elseif (AttMag(j) <(pi/2+pi/4) && AttMag(j) >(pi/2-pi/4))    AttMag(j)=pi/2;
% %     elseif (AttMag(j)<(-pi/2+pi/4) && AttMag(j)>(-pi/2-pi/4))   AttMag(j)=-pi/2;        
% %     else   AttMag(j)=pi; 
% %     end
% % end
% 
% 
% %获取方向变化时刻
% AttHDE=AttEKF;
% for j=2:StepCount
%     Det=abs(AttEKF(j)-AttEKF(j-1));
%     if (Det>2*pi*0.9)    Det=Det-2*pi; end
%         
%     if (Det<0.1)  AttHDE(j)=AttEKF(j-1);   end  
%     if (Det>0.8*pi/2)  AttHDE(j)=round(AttEKF(j)/pi/2/0.9)*pi/2;  end
%     
%     if (AttHDE(j)<-pi*0.9) AttHDE(j)=-pi; end
% end
% 
% %陀螺仪航向
% q=a2qua(att0);
% for j=1:Len-1
%     q=qupdate(q,Gyr(j,:),Gyr(j+1,:));
%     AttGyr(j,:)=q2att(q);
% end
% AttGyr(end+1,:)=AttGyr(end,:);
% AttGyr(:,1:2)=[];
% AttGyr=AttGyr(TimeDete);
% 
% Det=-1.0324;
% 
% AttEKF=AttEKF+Det;
% AttGyr=AttGyr+Det;
% AttHDE=AttHDE+Det;
% 
% AttEKF=AttSmooth(AttEKF);
% AttGyr=AttSmooth(AttGyr);
% AttHDE=AttSmooth(AttHDE);
% 
% 
% 
% % AttMag=MainHeading(AttMag,45);
% figure;hold on;
% plot(AttGyr*57.3,'LineWidth',2.0);
% plot(AttEKF*57.3,'LineWidth',2.0);
% plot(AttHDE*57.3,'LineWidth',2.0);
% plot(AttMag*57.3,'LineWidth',2.0);
% 
% xlabel("步伐/step");ylabel("行人航向/°");
% grid on;
% legend("Gyr","EKF","EKF+HDE","Mag+Match");
% 
% % dlmwrite("B:\DataForFinal\航向\PocketLongHeading.txt",AttMag);
% %%
% % ERRHEADING=[AttGyr,AttEKF,AttHDE,AttMag]-AttEKF;
% % CDFPLOT(ERRHEADING*57.3);
% %%
% Cor(1,:)=[0,0];
% % %第一段
% % SL_0=42/(Index(2)-Index(1));
% % Cor1_0=GetCor(InitP,SL_0,AttEKF(Index(1):Index(2)));
% % Cor2_0=GetCor(InitP,SL_0,AttHDE(Index(1):Index(2)));
% % Cor3_0=GetCor(InitP,SL_0,AttMag(Index(1):Index(2)));
% % Cor4_0=GetCor(InitP,SL_0,AttGyr(Index(1):Index(2)));
% % 
% % %第二段
% % SL_1=63/(Index(3)-Index(2));
% % Cor1_1=GetCor(Cor1_0(end,:),SL_1,AttEKF(Index(2)+1:Index(3)));
% % Cor2_1=GetCor(Cor2_0(end,:),SL_1,AttHDE(Index(2)+1:Index(3)));
% % Cor3_1=GetCor(Cor3_0(end,:),SL_1,AttMag(Index(2)+1:Index(3)));
% % Cor4_1=GetCor(Cor4_0(end,:),SL_1,AttGyr(Index(2)+1:Index(3)));
% % 
% % %第三段
% % SL_2=42/(Index(4)-Index(3));
% % Cor1_2=GetCor(Cor1_1(end,:),SL_2,AttEKF(Index(3)+1:Index(4)));
% % Cor2_2=GetCor(Cor2_1(end,:),SL_2,AttHDE(Index(3)+1:Index(4)));
% % Cor3_2=GetCor(Cor3_1(end,:),SL_2,AttMag(Index(3)+1:Index(4)));
% % Cor4_2=GetCor(Cor4_1(end,:),SL_2,AttGyr(Index(3)+1:Index(4)));
% % 
% % %第四段
% % SL_3=63/(Index(5)-Index(4));
% % Cor1_3=GetCor(Cor1_2(end,:),SL_3,AttEKF(Index(4)+1:Index(5)));
% % Cor2_3=GetCor(Cor2_2(end,:),SL_3,AttHDE(Index(4)+1:Index(5)));
% % Cor3_3=GetCor(Cor3_2(end,:),SL_3,AttMag(Index(4)+1:Index(5)));
% % Cor4_3=GetCor(Cor4_2(end,:),SL_3,AttGyr(Index(4)+1:Index(5)));
% % 
% subplot(2,2,2);
% SL=(133+10)/StepCount;
% Cor2=GetCor([0,0],SL,AttEKF);
% Cor3=GetCor([0,0],SL,AttHDE);
% Cor4=GetCor([0,0],SL,AttMag);
% Cor1=GetCor([0,0],SL,AttGyr);
% 
% PlotPosition(Cor1);%EKF
% PlotPosition(Cor2);%HDE+EKF
% PlotPosition(Cor3);%MAG
% PlotPosition(Cor4(6:end,:));%Gyr
% 
% aplha=-pi/2:pi/40:3/2*pi;
% r=19;
% x=0+r*cos(aplha);
% y=19+18+r*sin(aplha);
% x=[0,0,x];
% y=[0,18,y];
% plot(x,y,'black-','LineWidth',2.0);
% axis equal
% 
% xlabel("东向/m");ylabel("北向/m");
% legend("Gyr","EKF","EKF+HDE","Mag+Match",'Standard ');
% grid on;
% 
