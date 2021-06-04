%步长模型训练  得到最佳的模型参数
%对kim模型进行计算
clear;
% for i=1:8
    RawData=load(strcat('B:\data_PDR\result\ChangeSpeed(','4',').csv'));
    Time=RawData(:,1);
    Acc=RawDataProcess(RawData(:,2:4));
    [x,y]=GetStepNumber(Acc);
    ArrayAcc=SplitAcc(Acc,x);
    figure;hold on;
    plot(Acc);
    plot(x,Acc(x),'rx');
    Feachers=GetFeachers(ArrayAcc);
    Feachers(1,:)=[];
%     Feachers(end,:)=[];
    SL=0.6106*Feachers(:,6);
    disp(sum(SL));
%     FeaMean=mean(Feachers);
%     Fea(i).Feas=Feachers;
%     Fea(i).FeaM=FeaMean;
% end

% % Length=load('B:\data_PDR\Train\TrainLength.txt');
% Length=[47.02,45.33,46.17,45.75,50.24,49.80,50.07,49.50];
% SLMean=Length./60;
% 
% for i=1:length(Fea)
%     temp=Fea.FeaM;
%     FaLength(i,1)=temp(6);
% end
% 
% K=SLMean'./FaLength;
