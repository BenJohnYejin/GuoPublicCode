function [x2,y2]=zuobiao(S,a,x,y)
% a=a*180/pi;
x2=x+S*cos(a);
y2=y-S*sin(a);
end