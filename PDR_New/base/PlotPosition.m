

function []=PlotPosition(Cor)
    hold on;
    plot(Cor(:,2),-Cor(:,1),'LineWidth',2,'LineStyle','-');
end