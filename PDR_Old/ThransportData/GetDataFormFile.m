%定时器执行函数
%Fig为图形句柄
%filename为文件名
function GetDataFormFile(hObject,eventdata,filename,Fig)
    %获取传入的数据并绘制图像
    %尝试获取数据
    for i=1:3
    try 
        temp=load(filename);
        break;
    catch
        pase(1);
    end
    end
    hObject.UserData=temp;
    Count=size(temp,1);
    %获取所有的线
    lh = findall(Fig, 'type', 'line');
    X=get(lh,'XData');
    Y=get(lh,'YData');
    
    for i=1:length(X)
        XL=X{i};
        XL=[XL,XL+1:XL+Count];
        YL=Y{i};
        YL=[YL,temp];
        X{i}=XL;
        Y{i}=YL;
    end
    set(Fig,'XData',X,'YData',Y);
    drawnow;
    
end
