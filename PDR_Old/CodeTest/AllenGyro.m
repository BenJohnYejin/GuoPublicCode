clear;
data=load("B://data_PDR/result/Allen1.txt");
y=data(:,4:6)*180/3.14159826*3600;m=1;Fs=50;
[sigma, tau, Err]=avar(y,1/Fs);
yy=log10(sigma);xx=log10(tau);

p1=polyfit(xx(1:8),yy(1:8),1);
ARW=polyval(p1,1);

p2=polyfit(xx(9:12),yy(9:12),1);
BI=polyval(p2,1)*1.5;
% [A, B] = allan(y, Fs, 100);         %求Allan标准差，用100个点来描述
% 
% figure;
% loglog(A, B, 'o');                  %画双对数坐标图
% xlabel('time:sec');                 %添加x轴标签
% ylabel('Sigma:deg/h');              %添加y轴标签
% legend('X axis','Y axis','Z axis'); %添加标注
% grid on;                            %添加网格线
% hold on;                            %使图像不被覆盖
% 
% 
% C(1, :) = nihe(A', (B(:,1)').^2, 2)';   
% C(2, :) = nihe(A', (B(:,2)').^2, 2)';
% C(3, :) = nihe(A', (B(:,3)').^2, 2)';
% 
% Q = sqrt(abs(C(:, 1) / 3));             %量化噪声，单位：deg/h
% N = sqrt(abs(C(:, 2) / 1)) / 60;	%角度随机游走，单位：deg/h^0.5
% Bs = sqrt(abs(C(:, 3))) / 0.6643;	%零偏不稳定性，单位：deg/h
% K = sqrt(abs(C(:, 4) * 3)) * 60;	%角速率游走，单位：deg/h/h^0.5
% R = sqrt(abs(C(:, 5) * 2)) * 3600;	%速率斜坡，单位：deg/h/h

% fprintf('量化噪声      X轴：%f Y轴：%f Z轴：%f  单位：deg/h\n', Q(1), Q(2), Q(3));
% fprintf('角度随机游走  X轴：%f Y轴：%f Z轴：%f  单位：deg/h^0.5\n', N(1), N(2), N(3));
% fprintf('零偏不稳定性  X轴：%f Y轴：%f Z轴：%f  单位：deg/h\n', Bs(1), Bs(2), Bs(3));
% fprintf('角速率游走    X轴：%f Y轴：%f Z轴：%f  单位：deg/h/h^0.5\n', K(1), K(2), K(3));
% fprintf('速率斜坡      X轴：%f Y轴：%f Z轴：%f  单位：deg/h/h\n', R(1), R(2), R(3));
% 
% D(:, 1) = sqrt(C(1,1)*A.^(-2) + C(1,2)*A.^(-1) + C(1,3)*A.^(0) + C(1,4)*A.^(1) + C(1,5)*A.^(2));	%生成拟合函数
% D(:, 2) = sqrt(C(2,1)*A.^(-2) + C(2,2)*A.^(-1) + C(2,3)*A.^(0) + C(2,4)*A.^(1) + C(2,5)*A.^(2));
% D(:, 3) = sqrt(C(3,1)*A.^(-2) + C(3,2)*A.^(-1) + C(3,3)*A.^(0) + C(3,4)*A.^(1) + C(3,5)*A.^(2));

% loglog(A, D);   %画双对数坐标图

