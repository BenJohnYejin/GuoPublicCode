%处理从  下载的数据集
%输入数据   原始数据格式 [flag,acc*3,gyr*3,mag*3,Time,sl sn distance]
%输出数据   结构体Point data SL
%-------- 2019/9/19 -------
function  [DataSet,AccD]=TrainDataProcess(FileName) 
    [Flag,Accx,Accy,Accz,Gyrx,Gyry,Gyrz,Magx,Magy,Magz,Time,SL,SN,Distance]=textread(...
        FileName,'%s %f %f %f %f %f %f %f %f %f %f %f %f %f');
    %获取步频点
    SN=diff(SN);
    [x]=find(SN);
    %获取步长
    DataSet.SL=SL(x);
    %获取三轴加速度数据
    DataSet.Acc=[Accx,Accy,Accz];
    AccD=SplitAcc([Accx,Accy,Accz],x);
    DataSet.Fs=100;
    DataSet.StepDec=x;
end