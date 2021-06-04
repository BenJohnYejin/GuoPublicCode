Text0=load("B:\\temp\8text.csv");
Call0=load("B:\\temp\8call.csv");
Swing0=load("B:\\temp\8swing.csv");
Pocket0=load("B:\\temp\8pock.csv");


Text=[Text;Text0];
Call=[Call;Call0];
Swing=[Swing;Swing0];
Pocket=[Pocket;Pocket0];

subplot(3,1,1);hold on;
hist(Text(:,1));hist(Call(:,1));hist(Swing(:,1));hist(Pocket(:,1));
subplot(3,1,2);hold on;
hist(Text(:,2));hist(Call(:,2));hist(Swing(:,2));hist(Pocket(:,2));
subplot(3,1,3);hold on;
hist(Text(:,3));hist(Call(:,3));hist(Swing(:,3));hist(Pocket(:,3));


% dlmwrite("B:\\temp\Text.txt",Text);
% dlmwrite("B:\\temp\Call.txt",Call);
% dlmwrite("B:\\temp\Swing.txt",Swing);
% dlmwrite("B:\\temp\Pocket.txt",Pocket);

plot3(Text(:,1),Text(:,2),Text(:,3),'ro');hold on;
plot3(Call(:,1),Call(:,2),Call(:,3),'bo');
plot3(Swing(:,1),Swing(:,2),Swing(:,3),'go');
plot3(Pocket(:,1),Pocket(:,2),Pocket(:,3),'o');

AttEKF(63:144)=AttEKF(63:144)-pi;
AttMag(63:144)=AttMag(63:144)-pi;

AttEKF(202:end)=AttEKF(202:end)+pi;
AttMag(202:end)=AttMag(202:end)+pi;

subplot(1,3,[1,2])
AttEKF=AttSmooth(AttEKF);
plot(AttEKF*180/pi,"LineWidth",2.0);hold on;
plot(AttMag*180/pi,"LineWidth",2.0);
xlabel("时间/s");ylabel("角度/°");
grid on;legend("EKF航向","磁航向匹配算法");

TrueHeading=AttMag;
TrueHeading(1:76)=pi/2;
TrueHeading(77:130)=0;
TrueHeading(131:212)=-pi/2;
TrueHeading(213:end)=pi;

Erro=[AttEKF,AttMag]-AttMag;
Erro=[AttEKF,AttMag]-TrueHeading;
Index=subplot(1,3,3);
CDFPLOT(Erro*180/pi);ind(Erro>1.8*pi);
Erro(Index)=Erro(Index)-2*pi;



plot(Ts,Erro*180/pi);