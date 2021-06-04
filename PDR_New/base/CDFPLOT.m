function [] = CDFPLOT(ERRO)
%CDFPLOT 此处显示有关此函数的摘要
%   此处显示详细说明
		ERRO=abs(ERRO);
    Wid=size(ERRO,2);
    Range=[0:20];
    N=hist(ERRO,Range);
%     figure;
    hold on;
    for j=1:Wid
        cdf=cumsum(N(:,j))/sum(N(:,j));
        plot(Range,cdf,'LineWidth',2,'LineStyle','--');
    end
    legend("Gyr","EKF","EKF+HDE","Mag+Match");
    xlabel("航向误差/°")
    ylabel("CDF")
    ylim([0.1,1.1])
    grid on;
end

