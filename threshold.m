%StepPoint是从0开始计数，故size（StepPoint）=size（Count）+1；
%计算中用不着第一个StepPoint点，应从第二个点开始使用
function [AA]=threshold()

for thre=1:7
    [Coun,StepPoint,Lstep] = main;
    %---------------------Count步数，StepPoint每一步结束时的时间点，Lstep步长
    Count(thre)=Coun;
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
    roll(1)=0;
    pitch(1)=0;
    yaw(1)=0;
    zitai(1,2:4)=[roll(1)*pi/180,pitch(1)*pi/180,yaw(1)*pi/180];
    h=1/(m/(zitai(m,1)*60));
    [p1(1),p2(1),p3(1),p4(1)]=initial_Quaternion(zitai(1,2),zitai(1,3),zitai(1,4));
    
    for i=2:m
        h=1/(m/(zitai(m,1)*60));                                                   %修改化成秒为单位的时间进行计算
        
        [zitai(i,2),zitai(i,3),zitai(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=Update_Quaternion2(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
    end;
    zitai(:,4)=zitai(:,4)*180/pi;
    for i=1:Count(thre)
        for j=1:m
            if zitai(j,1)==StepPoint(i+1)
                if zitai(j,4)>5
                    theta(i,thre)=zitai(j,4)-3;
                    
                else if zitai(j,4)<-5
                        theta(i,thre)=zitai(j,4)+3;
                    else
                    theta(i,thre)=zitai(j,4);
                    end
                end
            end;
        end;
        AA(thre)=max(abs(theta(:,thre)));
    end;
end
for i=1:7
    for j=5:Count(i)
        %     date(j-5,i)=(abs(theta(j,i)-theta(j-1,i))+abs(theta(j,i)-theta(j-2,i))+abs(theta(j,i)-theta(j-3,i))+abs(theta(j,i)-theta(j-4,i))+abs(theta(j,i)-theta(j-5,i))+abs(theta(j,i)-theta(j-6,i)))/6;
        for m=j-4:j
            lium(m-j+5)=abs(theta(m,i)-mean(theta(j-4:j,i)));
        end
        date(j-4,i)=max(lium);
    end
    for x=1:Count(i)
    y(x,i)=x;
    end
    BB(i)=max(abs(date(:,i)));
end

% figure(1)
% plot(theta(:,1),'-r*','linewidth',2)
% hold on;
% plot(theta(:,2),'-g*','linewidth',2)
% plot(theta(:,3),'-b*','linewidth',2)
% plot(theta(:,4),'-c*','linewidth',2)
% plot(theta(:,5),'-m*','linewidth',2)
% plot(theta(:,6),'-y*','linewidth',2)
% plot(theta(:,7),'-k*','linewidth',2)
% xlabel('单位 /步');ylabel('单位 /°');
% % axis equal;
% zoom on;
% grid on;
% figure(2)
% plot(date(:,1),'-r*','linewidth',2)
% hold on;
% plot(date(:,2),'-g*','linewidth',2)
% plot(date(:,3),'-b*','linewidth',2)
% plot(date(:,4),'-c*','linewidth',2)
% plot(date(:,5),'-m*','linewidth',2)
% plot(date(:,6),'-y*','linewidth',2)
% plot(date(:,7),'-k*','linewidth',2)
% xlabel('单位 /步');ylabel('单位 /°');
% % axis equal;
% zoom on;
% grid on;

end