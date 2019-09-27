% function [ ] = Pocket(x)
clc
clear all
%——--------------------------读入数据---------------------------------%
[FileName,PathName] = uigetfile('*.txt',...
    '数据文件');
file=fullfile(PathName,FileName);
accer=load(file);
[FileName,PathName] = uigetfile('*.txt',...
    '选择陀螺仪数据文件');
file=fullfile(PathName,FileName);
gyros=load(file);
[mm,nn]=size(gyros);
for fist1=1:1
    %------------------------------假定初始姿态------------------------------%
    disp('1:0/0/90...2:0/0/-90...3:0/0/0...4:0/90/0...5:0/90/-90...4:全部手动输入.roll.pitch.yaw')
    % qingkuang=input('请手动输入请输入选择情况：');
    
    % switch qingkuang
    switch fist1
        case 1
            roll(1)=0;
            pitch(1)=0;
            yaw(1)=90;
        case 2
            roll(1)=0;
            pitch(1)=0;
            yaw(1)=-90;
        case 3
            roll(1)=0;
            pitch(1)=0;
            yaw(1)=0;
        case 4
            roll(1)=0;
            pitch(1)=90;
            yaw(1)=0;
        case 5
            roll(1)=0;
            pitch(1)=90;
            yaw(1)=-90;
        otherwise
            roll(1)=input('请输入初始姿态横滚角为/°：');
            pitch(1)=input('请输入初始姿态俯仰角为/°：');
            yaw(1)=input('请输入初始姿态航向角为/°：');
    end
    roll(1)=deg2rad(roll(1));
    pitch(1)=deg2rad(pitch(1));
    yaw(1)=deg2rad(yaw(1));
    roll_2(1)=deg2rad(0);
    pitch_2(1)=deg2rad(90);
    yaw_2(1)=deg2rad(0);
    %------------------以弧度为单位--------------%
    h=1/(mm/((gyros(mm,1)-gyros(1,1))*60));
    %-----------修改化成秒为单位的时间进行计算
    [p1(1),p2(1),p3(1),p4(1),cnn(1:3,1:3,1)]=initial_Quaternion(roll(1),pitch(1),yaw(1));
    [q1(1),q2(1),q3(1),q4(1),cbn(1:3,1:3,1)]=initial_Quaternion(roll_2(1),pitch_2(1),yaw_2(1));
    for i=2:mm
        [roll_2(i),pitch_2(i),yaw_2(i),cbn(1:3,1:3,i),q1(i),q2(i),q3(i),q4(i)]...
            =Update_Quaternion2(q1(i-1),q2(i-1),q3(i-1),q4(i-1),gyros(i-1,2),gyros(i-1,3),...
            gyros(i-1,4),gyros(i,2),gyros(i,3),gyros(i,4),h);
        [roll(i),pitch(i),yaw(i),cnn(1:3,1:3,i),p1(i),p2(i),p3(i),p4(i)]...
            =Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),gyros(i-1,2),gyros(i-1,3),...
            gyros(i-1,4),gyros(i,2),gyros(i,3),gyros(i,4),h);
    end;
    %-----将accer转换到地理坐标系mat------%
    accer_=accer(:,2:4);
    for i=1:mm
        Rot_accer(i,1:3)=accer_(i,1:3)*cbn(:,:,1);
        exRot_accer(i,:)= Rot_accer(i,1:2);
    end
    %%  %巴特沃斯低通滤波
    But_accer(:,1)=Butterworth_Lowpass_Filter(exRot_accer(:,1),1/h);
    But_accer(:,2)=Butterworth_Lowpass_Filter(exRot_accer(:,2),1/h);
    %     figure(10)
    % %     plot(But_accer(180:400,1),But_accer(180:400,2),'+r');
    %     plot(But_accer(181:401,1),'+r');
    %     hold on
    % %     plot(exRot_accer(180:400,1),exRot_accer(180:400,2),'+b');
    %     plot(exRot_accer(180:400,1),'+b');
    %     grid on;
    %%
    %---------------以30hz来划分PCA----------------%
    j=1;z=1;
    b=[0 1];
    for i=1:mm
        temporary_accer(j,:)=exRot_accer(i,:);
        temporary_filit_accer(j,:)=But_accer(i,:);
        j=j+1;
        if j==31
            [COEFF, score,latent,t2]=princomp(temporary_filit_accer);
            [y(:,z)]= COEFF(:,1);
            roll_(z)=rad2deg(roll(i));
            a=[y(1,z),y(2,z)];
            sita(z)=acos(dot(a,b)/(norm(a)*norm(b)))*180/pi;
            
            [COEF, scor,laten,t1]=princomp(temporary_accer);
            [yy(:,z)]= COEF(:,1);
            c=[yy(1,z),yy(2,z)];
            sit(z)=acos(dot(c,b)/(norm(c)*norm(b)))*180/pi;
