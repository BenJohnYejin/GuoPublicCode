%%%谨慎对该文件做任何删改%%%%%
function [x2,y2]=jiehe()
clear all;
clc;
huoqu=@buchang;
[tuoluoyi(:,1:4),y]=huoqu();
%----------加速度变量-------------%
[o,p]=size(y);
%---------陀螺仪计算变量----------%
[m,n]=size(tuoluoyi);  
zitai=zeros(m,n);
zitai(:,1)=tuoluoyi(:,1);
disp('1:0/0/90...2:0/0/-90...3:0/0/0...4:全部手动输入...')
qingkuang=input('请手动输入请输入选择情况：');
switch qingkuang
    case 1
zitai(1,2)=0;
zitai(1,3)=0;
zitai(1,4)=90;
    case 2
zitai(1,2)=0;
zitai(1,3)=0;
zitai(1,4)=-90;
    case 3
zitai(1,2)=0;
zitai(1,3)=0;
zitai(1,4)=0;   
    otherwise
zitai(1,2)=input('请输入初始姿态横滚角为/°：');
zitai(1,3)=input('请输入初始姿态俯仰角为/°：');
zitai(1,4)=input('请输入初始姿态航向角为/°：');
end
% m1=fix(m/2);
zitai(1,2)=zitai(1,2)*pi/180;
zitai(1,3)=zitai(1,3)*pi/180;
zitai(1,4)=zitai(1,4)*pi/180;
chushihua=@chushisiyuanshu;
cbn=zeros(m,3,3);
[cbn(1,1:3,1:3),p1(1),p2(1),p3(1),p4(1)]=chushihua(zitai(1,2),zitai(1,3),zitai(1,4));
% %----------------拆分数据--------%
for i=2:m
    zhuanhuan=@siyuanshu2;
    h=1/(m/(zitai(m,1)));
    [zitai(i,2),zitai(i,3),zitai(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuanhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
end; 
% for i=2:m
%     zhuan=@shengjiban;
%     [zi(i,2),zi(i,3),zi(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
% for i=2:m
%     zhuan=@shengjiban1;
%     [zi1(i,2),zi1(i,3),zi1(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
% 
% for i=2:m
%     zhuan=@shengjiban2;
%     [zi2(i,2),zi2(i,3),zi2(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
% mm=fix(m/2);
% for i=2:mm
%     zhuan=@shengjiban3;
%     [zi3(i,2),zi3(i,3),zi3(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(2*i-2,2),tuoluoyi(2*i-2,3),tuoluoyi(2*i-2,4),tuoluoyi(2*i-1,2),tuoluoyi(2*i-1,3),tuoluoyi(2*i-1,4),tuoluoyi(2*i,2),tuoluoyi(2*i,3),tuoluoyi(2*i,4),h);
% end; 
% %----------------拆分数据--------%
% for i=2:m1
%     zhuanhuan=@siyuanshu;
%     h=1/(m/(zitai(m,1)));
%     [zitai(i,2),zitai(i,3),zitai(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuanhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
% for i=2:m1
%     zhuan=@shengjiban;
%    
%     [zi(i,2),zi(i,3),zi(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
% for i=2:4
%     zitai(m1,i)= zitai(m1,i)+zitai(m1-1,i)+zitai(m1-2,i)+zitai(m1-3-1,i)+zitai(m1-4,i);
% zitai(m1,i)=zitai(m1,i)/5;
% end;
% zitai(m1,4)=pi+zitai(m1,4);
% [cbn(m1,1:3,1:3),p1(m1),p2(m1),p3(m1),p4(m1)]=chushihua(zitai(m1,2),zitai(m1,3),zitai(m1,4));
% for i=m1+1:m
% 
%     [zitai(i,2),zitai(i,3),zitai(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuanhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
% for i=m1+1:m
% 
%     [zi(i,2),zi(i,3),zi(i,4),cbn(i,1:3,1:3),p1(i),p2(i),p3(i),p4(i)]=zhuan(p1(i-1),p2(i-1),p3(i-1),p4(i-1),tuoluoyi(i-1,2),tuoluoyi(i-1,3),tuoluoyi(i-1,4),tuoluoyi(i,2),tuoluoyi(i,3),tuoluoyi(i,4),h);
% end; 
    
%-----------------存储计算所得数据----------%
% fid=fopen('jie223344.txt','w');
% for i=1:m
%     for j=1:n
%         if(j==n)
%             fprintf(fid,'%6.4f\n',zitai(i,j));
%         else
%             fprintf(fid,'%6.4f\t',zitai(i,j));
%         end;
%     end;
% end;
% fclose(fid);

%------------计算坐标------------%
% for i=1:o
%     for j=1:m    
%     if(zitai(j,1)==y(i,1))      
%    theta0(i)=zitai(j,4);
% end;
%     end;
% end;
% for i=1:o
%     for j=1:m    
%     if(zitai(j,1)==y(i,1))      
%     theta(i)=zi(j,4);
%     
% end;
% end;
% end;
for i=1:o
    for j=1:m    
    if(zitai(j,1)==y(i,1))      
   theta0(i)=zitai(j,4);% 航向角为人体航向
% theta0(i)=zitai(j,2); %横滚角为人体航向
%    theta(i)=zi(j,4);
%    theta1(i)=zi1(j,4);
%    theta2(i)=zi2(j,4);


end;
    end;
end;
% zhuanhuan=theta0;%单位rad
%----------HDE--------------%
% for i=3:o
%     theta0(i)=theta0(i)*180/pi;
%     date=(abs(zhuanhuan(i)-zhuanhuan(i-1))+abs(zhuanhuan(i)-zhuanhuan(i-2)))/2;%%有问题
%   if(abs(date)<10)
%       theta=mod(theta0(i),90);
%       if(theta<45)
%       theta0(i)=theta0(i)-0.0*date-theta;
% %         theta0(i)=theta0(i)-theta;
%       if(theta>45)
%       theta0(i)=theta0(i)-0.0*date+(90-theta);
%   end;
% end
%   end
%   theta0(i)=theta0(i)*pi/180;
% end


% ii=fix(o/2);
% for i=1:ii
%     for j=1:mm
%          if(zitai(2*j-1,1)==y(2*ii,1)) 
%        theta3(i)=zi3(j,4)
%  
%          end;
%     end;
% end;
% for i=1:o
%     for j=1:m    
%     if(zitai(j,1)==y(i,1))      
%    
%     
% end;
% end;
% end;
% for i=1:o
%     for j=1:m    
%     if(zitai(j,1)==y(i,1))      
%     theta(i)=zi(j,4);
%     
% end;
% end;
% end;
% for i=1:o
%     for j=1:m    
%     if(zitai(j,1)==y(i,1))      
%     theta(i)=zi(j,4);
%     
% end;
% end;
% end;
zzi(1)=0;zzy(1)=0;
% for i=2:51
%     zzi(i)=i-1;zzy(i)=0;
% end;
for i=2:43
zzi(i)=i-1;zzy(i)=0;
end
for i=44:105
zzi(i)=42;zzy(i)=i-43;
end
for i=106:147
zzi(i)=42-(i-105);zzy(i)=62;
end
for i=148:209
zzi(i)=0;zzy(i)=62-(i-147);
end
%----------zuobiaojisuan------------%
fprintf('您走的步数为:%d\n',o);
ss=0;
for i=1:o
    ss=ss+y(i,2);
end;
fprintf('您走的距离为:%d\n',ss);
x1(1)=0;
% x2(1)=0;
% x3(1)=0;
% x4(1)=0;
% x5(1)=0;%x坐标 
y1(1)=0;
% y2(1)=0;
% y4(1)=0;
% y3(1)=0;
% y5(1)=0;%y坐标
     
 for i=1:o
    S=y(i,2);

 [x1(i+1),y1(i+1)]=zuobiao(S,theta0(i),x1(i),y1(i));
%   [x2(i+1),y2(i+1)]=weizhi(S,theta(i),x2(i),y2(i));
%   [x3(i+1),y3(i+1)]=weizhi(S,theta1(i),x3(i),y3(i));
%   [x4(i+1),y4(i+1)]=weizhi(S,theta2(i),x4(i),y4(i));

  end;
  
%   for i=1:ii
%     S=(y(2*i-1)+y(2*i))/2;
%  [x5(i+1),y5(i+1)]=weizhi(S,theta3(i),x5(i),y5(i));
%   end; 
  fprintf('二阶:%d',x1(o+1),y1(o+1));
%   fprintf('四阶:%d',x2(o+1),y2(o+1));
%     fprintf('四阶1:%d',x3(o+1),y3(o+1));
%     fprintf('四阶2:%d',x4(o+1),y4(o+1));
   
  plot(y1(1:o+1),x1(1:o+1),'-go')
    hold on;
    axis equal;
    title('不同四元数解法对比路线图'); 
   xlabel('单位 /m');ylabel('单位 /m');

%    plot(y2(1:o+1),x2(1:o+1),'-r*') 
%    plot(y3(1:o+1),x3(1:o+1),'-b*') 
%    plot(y4(1:o+1),x4(1:o+1),'-k') 
%     plot(y5(1:ii+1),x5(1:ii+1),'-k') 
   plot(zzi(1:209),zzy(1:209),'k')
%  plot(zzi(1:51),zzy(1:51),'k')
% legend('二阶龙格库塔法','四阶龙格库塔法','四阶龙格库塔法1','四阶龙格库塔法2','参考路径'); 
legend('二阶龙格库塔法','参考路径'); 
    zoom on;
    grid on;
  
%   [xt,yt]=ginput(5);
end