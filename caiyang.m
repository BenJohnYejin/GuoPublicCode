function [Acc,m,T]=caiyang()
clear all;
clc;
[FileName,PathName] = uigetfile('*.txt',...
                '选择加速度计数据文件'); 
            file=fullfile(PathName,FileName); 
            AAA=load(file);
  [Row,Col]=size(AAA); 
  %数据去重复
  j=1;
T(1,:)=AAA(1,1);Acc(1,1:3)=AAA(1,2:4);
  for i=2:Row
         if AAA(i,1)~=T(j,1)  %按时间进行去重           
            j=j+1;
            T(j,1)=AAA(i,1);
          Acc(j,1:3)=AAA(i,2:4); 
          Acc(j,4)=sqrt(Acc(j,1)*Acc(j,1)+Acc(j,2)*Acc(j,2)+Acc(j,3)*Acc(j,3));
          end;
  end;
m=j;

% count=0;st=1;k=1;
% for i=3:m-3
%     if(( Acc(i-1,1)< Acc(i,1)&&Acc(i,1)> Acc(i+1,1))||( Acc(i-1,1)> Acc(i,1)&&Acc(i,1)< Acc(i+1,1)))
%         if ((i-st>2)&&(abs(Acc(i,1))>0.1))
%            count=count+1;
%            st=i;
%            k=k+1;
% %          N(k,1)=i*0.05;  %   新软件用
%            N(k,1)=T(i,1);
%           end
%     end
% end
% count=round(count/2);
% j=1;   StepPoint(1,1)=0;     S=0;
% for i=2:2:k
%     j=j+1;
%     StepPoint(j,1)=N(i,1);                                                   %检步点
%     if(StepPoint(j,1)~=0)
%       fstep(j-1,1)=1/(60*(StepPoint(j,1)-StepPoint(j-1,1)));                      %实时步频
%       Lstep(j-1,1)=(0.013912*178-0.037546*65+0.459939*fstep(j-1,1)-0.095362);%实时步长
%       S=S+Lstep(j-1,1);                                                      %行进距离累计
%     end 
% end

 end