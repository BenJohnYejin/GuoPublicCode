clear;clc;
%%¶ÁÈ¡ÑµÁ·Êý¾Ý
% data=load('data.mat');
% train_data=data.train_data;
% test_data=data.test_data;
% SVM=data.SVM;
% DT=data.DT;
% y0=SVM.predictFcn(train_data);
% y1=DT.predictFcn(train_data);
% 
% num_in_class=[300,300,300,300];
% name_class=['1','2','3','4'];
% compute_confusion_matrix(y0,num_in_class,name_class);
% compute_confusion_matrix(y1,num_in_class,name_class);

y_ture=load("B:\DataForFinal\MachineLearning\y.txt");
y_ture(1)=[];
y_pred=load("B:\Code\PYTHON\y_pred0.txt");
confusion_matrix1(y_ture,y_pred-1);
% y_pred=load('B:\Code\PYTHON\ypridicts.txt');
% y_ture=load('D:\DataSet\DevicePose\MachineLearn\Test\y.txt');
% confusion_matrix1(y_ture,y_pred);
% C=confusionmat (y_ture,y_pred);
% confusionchart(C);
% plotconfusion(y_ture',y_pred','Lstm');
