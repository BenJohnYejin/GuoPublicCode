%2019/8/4
% SSA分析每层的意义
% 
clc;clear;
%读取加速度数据
RawData=load(strcat('B:\data_PDR\result\milinebiao8.csv'));
% for i=1:3

    temp=RawData(:,4);
%     temp=(RawData(:,4).^2+RawData(:,2).^2+RawData(:,3).^2).^0.5;
%     temp=temp(1000:1200);
    for ii=1:5
        [d,r,vr]=SSA(temp,50,ii);
        [~,r1,~]=SSA(temp,50,ii+1);
        
%         subplot(5,1,ii);
        A(:,ii)=r1-r;
%         plot(r1-r);
%         set(gca,'XLim',[1000 5000]);
        FFTanlys(r1-r);
    end
%     temp=A(:,1)+A(:,3);
%     figure;
%     plot((d./sum(d))*100),hold on,plot((d./sum(d))*100,'rx');
%     Corr=corrcoef(A);
% end