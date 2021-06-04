clear;clc;
% filename='B:\data_PDR\result\携带位置相同训练\Swing\Slow(1).csv';

data=load(filename);
temp=(data(:,4).^2+data(:,2).^2+data(:,3).^2).^0.5;
Ts=data(:,1);
% [d,r,~]=SSA(temp,25,3);
% [~,r1,~]=SSA(temp,25,4);
% figure;
% sev=sum(d);
% plot((d./sev)*100),hold on,plot((d./sev)*100,'rx');
% xlabel('Eigenvalue Number');ylabel('Eigenvalue (% Norm of trajectory matrix retained)')
[~,r,~]=SSA(temp,50,4);
[~,r1,~]=SSA(temp,50,3);
d=r-r1;
% subplot(6,1,1);
% plot(Ts,r);xlabel('时间/s');ylabel('加速度/m/s^2');
fft_a(d);
% xlim([5,25]);

% for i=1:5
%     [~,r,~]=SSA(temp,50,i);
%     [~,r1,~]=SSA(temp,50,i+1);
%     subplot(6,1,i+1);
%     plot(Ts,r1-r);xlabel('时间/s');ylabel('加速度/m/s^2');
%     xlim([5,25]);
% end
% figure;
% plot(A);xlabel('历元/个');ylabel('加速度/g');
