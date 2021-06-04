% clear;
% %  数据预处理
% %选择路径
% file_path=uigetdir('D:\DataSet\DevicePose\Raw','请选择文件夹');
% %获取该文件夹中test的数据
% path_list = dir(strcat(file_path,'\*.txt_train'));
% %获取个数
% num = length(path_list);
% %有满足条件的文件
% if num > 0 
%         %逐一读取文件
%         for j = 1:10
%             %获取名字
%             name = path_list(j).name;
%             PathName=strcat(file_path,'\',name);
%             %数据处理
% %             Fs=50;[Acc,Gyr,Mag]=IMURead(PathName);
%             Fs=50;Data=load(PathName);
%             Acc=Data(:,2:4);Gyr=Data(:,5:7);
%             [TimeDete,Acc1]=StepDetecte(Acc,Fs);
%             deal(Acc,Gyr,TimeDete,file_path,'train',1);
%         end
% end
% 
% 
% %%
% function  []=deal(Acc,Gyr,TimeDete,PathName,Type,Label)
%     Count=length(TimeDete);
%     
%     for j=1:Count-1
%         Begin=TimeDete(j);End=TimeDete(j+1);
%         Accx=Acc(Begin:End,1);Accy=Acc(Begin:End,2);Accz=Acc(Begin:End,3);
%         Gyrx=Gyr(Begin:End,1);Gyry=Gyr(Begin:End,2);Gyrz=Gyr(Begin:End,3);
%         
%         dlmwrite(strcat(PathName,'/Accx.txt_',Type),Accx','-append');
%         dlmwrite(strcat(PathName,'/Accy.txt_',Type),Accy','-append');
%         dlmwrite(strcat(PathName,'/Accz.txt_',Type),Accz','-append');
%         
%         dlmwrite(strcat(PathName,'/Gyrx.txt_',Type),Gyrx','-append');
%         dlmwrite(strcat(PathName,'/Gyry.txt_',Type),Gyry','-append');
%         dlmwrite(strcat(PathName,'/Gyrz.txt_',Type),Gyrz','-append');
%         
%     end
%     
%     ylabel=ones(Count-1,1)*Label;
%     dlmwrite(strcat(PathName,'/ylabel.txt_',Type),ylabel,'-append');
% end

% % 读取文件并保存到内存中
% % 首先读取ACC数据
% File_Name={'person1','person2','person3','person4','person5','person6','person7','person8'};
% File_Type={'Text','Call','Swing','Pocket'};
% %分类
% for j=1:8
%     for k=1:4
%     filename_accx=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\Accx.txt_test');
%     filename_accy=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\Accy.txt_test');
%     filename_accz=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\Accz.txt_test');
%     filename_gyrx=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\Gyrx.txt_test');
%     filename_gyry=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\Gyry.txt_test');
%     filename_gyrz=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\Gyrz.txt_test');
%     filename_y=strcat('D:\DataSet\DevicePose\Raw\',File_Name{j},'\',File_Type{k},'\ylabel.txt_test');
%     
%     FileWrite(filename_accx,'Accx.txt');
%     FileWrite(filename_accy,'Accy.txt');
%     FileWrite(filename_accz,'Accz.txt');
%     
%     FileWrite(filename_gyrx,'Gyrx.txt');
%     FileWrite(filename_gyry,'Gyry.txt');
%     FileWrite(filename_gyrz,'Gyrz.txt');
%     
%     FileWrite(filename_y,'ylabel.txt');
%     end
% end
% 
% function []=FileWrite(File,Type)
%     filename=strcat('D:\DataSet\DevicePose\MachineLearn\Test\',Type);
%     fileout=fopen(filename,'a');
% 
%     filein=fopen(File,'r');
%     line=fgets(filein);
%     Count=1;
%     while  (line~=-1)
%         fprintf(fileout,'%s',line);
%         line=fgets(filein);
%         Count=Count+1;
%     end
%     disp(File);disp(Count);
% %     fprintf(fileout,'%s',line);
%     
%     fclose(fileout);
%     fclose(filein);
% end


%补足数据 50  用-1进行补足
% FileTypeIn={'Accx_train.txt','Accy_train.txt','Accz_train.txt','Gyrx_train.txt','Gyry_train.txt','Gyrz_train.txt'};
FileTypeOut={'Accx_test.txt','Accy_test.txt','Accz_test.txt','Gyrx_test.txt','Gyry_test.txt','Gyrz_test.txt'};
FileTypeIn={'Accx.txt','Accy.txt','Accz.txt','Gyrx.txt','Gyry.txt','Gyrz.txt'};
for j=1:6
    FileNameIn=strcat('B:\DataForFinal\MachineLearning\',FileTypeIn{j});
    FileNameOut=strcat('B:\DataForFinal\MachineLearning\',FileTypeOut{j});
    IndexOut=Fill(FileNameIn,FileNameOut,50,-1);
    disp("Done");
end
% y=load('D:\DataSet\DevicePose\MachineLearn\Test\y_test.txt');
% y(IndexOut)=[];
% dlmwrite('D:\DataSet\DevicePose\MachineLearn\Test\y.txt',y,'-append');

function [IndexOut]=Fill(FileNameIn,FileNameOut,MAXCOUNT,NUMFILL)
    FileIn = fopen(FileNameIn,'r');
    tline = fgetl(FileIn);
    IndexOut=[];
    Index=0;
    while ischar(tline)
        Index=Index+1;
        NumLine=Cell2Num(split(tline,','));
        if length(NumLine)<MAXCOUNT
            NumLine(end:MAXCOUNT)=NUMFILL*ones(MAXCOUNT-length(NumLine)+1,1);
            dlmwrite(FileNameOut,NumLine','-append');
        else
            IndexOut=[IndexOut;Index];
        end
        
        tline = fgetl(FileIn);
    end
    fclose(FileIn);
end


function NumLine=Cell2Num(CellMat)
    NumLine=zeros(length(CellMat),1);
    for j=1:length(CellMat)
        NumLine(j)=str2double(CellMat{j});
    end
end