%2019/8/27
%FFT分析离散类型信号
%做出频谱图
function [f,power] = FFTanlys(Input)
    N=length(Input);%数据长度
    %spectrum analysis
    fs=50;    i=0:N-1;  t=i/fs;
    y=fft(Input,N);%进行fft变换
    mag=abs(y);%求幅值
    f=(0:N-1)*fs/N;%横坐标频率的表达式为f=(0:M-1)*Fs/M;
    power=mag.^2;
%     figure;
    plot(f,power);
end

