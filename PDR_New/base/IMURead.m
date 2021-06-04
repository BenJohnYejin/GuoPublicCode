
%%
%  2020/6/28
%  Read data from txtfile collected with phone
%  txtfile format is [acc*3 gyr*3 mag*3]
%  the unit is  m/s^2  rad/s  uT
%  
%  @input  the path of IMUFile 
%  @output  acc the triaixs accleation 
%                  gyr the triaixs gyro 
%                  mag the triaixs mag

%%
function [acc,gyr,mag]=IMURead(IMUFile)
    %read a txt
    data=load(IMUFile);
%     data(1:3,:)=[];
    %get the vari
    acc=data(:,1:3);
    gyr=data(:,4:6);
    mag=data(:,7:9);

end
