
% clear;clc;
Heading=load("B:\DataForFinal\航向\PocketLongHeading.txt");
SL=load("B:\DataForFinal\步长\PocketLongSL.txt");
Length=size(SL,1);
Pos=zeros(Length,2);
Pos=GetCor(Pos,SL,Heading);
Pos(:,1)=-Pos(:,1);
Pos(:,3)=Pos(:,1);Pos(:,1)=Pos(:,2);Pos(:,2)=Pos(:,3);
PlotPosition(Pos);

dlmwrite("PosLong.txt",PosLong);

for j=1:4
    Pos=PosLong(:,2*j-1:2*j);
    Pos(all(Pos==0,2),:) = []; 
    Pos=[[0,0];Pos];
    PlotPosition(Pos);
    
end
grid on;
% xlim([-5,95]);ylim([-5,95]);
xlabel("东向/m");ylabel("北向/m");
hold on;
plot(0,0,'ro','LineWidth',2.0);
plot(0,0,'rx','LineWidth',2.0);
plot(242,-90,'ro','LineWidth',2.0);
plot(242,-90,'rx','LineWidth',2.0);
% text(0,0,"起点与终点","FontSize",15);
% plot(0,0,'ro','LineWidth',2.0);plot(0,83,'ro','LineWidth',2.0);
% plot(0,0,'rx','LineWidth',2.0);plot(0,83,'rx','LineWidth',2.0);
text(0,0,"起点","FontSize",15);text(242,-90,"终点","FontSize",15);

legend("发信息","打电话","摆臂","口袋")