function [] = Nc2Dat(inputName,outputName)
    fid=fopen(outputName,'wt+');
    ncinfo(inputName);
    lon=ncread(inputName,'longitude');
    lat=ncread(inputName,'latitude');
    time=ncread(inputName,'time');
    sp=ncread(inputName,'sp');
    tp=ncread(inputName,'tp');

    N1=length(lon);
    N2=length(lat);
    N=length(time);
    num=0;
    for i=1:1:N1
      for j=1:1:N2
        for k=1:1:N
    %         if isnan(TP(i,j,k))
    %     continue;
    % else
    % %  if((115.0042<=lon(i)&lon(i)<=118.0042) & (29.0042<=lat(j)&lat(j)<=31.0042))
        num=num+1;
    %     TP(i,j,k)=0;
        fprintf(fid,'%11.1f %11.1f %11.0f   %11.8f   %11.8f\n',lon(i),lat(j),time(k),sp(i,j,k),tp(i,j,k));
          end
      end
    end
    %     end
    % end
    fclose(fid);
    
end

