%步长与实际步长图
%2019/8/22

% Dis=cumsum(SL);
% figure;hold  on;
% plot(Dis/100);plot(Dis/100,'bo');
% SL0=82.02-0.57*X;
% Dis0=cumsum(SL0);
% plot(Dis0/100);plot(Dis/100,'rx');
% xlabel('步子');ylabel('距离');

figure;hold on;
scatter3(K1(:,1),K1(:,2),K1(:,3),'rx');hold on;
scatter3(K2(:,1),K2(:,2),K2(:,3),'go');
scatter3(K3(:,1),K3(:,2),K3(:,3),'bp');
scatter3(K4(:,1),K4(:,2),K4(:,3),'y+');