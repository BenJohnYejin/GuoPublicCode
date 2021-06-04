%% ACTIVATION - Implement activation functions


%% Format
% s=Activation(type,x,k)
%
%% Inputs
%
% type(1,:) Type 'sigmoid','tanh','rlo'
% x   (1,:) Input
% k   (1,1) Scale factor
%
%% Outputs
%
% s (1,:) Output
%
function s=Activation(type,x,k)
    if (nargin<1)
        Demo
        return
    end

    if  (nargin<3)
        k=1;
    end

    switch lower(type)
        case 'elo'
            j=x>0;
            s=zeros(1,length(x));
            s(j)=1;
        case 'tanh'
            s=tanh(k*x);
        case 'sigmoid'
            s=(1-exp(-k*x))./(1+exp(-k*x));
    end
end

function Demo

    x=linspace(-2,2);
    s=[ Activation('elo',x);...
         Activation('tanh',x);...
         Activation('sigmoid',x)];
 figure;
 plot(x,s);
 set(gca,'x_label','x','y_label','\sigma(x)',...
         'figure_title','Activation_Functions',...
         'legend',{{'ELO' 'tanh' 'Sigmoid'}},'plot_set',{1:3});
end