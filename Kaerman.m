function Acc_Kal = Kaerman(Acc,n) 


 X=Acc(1,1);
 P=1;
 F=1;
 Q=0.03;
 H=1;
 R=0.02;
 for i=1:n
    X_=F*X;
    P_=P+Q;
    K=P_*P+R;
    X=X_+K*(Acc(i,1)-X_);
    P=(1-K)*P_;
    Acc_Kal(i,1)=X;
 end

end