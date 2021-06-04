%
clear;
Data=load("B://data_pdr/result/Mag1.txt");
data=Data(:,7:9);

xx=data(:,1).^2;yy=data(:,2).^2;zz=data(:,3).^2;
xy=data(:,1).*data(:,2);xz=data(:,1).*data(:,3);yz=data(:,2).*data(:,3);
x=data(:,1);y=data(:,2);z=data(:,3);

figure;
subplot(3,1,1);hold on;plot(x,y);xlim([-50,50]);ylim([-50,50]);axis equal;
subplot(3,1,2);hold on;plot(x,z);xlim([-50,50]);ylim([-50,50]);axis equal;
subplot(3,1,3);hold on;plot(y,z);xlim([-50,50]);ylim([-50,50]);axis equal;
% scatter3(x,y,z);

H=[xx,yy,zz,xy,xz,yz,x,y,z];
Length=length(x);
y1=ones(Length,1);
result=(H'*H)\H'*y1;
result=result/result(1);result(1)=[];
result(6)=result(6)-1;

x0=-0.5*result(3);y0=-0.5*result(4)/result(1);z0=-0.5*result(5)/result(2);
scalex=result(6)+0.5*(result(3)*x0+result(4)*y0+result(5)*z0);
scaley=scalex/result(1);
scalez=scalex/result(2);

x=(x-x0)/scalex.^0.5;
y=(y-y0)/scaley.^0.5;
z=(z-z0)/scalez.^0.5;
subplot(3,1,1);hold on;plot(x,y);xlim([-50,50]);ylim([-50,50]);axis equal;
subplot(3,1,2);hold on;plot(x,z);xlim([-50,50]);ylim([-50,50]);axis equal;
subplot(3,1,3);hold on;plot(y,z);xlim([-50,50]);ylim([-50,50]);axis equal;
% hold on
% scatter3(x,y,z);