clc;clear;

% PathName="B://DataForFinal/CallRec.txt";
PathName="B://DataForFinal/SwingRec.txt";
Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
Len=size(Gyr,1);Ts=[1:Len]'/50;
[TimeDete,~]=StepDetecte(Acc,Fs);
att0=[0,0,pi/2];

Mag(:,1)=Mag(:,1)-SSA(Mag(:,1),25,1);
Mag(:,2)=Mag(:,2)-SSA(Mag(:,2),25,1);
Mag(:,3)=Mag(:,3)-SSA(Mag(:,3),25,1);

Acc(:,1)=SSA(Acc(:,1),25,1);
Acc(:,2)=SSA(Acc(:,2),25,2);
Acc(:,3)=SSA(Acc(:,3),25,2);

gn=-[0,0,1]';hn=[0,1,0]';

for j=1:Len
%     Heading(j)=atan2(Mag(j,1),Mag(j,2));
    AccTmp=Acc(j,:)/norm(Acc(j,:));
    MagTmp=Mag(j,:)/norm(Mag(j,:));
    Cbn=TwoVectorAlig(gn,hn,AccTmp,MagTmp);
    att(j,:)=m2att(Cbn');
end

%将磁场从机体坐标系转到导航坐标系下
%获取磁航向  使用主方向修正

for j=2:Len
    att(j,3)=0;
    MagAl(j,:)=(a2mat(att(j,:))*Mag(j,:)')';
    AttMag(j)=-atan2(MagAl(j,1),MagAl(j,2));
    if (AttMag(j) <(0+pi/4) && AttMag(j) >(0-pi/4))     AttMag(j) =pi;
    elseif (AttMag(j) <(pi/2+pi/4) && AttMag(j) >(pi/2-pi/4))    AttMag(j)=pi/2;
    elseif (AttMag(j)<(-pi/2+pi/4) && AttMag(j)>(-pi/2-pi/4))   AttMag(j)=-pi/2;        
    else   AttMag(j)=0; 
    end
end
% fft_a(Acc);
% fft_a(Mag);
% q=a2qua(att0);
% for j=1:Len-1
%     q=qupdate(q,Gyr(j,:),Gyr(j+1,:));
%     AttGyr(j,:)=q2att(q);
% %     att_mag(i,1)=atan2(Mag(i,2),Mag(i,1))*deg;
% end
% AttGyr(end+1,:)=AttGyr(end,:);
% figure;
% plot(Ts,AttGyr)
% figure; plot(Ts,Y);
% fft_a(Gyr(:,3));


% figure;
% subplot(3,1,1);plot(Ts,Gyr(:,1));
% subplot(3,1,2);plot(Ts,Gyr(:,2));
% subplot(3,1,3);plot(Ts,Gyr(:,3));


% [TimeDete,~]=StepDetecte(Acc,Fs);



% % 

% Mag(:,1)=SSA(Mag(:,1),25,1)-SSA(Mag(:,1),25,2);xlim([0,5]);
% Mag(:,2)=SSA(Mag(:,2),25,1)-SSA(Mag(:,2),25,2);xlim([0,5]);
% Mag(:,3)=SSA(Mag(:,3),25,1)-SSA(Mag(:,3),25,2);xlim([0,5]);

