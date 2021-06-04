clc,clear;
filename="B://temp/temp.csv";
% %%服务器端读取手机传感器数据
% %使用java建立服务端服务器读取手机传输的数据
% SeverClient=Sever;
% %服务器端口号可以在setSERVERPORT()中进行设置
% SeverClient.run();
% %每隔5(5000ms)秒进行写操作 可以在setFileTime()方法中进行设置
% SeverClient.Write2File(filename);
% SeverClient.stop();
stop=0;
Data=load(filename);
Fig=plot(Data,'EraseMode','background','MarkerSize',5);
grid on;
while (1)
    if stop==1
        break;
    end
    
    for i=1:3
    try 
        Data=load(filename);
        break;
    catch
        pase(1);
    end
    end
    
    Count=size(Data,1);
    %获取所有的线
    Y=get(Fig,'YData');
    YL=[];
    for i=1:size(Y,1)
        YL=Y{i};
        YL=[YL,Data(:,i)'];
        Y{i}=YL;
    end
    set(Fig,'YData',Y{i});
    drawnow;
end
%%
%读取实时文件
%每隔5s尝试一次读数据，5秒内完成
%需要利用进行计时器进行读操作
%定时器，6秒后执行，间隔5秒
%数据存放于  hObject.UserData中
% xL=[0,1];yL=[0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0];
% Fig=plot(0,[0,0,0,0,0,0,0,0,0]);
% TimerReadData = timer('StartDelay',6,'TimerFcn',{@GetDataFormFile,filename,Fig},'Period',5,'ExecutionMode','fixedRate');
%开始定时器
% start(TimerReadData);
% %停止定时器
% stop(TimerReadData);
% %删除定时器
% delete(TimerReadData);
%%