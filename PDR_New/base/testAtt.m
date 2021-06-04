function [avp,Acc] = testAtt(imu, mag, ahrs)
    if ~exist('mag', 'var'), mag = []; end
    if isempty(mag), mag=imu(:,1:3)*0; end
    ts=0.02;
    
    len=length(imu);
    avp = zeros(len, 17);
    Acc=zeros(len,3);

    for k=1:len
        ahrs = AttForward(ahrs, imu(k,:), mag(k,:)', ts);
        avp(k,:) = [m2att(ahrs.Cnb); ahrs.kf.xk(5:7); diag(ahrs.kf.Pxk); diag(ahrs.kf.Rk); ahrs.tk];
        Acc(k,:) = (ahrs.Cnb*imu(k,4:6)')';
    end
    
end
