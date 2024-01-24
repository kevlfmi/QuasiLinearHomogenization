function param_list=cellwise_reader_slt(path,mode,epsilon,iter)
% read data taken on U, D lines sector by sector in the DNS

disp('reading sectors...')

U=[]; D=[];
if mode==1 %CA
    for i=1:1/epsilon
        fu=load([path,'\',num2str(i),'u_slt_ca-it',num2str(iter),'.txt']);
        fd=load([path,'\',num2str(i),'d_slt_ca-it',num2str(iter),'.txt']);
        U=[U;fu];
        D=[D;fd];
    end
elseif mode==2 %VA
    for i=1:1/epsilon
        fu=load([path,'\',num2str(i),'u_slt_va-it',num2str(iter),'.txt']);
        fd=load([path,'\',num2str(i),'d_slt_va-it',num2str(iter),'.txt']);
        U=[U;fu];
        D=[D;fd];
    end
else
    disp('ERROR, invalid model')
end

param_list=[U(:,[1,3]),D(:,[1,3]),0.5*(U(:,[5,6])+D(:,[5,6]))]';
end