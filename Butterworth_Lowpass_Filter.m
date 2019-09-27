%% 加载数据
function [after_sf] = Butterworth_Lowpass_Filter(x,fx)
Ax = x(:,1);  %加速度计原始数据
N=length(x);
f=fx;
t=(1:N)/f;
s={Ax};
%% 滤波器模型dee
fp=3;              %通带截止频率
fs=4;              %阻带截止频率
Wp=2*fp/f;           %标准化通带截止频率
Ws=2*fs/f;           %标准化阻带截止频率
Rp=1;                %通带最大衰减（dB）
Rs=3;                %阻带最小衰减（dB）
%% 巴特沃斯低通滤波
[n,Wn] = buttord(Wp,Ws,Rp,Rs);%得到巴特沃斯滤波器的最小阶数n和3dB截止角频率wn
n=2;
[b,a] = butter(n,Wn);%得到低通数字巴特沃斯滤波器分子b和分母a(b、a均为n+1维行向量)
sf = cell(1,1);             % 滤波后信号
sf{1} = filter(b,a,s{1});
after_sf=cell2mat(sf);
end
