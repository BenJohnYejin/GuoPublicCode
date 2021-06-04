




% AttMag(66:148)=AttMag(66:148)-2.95;
% AttMag(149:224)=AttMag(149:224)+1.50-2.95;
% AttMag(225:395)=AttMag(225:395)+4.59+1.50-2.95;
% AttMag(396:562)=AttMag(396:562)-4.71+4.59+1.50-2.95;
% 
% 
% AttMag(225:end)=AttMag(225:end)+pi/2;
% AttMag=AttSmooth(AttMag);
% 
% 
% %临时脚本
% % for i=1:5
% %     [f,power]=FFTanlys(A(:,i));
% %     subplot(5,1,i);
% %     plot(f,power);title('频谱分析图');
% %     set(gca,'XLim',[0 5]);
% %     set(gca,'YLim',[0 10000]);
% %     set(gca,'XTick',0:1:5);
% % end
% % temp=A(:,3)+A(:,2);
% % plot(temp);
% % [f,power]=FFTanlys(temp);
% % plot(f,power);title('频谱分析图');
% % set(gca,'XLim',[0 5]);
% % set(gca,'YLim',[0 10000]);
% % set(gca,'XTick',0:1:5);
% 
% % X=1:length(MainAcc);
% % Y=MainAcc';
% % %做出散点图
% % plot(X(500:1500),Y(500:1500),'rx');hold on;
% % %利用polyfit函数进行拟合
% % P = polyfit(X,Y,3);Yi=polyval(P,X);
% % %做出拟合曲线
% % plot(X,Yi,'k');
% 
% % Main;
% % fun=inline('Can(1).*X.^3+Can(2).*X.^2+Can(3).*X+Can(4)','Can','X');
% % for i=1:length(x1)-1
% %     X=1:length(MainAcc(x1(i):x1(i+1)));
% %     X=X.*0.02;
% %     Y=MainAcc(x1(i):x1(i+1))';
% %     Can0=[1,1,1,1];
% %     [Can(i,:),~,~]=nlinfit(X,Y,fun,Can0);
% %     Yi=Can(i,1).*X.^3+Can(i,2).*X.^2+Can(i,3).*X+Can(i,4);
% %     plot(X,Yi);hold on;
% %     plot(X,Y,'rx');
% % end
% 
% % A=[0,0,10;0,0,-10;0,10,0;0,-10,0;10,0,0;-10,0,0];
% % Am(1,:)=mean(load('B:\data_PDR\result\jiaozhun0.csv'));
% % Am(2,:)=mean(load('B:\data_PDR\result\jiaozhun1.csv'));
% % Am(3,:)=mean(load('B:\data_PDR\result\jiaozhun2.csv'));
% % Am(4,:)=mean(load('B:\data_PDR\result\jiaozhun3.csv'));
% % Am(5,:)=mean(load('B:\data_PDR\result\jiaozhun4.csv'));
% % Am(6,:)=mean(load('B:\data_PDR\result\jiaozhun5.csv'));
% % Am=Am(:,2:4);
% % Am(:,4)=[1,1,1,1,1,1]';
% % result=(Am'*Am)\Am'*A;
% 
% % figure;hold on;
% % plot(FirstAcc);IndexE=length(FirstAcc);
% % for i=1:length(ArrayAccPoscess)
% %     IndexB=IndexE;
% %     IndexE=IndexE+length(ArrayAccPoscess(i).Acc);
% %     plot([IndexB+1:IndexE],ArrayAccPoscess(i).Acc);
% % %     Acc=[Acc;ArrayAccPoscess(i).Acc];
% % end
% 
% Data=load('B://temp/DistancePaint.csv');
% figure;
% for i=1:16
%     hold on;
%     temp=cumsum(Data(:,2*i-1));
%     plot(temp,Data(:,2*i),'x');
% 
% end
% 
% plot([0,47.9],[1.5,1.5]);
% plot(47.9,1.5,'ro');
% 
% plot([0,49.4],[4.5,4.5]);
% plot(49.4,4.5,'ro');
% 
% plot([0,45.0],[7.5,7.5]);
% plot(45.0,7.5,'ro');
% 
% plot([0,50.0],[10.5,10.5]);
% plot(50.0,10.5,'ro');
% 
% plot([0,46.95],[13.5,13.5]);
% plot(46.95,13.5,'ro');
% 
% plot([0,48.50],[16.5,16.5]);
% plot(48.50,16.5,'ro');
% 
% plot([0,48.15],[19.5,19.5]);
% plot(48.15,19.5,'ro');
% 
% plot([0,49.85],[22.5,22.5]);
% plot(49.85,22.5,'ro');