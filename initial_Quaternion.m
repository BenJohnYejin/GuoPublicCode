function[p1,p2,p3,p4,cbn]=initial_Quaternion(a,b,c)
%----------------航向角偏西为正------不可用----------------%
% p1=cos(c/2)*cos(b/2)*cos(a/2)-sin(c/2)*sin(b/2)*sin(a/2);
% p2=cos(c/2)*cos(b/2)*sin(a/2)-sin(c/2)*sin(b/2)*cos(a/2);
% p3=cos(c/2)*sin(b/2)*cos(a/2)+sin(c/2)*cos(b/2)*sin(a/2);
% p4=sin(c/2)*cos(b/2)*cos(a/2)+cos(c/2)*sin(b/2)*sin(a/2);
%----------------航向角偏东为正（修正）-不可用-------------%
% p1=cos(c/2)*cos(b/2)*cos(a/2)+sin(c/2)*sin(b/2)*sin(a/2);
% p2=cos(c/2)*cos(b/2)*sin(a/2)+sin(c/2)*sin(b/2)*cos(a/2);
% p3=cos(c/2)*sin(b/2)*cos(a/2)+sin(c/2)*cos(b/2)*sin(a/2);
% p4=-sin(c/2)*cos(b/2)*cos(a/2)+cos(c/2)*sin(b/2)*sin(a/2);
% a=a*pi/180;
% b=b*pi/180;
% c=c*pi/180;
%-------------姿态角计算矩阵--东正上正右正-n2b--zxy-----%
% cbn=[cos(a)*cos(c)+sin(a)*sin(b)*sin(c),cos(b)*sin(c),sin(a)*cos(c)-cos(a)*sin(b)*sin(c);
%     -cos(a)*sin(c)+sin(a)*sin(b)*cos(c),cos(b)*cos(c),-sin(a)*sin(c)-cos(a)*sin(b)*cos(c);
%     -sin(a)*cos(b),sin(b),cos(a)*cos(b)];
%-------------姿态角计算矩阵--西正上正右正-n2b--zxy-----%
cbn=[cos(a)*cos(c)-sin(a)*sin(b)*sin(c),-cos(b)*sin(c),sin(a)*cos(c)+cos(a)*sin(b)*sin(c);
    cos(a)*sin(c)+sin(a)*sin(b)*cos(c),cos(b)*cos(c),sin(a)*sin(c)-cos(a)*sin(b)*cos(c);
    -sin(a)*cos(b),sin(b),cos(a)*cos(b)];
%-------------姿态角计算矩阵--西正下正左正-n2b--zyx-----%
% cbn=[cos(c)*cos(b),cos(b)*sin(c),-sin(b);
% -sin(b)*sin(a)*cos(c)-cos(a)*sin(c),-sin(a)*sin(b)*sin(c)+cos(a)*cos(c),-sin(a)*cos(b);
% cos(a)*sin(b)*cos(c)-sin(a)*sin(c),cos(a)*sin(b)*sin(c)+sin(a)*cos(c),cos(a)*cos(b)
% ];
  C11 = cbn(1,1); C12 = cbn(1,2); C13 = cbn(1,3); 
    C21 = cbn(2,1); C22 = cbn(2,2); C23 = cbn(2,3); 
    C31 = cbn(3,1); C32 = cbn(3,2); C33 = cbn(3,3); 
    if C11>=C22+C33    
        p2 = 0.5*sqrt(1+C11-C22-C33);
        p1 = (C32-C23)/(4*p2); p3 = (C12+C21)/(4*p2); p4 = (C13+C31)/(4*p2);
    elseif C22>=C11+C33
        p3 = 0.5*sqrt(1-C11+C22-C33);
        p1 = (C13-C31)/(4*p3); p2 = (C12+C21)/(4*p3); p4 = (C23+C32)/(4*p3);
    elseif C33>=C11+C22
        p4 = 0.5*sqrt(1-C11-C22+C33);
        p1 = (C21-C12)/(4*p4); p2 = (C13+C31)/(4*p4); p3 = (C23+C32)/(4*p4);
    else
        p1 = 0.5*sqrt(1+C11+C22+C33);
        p2 = (C32-C23)/(4*p1); p3 = (C13-C31)/(4*p1); p4 = (C21-C12)/(4*p1);
    end;
end