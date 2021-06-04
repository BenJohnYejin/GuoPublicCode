% clear;
function []=fft_a(r)
    fs=50;
    y=fft(r);%进行fft变换 
    mag=abs(y);%求幅值
    f=(0:length(y)-1)'*fs/length(y);%进行对应的频率转换
    figure;
    plot(f,mag);
    set(gca,'Xlim',[0,5]);
    %设置滤波参数
%     temp=MainAcc;
%     fs=50;fpass=0.5;fstop=2;
%     Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%     %进行滤波
%     [c,d]=butter(n,Wn);
%     a=filter(c,d,temp);
end