

% Texting
% H=[2.5,0];
% % Call
% H=[2.63,0];
% % Weinberg
% H=[2.12,0];
% % Pocket
H=[2.98,0];

kf.xk=[0.70;0];
kf.Qk=[0.05,0;0,0.05];
kf.Rk=0.010;
kf.Pk=[0.01,0;0,0.01];
SL=zeros(StepCount,2);SL(1)=0.70;

 
for j=1:56
    %一步预测
    kf.xkk_1=kf.xk+[0.5*DetV(j)*Fs(j);0];
    %2. 预测方差阵
    kf.Pk=kf.Pk+kf.Qk;
    %3. 滤波增益
    kf.Kk=kf.Pk*H'/(H*kf.Pk*H'+kf.Rk);
    %4. 状态估计
%     r=Wenig(j)-H*kf.xkk_1;
    r=Kim(j)-H*kf.xkk_1;
    kf.xk=kf.xkk_1+kf.Kk*r;
    %5. 估计方差阵 
    kf.Pk=(1-kf.Kk*H)*kf.Pk;
   
    Pk(j,:)=diag(kf.Pk);
    SL(j+1,:)=kf.xk';
end
sum(SL(1:56,1))
SL_0=Kim(1:56)/2.98;
sum(SL_0)
SL_1=Wenig(1:56)/2.48;
sum(SL_1)

Result=[SL(1:56,1),SL_0,SL_1];
dlmwrite("B://PocketSL.txt",Result);

SL0=load("B://TextingSL.txt");
SL1=load("B://CallSL.txt");
SL2=load("B://SwingSL.txt");
SL3=load("B://PocketSL.txt");

subplot(4,1,1);
plot(SL0,'LineWidth',2.0);
xlabel("步伐/步");ylabel("步长/m");
grid on;
sum(SL0)

subplot(4,1,2);
plot(SL1,'LineWidth',2.0);
xlabel("步伐/步");ylabel("步长/m");
grid on;

subplot(4,1,3);
plot(SL2,'LineWidth',2.0);
xlabel("步伐/步");ylabel("步长/m");
grid on;

subplot(4,1,4);
plot(SL3,'LineWidth',2.0);
xlabel("步伐/步");ylabel("步长/m");
grid on;