%                         if y(1,z)>=0
%                             sita(z)=-sita(z);
%                         end
            %             if sita(z)>90
            %                 sita(z)=sita(z)-180;
            %             end
            %                         if sita(z)<-90
            %                 sita(z)=sita(z)+180;
            %             end
            j=1;
            z=z+1;
        end
        %     if i==mm
        %         mat2(:,:)=mat1(1:j-1,1:2);
        %         [y(z,:,:)]=PCA1(mat2);
        %         a=[y(z,1,1),y(z,1,2)];
        %         sita(z)=acos(dot(a,b)/(norm(a)*norm(b)))*180/pi;
        %     end
    end
    j=1;
    for i=1:2:z-2
        yaw_PCA(j)=(sita(i)+sita(i+1))/2;
        ya_PCA(j)=(sit(i)+sit(i+1))/2;
        roll_1(j)=roll_(i);
        dudu(j)=i;
        j=j+1;
    end
    avg=mean(yaw_PCA);
    yaw_PCA=yaw_PCA-ones(1,j-1)*avg;
    yaw_PCA=yaw_PCA-90;
    av=mean(ya_PCA);
    ya_PCA=ya_PCA-ones(1,j-1)*av;
    ya_PCA=ya_PCA-90;
    offset=0;
    am=1;
    for i=3:j-1
        if i>am&&((abs(roll_1(i)-roll_1(i-1))>50&&abs(roll_1(i)-roll_1(i-1))<300)||(roll_1(i-1)-roll_1(i-2)>30&&roll_1(i)-roll_1(i-1)>30)||(roll_1(i-1)-roll_1(i-2)<-30&&roll_1(i)-roll_1(i-1)<-30))
            offset=offset+1;
            am=i+1;
            %         am(offset+1)=i+1;
            %         avg=mean(du(am(offset):(am(offset+1)-1)));
            %         sem=am(offset+1)-1-am(offset);
            %         du(am(offset):(am(offset+1)-1))=du(am(offset):(am(offset+1)-1))-ones(1,sem+1)*avg;
        end
        yaw_PCA(i)=yaw_PCA(i)+90*offset;
        ya_PCA(i)=ya_PCA(i)+90*offset;
    end;
    %--------------------------------------------------PCA+iHDE------------------------------%
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
    
    %     figure(fist1)
    %     plot(dudu,yaw_PCA_iHDE,'r','Linewidth',2);
    %     hold on
    %     plot(dudu,yaw_PCA,'g','Linewidth',2);
    %     plot(dudu,ya_PCA,'b','Linewidth',2);
    %     legend({'滤波+PCA+滤波+O-iHDE','PCA+滤波','PCA'},'FontSize',12,'FontName','Times?New?Roman');
    %     title('航向对比','FontSize',14)
    yaw_PCA_error(1)=yaw_PCA(1);
    ya_PCA_error(1)=ya_PCA(1);
    yaw_PCA_iHDE_error(1)=yaw_PCA_iHDE(1);
    k=2;
    for i=2:j-1
        if yaw_PCA(i)-yaw_PCA(i-1)<20
            k=k+1;
            yaw_PCA_error(k)=yaw_PCA(i);
            ya_PCA_error(k)=ya_PCA(i);
            yaw_PCA_iHDE_error(k)=yaw_PCA_iHDE(i);
        else
        end;
    end;
    for i=1:k
        YYY(i)=mod(yaw_PCA_error(i),90);
        UUU(i)=mod(ya_PCA_error(i),90);
        NNN(i)=mod(yaw_PCA_iHDE_error(i),90);
        if YYY(i)>45
            YYY(i)=90-YYY(i);
        end;
        if UUU(i)>45
            UUU(i)=90-UUU(i);
        end;
        if NNN(i)>45
            NNN(i)=90-NNN(i);
        end;
    end;  
    disp('AHE_PCA')
    avg_UUU=sum(UUU(:))/k
    disp('AHE_PCA+滤波')
    avg_YYY=sum(YYY(:))/k
    disp('AHE_PCA+滤波+O-iHDE')
    avg_NNN=sum(NNN(:))/k
    YYY=sort(YYY);
    UUU=sort(UUU);
    NNN=sort(NNN);
    for i=1:k
        qqq(i)=100*i/k;
    end;
    figure(9)
    plot(NNN,qqq,'r','linewidth',2)
    hold on;
    plot(YYY,qqq,'g','linewidth',2);
    hold on;
    plot(UUU,qqq,'b','linewidth',2)
    xlabel('航向角误差/°','FontSize',16,'FontName','Times?New?Roman');
    set(gca,'FontSize',14,'FontName','Times?New?Roman');
    ylabel('百分比/%','FontSize',16,'FontName','Times?New?Roman');
    legend({'PCA+滤波+O-iHDE','PCA+滤波','PCA'},'FontSize',14,'FontName','Times?New?Roman');
    grid on;
    x1=zeros(1,j); y1=zeros(1,j);x2=zeros(1,j);y2=zeros(1,j); x3=zeros(1,j);y3=zeros(1,j);

    %     S=208/(j-1);
     S=100/(j-1);
