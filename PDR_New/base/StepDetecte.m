
%%
%  2020/6/28
%  Get the StepDetecte(TimePoint) form acc
%  
%  @input  the triaixs acc
%  @output  Step point(TimePoint)

%%
function [TimeDete,Acc,AccMo]=StepDetecte(acc,Fs)
    %Get the acc modulus value
    Temp=[acc(:,1).^2,acc(:,2).^2,acc(:,3).^2];
    AccMo=sum(Temp,2).^0.5;
    
    %Preprocess the acc modulus value with SSA
    Acc=Preprocess(AccMo);
%     Acc=Smooth(AccMo,3);
    %Get the Time of StepPoint
    [TimeDete]=GetStepPoint(Acc,Fs);

end

%%
%使用带有滑动窗口的SSA进行预处理
function [Out]=Preprocess(In)
    Length=size(In,1);
    Out=zeros(Length,1);
    %使用SSA分析获取步态相关信号
    if Length<100
        [~,r,~]=SSA(In,25,3);
        [~,r1,~]=SSA(In,25,4);
        Out=r1-r;
    else
        for i=101:50:Length
            %SSA分析需要一个固定的窗口
            [~,r,~]=SSA(In(i-100:i),25,3);
            [~,r1,~]=SSA(In(i-100:i),25,4);
            Out(i-100:i)=r1-r;
        end
        %对尾巴进行处理
        [~,r,~]=SSA(In(Length-100:Length),25,3);
        [~,r1,~]=SSA(In(Length-100:Length),25,4);
        Out(Length-100:Length)=r1-r;
    end
end

%%
%
function [x,y]=GetStepPoint(Acc,Fs)
    x=zeros(10,1);
    j=1;
    %StepCount 
    temp_y=Acc;
    x(j)=1;
    Length=size(temp_y,1);
    
    for i = 1:Length-16
        %划分窗口
        temp=temp_y(i:i+15);
        %找到峰值点
        %这一步的时间大于0.45
        if (max(temp)==temp_y(i) && i-x(j)>0.45*Fs && temp_y(i)>0.1 )
%         if (min(temp)==temp_y(i) && i-x(j)>0.45*Fs && temp_y(i)<-0.1 )
                x(j+1)=i;
                j=j+1;
        end
    end  

    x(1)=[];y=temp_y(x);
    
%     figure();hold on;
%     plot(temp_y);
%     plot(x,y,'rx');
end
