for j=1:90
    theta1(j)=j;
    theta2(j)=j;
    dte1=45;dte2=90;
    theta1(j)=mod(theta1(j),dte1);                                                %¹Û²â·½³Ì
    theta2(j)=mod(theta2(j),dte2);
    if theta1(j)>dte1/2
        theta1(j)=theta1(j)-dte1;
    end;
    if theta2(j)>dte2/2
        theta2(j)=theta2(j)-dte2;
    end;
    a1(j)=0.1/(exp(-5*abs(theta1(j)/dte1)))
    a2(j)=0.25/(exp(-10*abs(theta2(j)/dte2)))
end
figure(1)
hold on;
plot(a1,'-g*','linewidth',1)
plot(a2,'-b*','linewidth',1)