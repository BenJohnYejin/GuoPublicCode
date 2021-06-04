% clear;
function []=fft_a(Signal)
    fs=50;
    Width=size(Signal,2);
    
%     figure;
    for j=1:Width
        r=Signal(:,j);
        y=fft(r);%进行fft变换 
        mag=abs(y);%求幅值
        f=(0:length(y)-1)'*fs/length(y);%进行对应的频率转换
        subplot(Width,1,j);plot(f,mag);xlim([0.5,5])
    end
    %设置滤波参数
%     temp=MainAcc;
%     fs=50;fpass=0.5;fstop=2;
%     Wn=[fpass/(fs/2) fstop/(fs/2)];n=4;
%     %进行滤波
%     [c,d]=butter(n,Wn);
%     a=filter(c,d,temp);
end