%     S=50/(j-1);
    for i=1:(j-1)
        [x1(i+1),y1(i+1)]=zuobiao(S,deg2rad(yaw_PCA_iHDE(i)),x1(i),y1(i));
        [x2(i+1),y2(i+1)]=zuobiao(S,deg2rad(yaw_PCA(i)),x2(i),y2(i));
        [x3(i+1),y3(i+1)]=zuobiao(S,deg2rad(ya_PCA(i)),x3(i),y3(i));
    end
    zzi(1)=0;zzy(1)=0;
        for i=2:101
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
    figure(fist1+5)
    plot(y1(1:j),x1(1:j),'-r*','MarkerSize',4,'linewidth',1)
    axis equal;
    hold on
    xlabel('单位/m','FontSize',16,'FontName','Times?New?Roman');ylabel('单位/m','FontSize',16,'FontName','Times?New?Roman');
    set(gca,'FontSize',14,'FontName','Times?New?Roman')
    plot(y2(1:j),x2(1:j),'-b*','MarkerSize',4,'linewidth',1)
    plot(y3(1:j),x3(1:j),'-g*','MarkerSize',4,'linewidth',1)
%     plot(zzy(1:51),zzi(1:51),'k','MarkerSize',4,'linewidth',1)
         plot(zzy(1:101),zzi(1:101),'k','MarkerSize',4,'linewidth',1)
%     plot(zzi(1:209),zzy(1:209),'k','MarkerSize',4,'linewidth',1)
    plot(zzi(1),zzy(1),'ks','MarkerSize',8,'MarkerFaceColor',[0 0 1]);
    legend({'PCA+滤波+O-iHDE','PCA+滤波','PCA','参考路径','起始位置'},'FontSize',14,'FontName','Times?New?Roman');
    %     title('\bf航向解法对比路线图','FontSize',14)
    zoom on;
    grid on;
    %姿态解算三个姿态角信息
    %     for i=1:mm
    %     rroll(i)=rad2deg(roll(i))-90;
    %     if rroll(i)<-180
    %         rroll(i)=rroll(i)+360;
    %     end
    %     end
    %         figure(fist1+6)
    %         subplot(3,1,1)
    %         axis equal;
    %         plot(gyros(:,1),rad2deg(yaw),'b','linewidth',2)
    %         xlim([0 2.7])
    %         xlabel('时间/min','FontSize',16)
    %         ylabel('度/°','FontSize',16)
    %         set(gca,'FontSize',14,'FontName','Times?New?Roman')
    %         title('航向角','FontSize',16)
    %         zoom on;
    %         grid on;
    %         subplot(3,1,2)
    %         axis equal;
    %         plot(gyros(:,1),rad2deg(pitch)+90,'g','linewidth',2)
    %         xlim([0 2.7])
    %         xlabel('时间/min','FontSize',16)
    %         ylabel('度/°','FontSize',16)
    %         set(gca,'FontSize',14,'FontName','Times?New?Roman')
    %         title('俯仰角','FontSize',16)
    %         zoom on;
    %         grid on;
    %
    %         subplot(3,1,3)
    %         axis equal;
    %         plot(gyros(:,1),rroll,'r','linewidth',2)
    %         xlim([0 2.7])
    %         xlabel('时间/min','FontSize',16)
    %         ylabel('度/°','FontSize',16)
    %         set(gca,'FontSize',14,'FontName','Times?New?Roman')
    %         title('横滚角','FontSize',16)
    %         zoom on;
    %         grid on;
    disp('PCA')
    x3(end)
    y3(end)
    disp('PCA+滤波')
    x2(end)
    y2(end)
    disp('PCA+滤波+O-iHDE')
    x1(end)
    y1(end)
end