function [T,sigma] = allan(omega,fs,pts)
[N,M] = size(omega);             % figure out how big the output data set is
n = 2.^(0:floor(log2(N/2)))';    % determine largest bin size
maxN = n(end);
endLogInc = log10(maxN);
m = unique(ceil(logspace(0,endLogInc,pts)))';    % create log spaced vector average factor
t0 = 1/fs;                                       % t0 = sample interval
T = m*t0;                                        % T = length of time for each cluster
theta = cumsum(omega)/fs;       % integration of samples over time to obtain output angle θ
sigma2 = zeros(length(T),M);    % array of dimensions (cluster periods) X (#variables)
for i=1:length(m)               % loop over the various cluster sizes
    for k=1:N-2*m(i)            % implements the summation in the AV equation
        sigma2(i,:) = sigma2(i,:) + (theta(k+2*m(i),:) - 2*theta(k+m(i),:) + theta(k,:)).^2;
    end
end
sigma2 = sigma2./repmat((2*T.^2.*(N-2*m)),1,M);
sigma = sqrt(sigma2);
end

function C=nihe(tau,sig,M)
X=tau';Y=sig';
B=zeros(1,2*M+1);
F=zeros(length(X),2*M+1);

for i=1:2*M+1
    kk=i-M-1;
    F(:,i)=X.^kk;
end

A=F'*F;
B=F'*Y;
C=A\B;
end
% [avarFromFunc, tauFromFunc] = allanvar(omega, m, Fs);
% adevFromFunc = sqrt(avarFromFunc);
% 
% figure
% loglog(tau, adev, tauFromFunc, adevFromFunc);
% title('Allan Deviations')
% xlabel('\tau')
% ylabel('\sigma(\tau)')
% legend('Manual Calculation', 'allanvar Function')
% grid on
% axis equal
% 
% % Find the index where the slope of the log-scaled Allan deviation is equal
% % to the slope specified.
% slope = -0.5;
% logtau = log10(tau);
% logadev = log10(adev);
% dlogadev = diff(logadev) ./ diff(logtau);
% [~, i] = min(abs(dlogadev - slope));
% 
% % Find the y-intercept of the line.
% b = logadev(i) - slope*logtau(i);
% 
% % Determine the angle random walk coefficient from the line.
% logN = slope*log(1) + b;
% N = 10^logN;
% 
% % Plot the results.
% tauN = 1;
% lineN = N ./ sqrt(tau);
% figure
% loglog(tau, adev, tau, lineN, '--', tauN, N, 'o')
% title('Allan Deviation with Angle Random Walk')
% xlabel('\tau')
% ylabel('\sigma(\tau)')
% legend('\sigma', '\sigma_N')
% text(tauN, N, 'N')
% grid on
% axis equal
% 
% % Find the index where the slope of the log-scaled Allan deviation is equal
% % to the slope specified.
% slope = 0.5;
% logtau = log10(tau);
% logadev = log10(adev);
% dlogadev = diff(logadev) ./ diff(logtau);
% [~, i] = min(abs(dlogadev - slope));
% 
% % Find the y-intercept of the line.
% b = logadev(i) - slope*logtau(i);
% 
% % Determine the rate random walk coefficient from the line.
% logK = slope*log10(3) + b;
% K = 10^logK;
% 
% % Plot the results.
% tauK = 3;
% lineK = K .* sqrt(tau/3);
% figure
% loglog(tau, adev, tau, lineK, '--', tauK, K, 'o')
% title('Allan Deviation with Rate Random Walk')
% xlabel('\tau')
% ylabel('\sigma(\tau)')
% legend('\sigma', '\sigma_K')
% text(tauK, K, 'K')
% grid on
% axis equal
% 
% % Find the index where the slope of the log-scaled Allan deviation is equal
% % to the slope specified.
% slope = 0;
% logtau = log10(tau);
% logadev = log10(adev);
% dlogadev = diff(logadev) ./ diff(logtau);
% [~, i] = min(abs(dlogadev - slope));
% 
% % Find the y-intercept of the line.
% b = logadev(i) - slope*logtau(i);
% 
% % Determine the bias instability coefficient from the line.
% scfB = sqrt(2*log(2)/pi);
% logB = b - log10(scfB);
% B = 10^logB;
% 
% % Plot the results.
% tauB = tau(i);
% lineB = B * scfB * ones(size(tau));
% figure
% loglog(tau, adev, tau, lineB, '--', tauB, scfB*B, 'o')
% title('Allan Deviation with Bias Instability')
% xlabel('\tau')
% ylabel('\sigma(\tau)')
% legend('\sigma', '\sigma_B')
% text(tauB, scfB*B, '0.664B')
% grid on
% axis equal