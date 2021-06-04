%使用旋转矢量法解算姿态

%初始化四元数 理论上对准后有姿态阵 P258页
%这里我们就假定初始姿态角
a1=0;a2=0;a3=0;
Q=zeros(4,1);
Q(1)=cos(a1/2)*cos(a2/2)*cos(a3/2)+sin(a1/2)*sin(a2/2)*sin(a3/2);
Q(2)=cos(a1/2)*cos(a2/2)*sin(a3/2)-sin(a1/2)*sin(a2/2)*cos(a3/2);
Q(3)=cos(a1/2)*sin(a2/2)*cos(a3/2)+sin(a1/2)*cos(a2/2)*sin(a3/2);
Q(4)=-cos(a1/2)*sin(a2/2)*sin(a3/2)+sin(a1/2)*cos(a2/2)*cos(a3/2);
%读取陀螺仪数据
filename='B://data_PDR/MiRecT1.1.CSV';
gyo_data=load(filename);
gyo_data=gyo_data(:,4:6);
%获取角度增量
gyo_det=Get_gyo_det(gyo_data,50);
%此处三子样为重复利用，没有造成频率压缩
fi=Get_fi(gyo_det);
%旋转矢量转四元数;构造转换矩阵
norm_fi=norm_1(fi);
trans=[cos(norm_fi/2),fi./norm_fi.*sin(norm_fi/2)];

trans_Q=zeros(4,4);
A=zeros(size(trans,1),1);B=A;C=A;
for i=1:size(trans,1)
    %构造旋转矩阵
    trans_Q1=trans(i,:);
    trans_Q(1,1)=trans_Q1(1);trans_Q(1,2)=-trans_Q1(2);trans_Q(1,3)=-trans_Q1(3);trans_Q(1,4)=-trans_Q1(4);
    trans_Q(2,1)=trans_Q1(2);trans_Q(2,2)=trans_Q1(1);trans_Q(2,3)=trans_Q1(4);trans_Q(2,4)=-trans_Q1(3);
    trans_Q(3,1)=trans_Q1(3);trans_Q(3,2)=-trans_Q1(4);trans_Q(3,3)=trans_Q1(1);trans_Q(3,4)=trans_Q1(2);
    trans_Q(4,1)=trans_Q1(4);trans_Q(4,2)=trans_Q1(3);trans_Q(4,3)=-trans_Q1(2);trans_Q(4,4)=trans_Q1(1);
    %更新四元数
    Q=trans_Q*Q;
    %四元数归一化
    Q=Q/norm(Q);
    %四元数转换为欧拉角                            
    T32=2*(Q(3)*Q(4)-Q(1)*Q(2));
    A(i)=rad2deg(asin(T32));
    T31=2*(Q(2)*Q(4)-Q(1)*Q(3));T33=Q(1)*Q(1)-Q(2)*Q(2)-Q(3)*Q(3)+Q(4)*Q(4);
    B(i)=rad2deg(atan2(-T31,T33));
    T12=2*(Q(2)*Q(3)-Q(1)*Q(4));T22=Q(1)*Q(1)-Q(2)*Q(2)+Q(3)*Q(3)-Q(4)*Q(4);
    C(i)=rad2deg(atan2(T12,T22));
end
%绘制姿态
subplot(3,1,1);plot(A);
subplot(3,1,2);plot(B);
subplot(3,1,3);plot(C);
%使用梯形公式近似得到角度增量
%gyo_data为角速度  gyo_d为角度增量 fs为采样频率
function [gyo_d]=Get_gyo_det(gyo_data,fs)
    for i=1:3
        gyo_d(:,i)=(gyo_data(1:end-1,i)+gyo_data(2:end,i))*(0.5/fs);
    end
end

%获取等效旋转矢量
%旋转矢量的三子样算法
function [fi]=Get_fi(gyo_det)
    num=size(gyo_det,1);
    fi=zeros(num-2,3);
    for i=1:num-2
        fi(i,:)=gyo_det(i,:)+gyo_det(i+1,:)+gyo_det(i+2,:)...
            +9/20*cross(gyo_det(i,:),gyo_det(i+2,:))+27/40*cross(gyo_det(i+1,:)...
            ,(gyo_det(i+2,:)-gyo_det(i,:)));
    end
end

%获取等效旋转矢量的模
function [norm_fi]=norm_1(fi)
    num=size(fi,1);
    norm_fi=zeros(num,1);
    for i=1:num
       norm_fi(i)=norm(fi(i,:)); 
    end
end

