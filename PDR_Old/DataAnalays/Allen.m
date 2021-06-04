%Allen·½²î·ÖÎö
clear;
data=load('B:\data_PDR\result\Allen1.txt');
% acc_data=data(:,1:3);
gyr_data=data(:,4:6); 
[sigma, tau, Err] = avar(gyr_data,0.05);