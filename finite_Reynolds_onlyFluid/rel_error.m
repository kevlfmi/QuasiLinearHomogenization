function error=rel_error(path,mode,iter1,iter2)
disp('computing error...')
% returns the average relative error on velocity magnitude on the membrane
% between two iterations
if mode==1
    uvp1=load([path,'\uv_C_CA-iter',num2str(iter1),'.txt']);
    uvp2=load([path,'\uv_C_CA-iter',num2str(iter2),'.txt']);
elseif mode==2
    uvp1=load([path,'\uv_C_VA-iter',num2str(iter1),'.txt']);
    uvp2=load([path,'\uv_C_VA-iter',num2str(iter2),'.txt']);
else
    disp('ERROR, invalid mode');return;
end
uvp1(isnan(uvp1))=0; %remove NaN
uvp2(isnan(uvp2))=0;
uvp1=uvp1(:,[3,4]); %only u,v
uvp2=uvp2(:,[3,4]);

vel_magn1=sqrt(uvp1(:,1).^2+uvp1(:,2).^2); %magnitude
vel_magn2=sqrt(uvp2(:,1).^2+uvp2(:,2).^2);

error=2*abs(vel_magn1-vel_magn2)./abs(vel_magn1+vel_magn2); %relative error
error=1/length(error(:,1))*sum(error); %average

disp(['error=',num2str(error)])
end