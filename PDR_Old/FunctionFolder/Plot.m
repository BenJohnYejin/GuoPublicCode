%作图工具类

%1  绘制线状图
% figure();
% subplot(4,1,1);hold on;
% plot(data(:,1),'r');plot(data(:,2),'b');plot(data(:,1),'rx');plot(data(:,2),'bx');
% legend('WMAIV模型','Weinberg模型');xlabel('步数/步');ylabel('步长/m');
% 
% subplot(4,1,2);hold on;
% plot(data(:,3),'r');plot(data(:,4),'b');plot(data(:,3),'ro');plot(data(:,4),'bo');
% legend('WMAIV模型','Weinberg模型');xlabel('步数/步');ylabel('步长/m');
% 
% subplot(4,1,3);hold on;
% plot(data(:,5),'r');plot(data(:,6),'b');plot(data(:,5),'r+');plot(data(:,6),'b+');
% legend('WMAIV模型','Weinberg模型');xlabel('步数/步');ylabel('步长/m');
% 
% subplot(4,1,4);hold on;
% plot(data(:,7),'r');plot(data(:,8),'b');plot(data(:,7),'rs');plot(data(:,8),'bs');
% legend('WMAIV模型','Weinberg模型');xlabel('步数/步');ylabel('步长/m');




% clear;
% %2  绘制柱状图
% figure()
% data=load('SLbarData.mat');
% AccuRate=data.AccuRate;
% %绘图并获取图像句柄
% %由于按组分配颜色  所以分为两组  
% %子设置坐标  %奇数为快
% X1=1:6:19;
% X1(5:8)=X1(1:4)+40;
% X2=X1+0.7;
% X3=X2+0.7;
% X4=X3+0.7;
% 
% Y1=AccuRate(1,:);Y2=AccuRate(2,:);
% Y3=AccuRate(3,:);Y4=AccuRate(4,:);
% BarHandler=bar(X1,Y1,0.4);
% hold on;
% bar(X2,Y2,0.4);
% bar(X3,Y3,0.4);
% bar(X4,Y4,0.4);
% %设置标注
% legend('Linear Model','Kim Model','Weinberg Model','WMAIV model')
% for i = 1:8
%     text(X1(i)-0.2,Y1(i)+0.1,num2str(Y1(i)));
% end
% for i = 1:8
%     text(X2(i)-0.2,Y2(i)+0.1,num2str(Y2(i)));
% end
% for i = 1:8
%     text(X3(i)-0.2,Y3(i)+0.1,num2str(Y3(i)));
% end
% for i = 1:8
%     text(X4(i)-0.2,Y4(i)+0.1,num2str(Y4(i)));
% end

%3 绘制位置图
% figure;
% Head=data(:,3);
% SL0=data(:,1);
% SL1=data(:,2);
% 
% subplot(3,2,1)
% [AX,H1,H2] =plotyy([1:252],Head,[1:252],CarryPos,@plot);% 获取坐标轴、图像句柄
% set(AX(1),'Xcolor','k','Ycolor','k')%设置x轴、左y轴刻度字体为黑色；
% set(AX(2),'Xcolor','k','Ycolor','k')%设置x轴、右y轴刻度字体为黑色；
% set(get(AX(1),'ylabel'),'string', '航向/^°','fontsize',12);
% set(get(AX(2),'ylabel'),'string', '位置编号','fontsize',12);
% set(AX,'Xlim',[0,252],'xtick',[0:50:250])%设置x轴数据范围，刻度显示
% set(AX(2),'ylim',[0,5],'ytick',[1:1:4])%设置右y轴数据范围（0到3），刻度显示（0,1,2,3）
% xlabel('步数/步','fontsize',12);
% 
% subplot(3,2,2)
% plot(SL0);hold on;plot(SL1);
% xlabel('步数/步');ylabel('步长/m');
% legend('WMAIV模型','Weinberg模型');
% 
% Head=Head.*3.1415926/180;
% CosH=cos(Head);SinH=sin(Head);
% pos1=[SL0.*CosH,SL0.*SinH];
% pos2=[SL1.*CosH,SL1.*SinH];
% P1=cumsum(pos1);
% P2=cumsum(pos2);
% 
% P=[0,0;41.16,0;41.16,62.48;0,62.48;0,0];
% subplot(3,2,[3:6]);hold on;
% plot(P(:,1),P(:,2),'r');
% plot(P1(:,1),P1(:,2),'b');
% plot(P2(:,1),P2(:,2));
% plot(P1(:,1),P1(:,2),'rx');
% plot(P2(:,1),P2(:,2),'b*');
% legend('理想路线','WMAIV模型路线','Weinberg模型路线');

figure;hold on;
plot(data(:,1),'r');plot(data(:,2),'b');plot(1:45,data(1:45,1),'rx');
xlabel('步数/步');ylabel('步长/m');
plot(46:110,data(46:110,1),'ro');plot(111:158,data(111:158,1),'r+');
plot(159:224,data(159:224,1),'rs');
plot(1:45,data(1:45,2),'bx');
plot(46:110,data(46:110,2),'bo');
plot(111:158,data(111:158,2),'b+');
plot(159:224,data(159:224,2),'bs');
legend('WMAIV Model','Weinberg Model','Hold on','Call','Swing','Pocket','Hold on','Call','Swing','Pocket');