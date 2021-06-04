function [d,r,vr]=SSA(x1,L,I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -----------------------------------------------------------------                           
%    Author: Francisco Javier Alonso Sanchez    e-mail:fjas@unex.es
%    Departament of Electronics and Electromecanical Engineering
%    Industrial Engineering School
%    University of Extremadura
%    Badajoz
%    Spain
% -----------------------------------------------------------------
%
% SSA generates a trayectory matrix X from the original series x1
% by sliding a window of length L. The trayectory matrix is aproximated 
% using Singular Value Decomposition. The last step reconstructs
% the series from the aproximated trayectory matrix. The SSA applications
% include smoothing, filtering, and trend extraction.
% The algorithm used is described in detail in: Golyandina, N., Nekrutkin, 
% V., Zhigljavsky, A., 2001. Analisys of Time Series Structure - SSA and 
% Related Techniques. Chapman & Hall/CR.

% x1 Original time series (column vector form)
% L  Window length
% y  Reconstructed time series 重构时间序列
% r  Residual time series r=x1-y 剩余时间序列
% vr Relative value of the norm of the approximated trajectory matrix with respect
%	  to the original trajectory matrix 相对于原始轨迹矩阵的近似轨道矩阵范数的相对值

% The program output is the Singular Spectrum of x1 (must be a column vector),
% using a window length L. You must choose the components be used to reconstruct 
%the series in the form [i1,i2:ik,...,iL], based on the Singular Spectrum appearance.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step1 : Build trayectory matrix
    N=length(x1); 
   if  L>N/2
       L=N-L;
   end
    K=N-L+1;    
    X=zeros(L,K);  
	for i=1:K
	  X(1:L,i)=x1(i:L+i-1); 
    end
   % Step 2: SVD奇异值分解
   S=X*X'; 
   %eig返回矩阵的特征值和特征向量，U是特征向量，autoval是特征值
    [U,autoval]=eig(S);
    %x= diag(v,k)以向量v的元素作为矩阵X的第k条对角线元素
    %当k=0时，v为X的主对角线；
    %当k>0时，v为上方第k条对角线；
    %当k<0时，v为下方第k条对角线。
    %sort(A，dim)表示对A中的各行元素升序排列
    %sort(A)默认的是升序，d是排序好的向量，i是向量d中每一项对应于A中项的索引
	[d,i]=sort(-diag(autoval));
    
    d=-d;
    U=U(:,i);
    sev=sum(d); %特征值的和
%    figure;
% 	plot((d./sev)*100),hold on,plot((d./sev)*100,'rx');
% 	title('Singular Spectrum');xlabel('Eigenvalue Number');ylabel('Eigenvalue (% Norm of trajectory matrix retained)')  %轨迹矩阵的范数
    V=(X')*U; 
    %奇异值分解S=U*D*V
    % Step 3: Grouping
    Vt=V';
    rca=U(:,I)*Vt(I,:);

% Step 4: Reconstruction

   y=zeros(N,1);  
   Lp=min(L,K);
   Kp=max(L,K);

   for k=0:Lp-2
     for m=1:k+1;
      y(k+1)=y(k+1)+(1/(k+1))*rca(m,k-m+2);
     end
   end

   for k=Lp-1:Kp-1
     for m=1:Lp;
      y(k+1)=y(k+1)+(1/(Lp))*rca(m,k-m+2);
     end
   end

   for k=Kp:N
      for m=k-Kp+2:N-Kp+1;
       y(k+1)=y(k+1)+(1/(N-k))*rca(m,k-m+2);
     end
   end

%    figure;subplot(2,1,1);hold on;xlabel('Data poit');ylabel('Original and reconstructed series')
%    plot(x1,'b');grid on;plot(y,'r')
% % plot(t,y)
   r=x1-y;
%    subplot(2,1,2);plot(r,'g');xlabel('Data poit');ylabel('Residual series');grid on
   vr=(sum(d(I))/sev)*100;
end