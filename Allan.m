clc;    %清空命令行窗口
clear;  %清空工作区
for jjj=1:2
[FileName,PathName] = uigetfile('*.txt',...
    '选择陀螺仪数据文件');
file=fullfile(PathName,FileName);
data=load(file);
% data = dlmread('data.dat');         %从文本中读取数据，单位：deg/s，速率：100Hz
% data = dlmread('meilan-note5.csv');         %从文本中读取数据，单位：deg/s，速率：100Hz
if jjj==1
data = data(1:720000, 4:6)*3600; 
y0=data(:,1);
tau0=0.01;
end
if jjj==2
data = data(:, 2:4)*3600*180/pi;  
y0=data(:,1);
tau0=0.02;  
end
    N = length(y0);
    y = y0; NL = N;
    for k = 1:log2(N)
        sigma(k,1) = sqrt(1/(2*(NL-1))*sum((y(2:NL)-y(1:NL-1)).^2)); % diff&std
        tau(k,1) = 2^(k-1)*tau0;      % correlated time
        Err(k,1) = 1/sqrt(2*(NL-1));  % error boundary
        NL = floor(NL/2);
        if NL<3
            break;
        end
        y = 1/2*(y(1:2:2*NL) + y(2:2:2*NL));  % mean & half data length
    end
    figure(222);
%     subplot(211), plot(tau0*(1:N)', y0); grid
%     xlabel('\itt \rm/ s'); ylabel('\ity');
%     subplot(212), 
%     loglog(tau, sigma, '-+', tau, [sigma.*(1+Err),sigma.*(1-Err)], 'r--');
 loglog(tau, sigma, '-+');
 %% 
    grid on
    xlabel('\itt \rm/ s'); ylabel('\it\sigma_A\rm( \tau )');
    hold on;
end
