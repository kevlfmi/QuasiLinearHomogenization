function error=rel_error_slt(path,mode,iter1,iter2)
disp('computing error...')
%returns avg relative error between two iterations
if mode==1
    c1=load([path,'\uvc_slt_C_CA-iter',num2str(iter1),'.txt']);
    c2=load([path,'\uvc_slt_C_CA-iter',num2str(iter2),'.txt']);
elseif mode==2
    c1=load([path,'\uvc_slt_C_VA-iter',num2str(iter1),'.txt']);
    c2=load([path,'\uvc_slt_C_VA-iter',num2str(iter2),'.txt']);
else
    disp('ERROR, invalid mode');return;
end
c1(isnan(c1))=0; %remove NaN
c2(isnan(c2))=0;
c1=c1(:,5); %here only c: u,v are predicted by Stokes in just 1 iter
c2=c2(:,5);

error=2*abs(c1-c2)./abs(c1+c2); %relative error
error=1/length(error(:,1))*sum(error); %average

disp(['error=',num2str(error)])
end