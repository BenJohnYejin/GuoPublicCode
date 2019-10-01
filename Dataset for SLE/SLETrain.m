% 使用  网上的数据进行训练
% 2019/9/30
clear;
[Data,StepDec]=TrainDataProcess('B:\temp\SLEDataSet\RawData1.txt');
MotionAcc=RawDataProcess(Data.Acc);
% [x] = GetStepNumber(MotionAcc);

% figure;hold on;
% plot(MotionAcc);
% plot(x,MotionAcc(x),'rx');

SL=Data.SL;
SL(1)=[];SL(1)=[];
StepDec(1)=[];StepDec(1)=[];
Num=length(SL);
Time=zeros(Num,1);Area=Time;
for i=1:Num
    Acc=SSAfit(StepDec(i).Acc);
    MainAcc=Acc(:,1);
    plot(MainAcc);
    [Time(i),Area(i)]=GetFea(MainAcc);
end


function [Time,Area]=GetFea(Acc)
    Time=length(Acc)/100;
    Area=sum(Acc);    
end