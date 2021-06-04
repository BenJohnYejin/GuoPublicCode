
%%
%  2020/6/28
%  Phone Motion Recongize
%  @input   Acc:  triaixs acc
%                StepPoint:  the detecte step time 
%  @output  Mode:  the different phone motion 
%                 1->text  2->call  3->swing  4->pocket         
%

function [Position,Scale,Motion]=PhoneMotionRecon(Acc,StepPoint)
    % the count of step 
    Length=size(StepPoint,1);
    Motion=zeros(size(Acc,1),1);
    Scale=zeros(Length,3);
    Position=zeros(Length,1);
    
    %the begin of walk
    Start=StepPoint(1);
    [Position(1),Scale(1,:),Motion(1:Start)]=GetPhoneMotion(Acc(1:Start,:));
    
    %the middle of walk 
    for i=2:Length
        Start=StepPoint(i-1);
        End=StepPoint(i);
        tmp=Acc(Start:End,:);
        [Position(i),Scale(i,:),Motion(Start:End)]=GetPhoneMotion(tmp);
    end

    %the end of walk
    tmp=Acc(End:end,:);
    [Position(end),Scale(end,:),Motion(End:end)]=GetPhoneMotion(tmp);
    
end


%%
%
%
function [Position,Kscale,Motion]=GetPhoneMotion(Acc)
    %
    Length=size(Acc,1);
    
    %对Acc进行求取模值
    G=(Acc(:,1).^2+Acc(:,2).^2+Acc(:,3).^2).^0.5;
    Kscale=mean(Acc./G);
    
    
    Thr=0.4;
    %发信息
    if abs(Kscale(1)-0.0)<Thr  && abs(Kscale(2)-0.10)<Thr && abs(Kscale(3)-0.8)<Thr
        Position=1; 
    %打电话
    elseif abs(Kscale(1)-0.6)<Thr  && abs(Kscale(2)+0.7)<Thr  &&  abs(Kscale(3)-0.0)<Thr
        Position=2;
    %摆臂    
    elseif abs(Kscale(1)+0.7)<Thr  &&  abs(Kscale(2)-0.4)<Thr &&  abs(Kscale(3)+0.6)<Thr
        Position=3;
    %口袋    
    elseif  abs(Kscale(1)-0.9)<Thr   &&  abs(Kscale(2)+0.1)<Thr &&  abs(Kscale(3)+0.1)<Thr
        Position=4;         
    else
        Position=0; 
    end
    
   Motion=Position*ones(Length,1);


end
