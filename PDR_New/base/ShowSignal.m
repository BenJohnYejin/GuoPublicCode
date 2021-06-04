
function ShowSignal(Ts,Signal)
    subplot(3,1,1);plot(Ts,Signal(:,1),'LineWidth',1);hold on;
    subplot(3,1,2);plot(Ts,Signal(:,2),'LineWidth',1);hold on;
    subplot(3,1,3);plot(Ts,Signal(:,3),'LineWidth',1);hold on;
end