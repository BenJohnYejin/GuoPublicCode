%----2019/8/21-----
%曲线拟合 并作图
%输入参数  待拟合曲线X,Y   阶数k
%输出参数 P=[]；各阶系数 从高阶到低阶
function [P,Det] = CurveFit(X,Y,k)
figure;
%title('曲线拟合');hold on;
% xlabel('特征值');ylabel('步长值');
%做出散点图
plot(X,Y,'rx');hold on;
%利用polyfit函数进行拟合
P = polyfit(X,Y,k);Yi=polyval(P,X);
%做出拟合曲线
plot(X,Yi,'kx');
%得到残差
Det=Y-Yi;
end