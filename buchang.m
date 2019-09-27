function[B2,J]=buchang()
clear all;
clc;
[FileName,PathName] = uigetfile('*.txt',...
                '选择加速度文件'); 
            file=fullfile(PathName,FileName); 
            data1=load(file);
A1=data1;
[FileName,PathName] = uigetfile('*.txt',...
                '选择陀螺仪文件'); 
            file=fullfile(PathName,FileName); 
            data2=load(file);
A2=data2;
n=size(A1,1);j=1;
%数据去重复
B(1,:)=A1(1,:);B2(1,:)=A2(1,:);
  for i=2:n
         if(A1(i,1)~=B(j,1)) %按时间进行去重     
            j=j+1;
          B(j,:)=A1(i,:); 
          B2(j,:)=A2(i,:);  
          end;
          i=i+1;
  end;
  B(:,1)=B(:,1)*60; B2(:,1)=B2(:,1)*60;
% for i=4:3:n
%   B(j,1)=A1(i,1)*60; B2(j,1)=A2(i,1)*60;
%   B(j,2)=A1(i,2);    B2(j,2)=A2(i,2);
%   B(j,3)=A1(i,3);    B2(j,3)=A2(i,3);
%   B(j,4)=A1(i,4);    B2(j,4)=A2(i,4);
% j=j+1;
% end;
%卡尔曼处理加速度
for i=1:j-1
     C(i,1)=sqrt(B(i,2)*B(i,2)+B(i,3)*B(i,3)+B(i,4)*B(i,4));%合加速度
     T(i,1)=B(i,1);%时刻
end;
 X=C(1,1);
 P=1;
 F=1;
 Q=0.03;
 H=1;
 R=0.02;
 for i=1:j-1
    X_=F*X;
    P_=P+Q;
    K=P_*P+R;
    X=X_+K*(C(i,1)-X_);
    P=(1-K)*P_;
    D(i,1)=X;
 end ;
%以下为计步数
step=0;st=1;k=1;
f=0;    %步频初始
for i=4:j-3
    if((D(i-1,1)<D(i,1)&&D(i,1)>D(i+1,1))||(D(i-1,1)>D(i,1)&&D(i,1)<D(i+1,1)))
        if(T(i,1)-T(st,1)>0.2)&&((D(i,1)>D(i-2,1)&&D(i,1)>D(i+2,1))||(D(i,1)<D(i-2,1)&&D(i,1)<D(i+2,1)))
           step=step+1;
           st=i;
           N(k,1)=T(i,1);
           k=k+1;                   
        end;
    end;
end;
realstep=step/2;
t=1;J(1,1)=0;J(1,2)=0;
for i=1:2:k-1
    t=t+1;
    J(t,1)=N(i,1);
    f=1/(J(t,1)-J(t-1,1));
    J(t,2)=0.013912*178-0.037546*65+0.459939*f-0.095362;    %实时步长
end;
J(t,3)=realstep;
end

   
    




    