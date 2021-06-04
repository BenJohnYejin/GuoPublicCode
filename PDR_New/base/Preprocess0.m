PathName="B://DataForFinal/Data/Challage.txt";
% PathName="B://temp/data.txt";
Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
Len=size(Acc,1);
[TimeDete,~,~]=StepDetecte(Acc,Fs);
Size=length(TimeDete);
for j=1:Size-1
    Index0=TimeDete(j);
    Index1=TimeDete(j+1);
    
    Accx=Acc(Index0:Index1,1);
    dlmwrite("B://temp/Accx.txt",Accx','-append');
    Accy=Acc(Index0:Index1,2);
    dlmwrite("B://temp/Accy.txt",Accy','-append');
    Accz=Acc(Index0:Index1,3);
    dlmwrite("B://temp/Accz.txt",Accz','-append');
    
    Gyrx=Gyr(Index0:Index1,1);
    dlmwrite("B://temp/Gyrx.txt",Gyrx','-append');
    Gyry=Gyr(Index0:Index1,2);
    dlmwrite("B://temp/Gyry.txt",Gyry','-append');
    Gyrz=Gyr(Index0:Index1,3);
    dlmwrite("B://temp/Gyrz.txt",Gyrz','-append');
end