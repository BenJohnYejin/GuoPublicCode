function [AttMag] = MainHeading(AttMag,DetAngle)

    Len=size(AttMag,1);

%     for j=1:Len
%         if (AttMag(j) <(0+pi/4) && AttMag(j) >(0-pi/4))     AttMag(j) =pi;
%         elseif (AttMag(j) <(pi/2+pi/4) && AttMag(j) >(pi/2-pi/4))    AttMag(j)=pi/2;
%         elseif (AttMag(j)<(-pi/2+pi/4) && AttMag(j)>(-pi/2-pi/4))   AttMag(j)=-pi/2;        
%         else   AttMag(j)=0; 
%         end
%     end
    MainHeadingCount=pi/DetAngle;
    for j=1:Len
        for k=1:MainHeadingCount
            if AttMag(j)<(k+0.5)*DetAngle && AttMag(j)>(k-0.5)*DetAngle
                AttMag(j)=DetAngle*k;
                break;
            elseif      AttMag(j)<(-k+0.5)*DetAngle && AttMag(j)<(-k-0.5)*DetAngle
                AttMag(j)=-DetAngle*k;
                break;
            else
                AttMag(j)=0;
            end           
        end
    end
end

