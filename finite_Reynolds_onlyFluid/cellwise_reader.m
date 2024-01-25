function param_list=cellwise_reader(path,mode,epsilon,iter)
% read data taken on U, D lines sector by sector in the macro simulation

disp('reading sectors...')

U=[]; D=[];
if mode==1 %CA
    for i=1:1/epsilon
        fu=load([path,'\',num2str(i),'u_ca-it',num2str(iter),'.txt']);
        fd=load([path,'\',num2str(i),'d_ca-it',num2str(iter),'.txt']);
        U=[U;fu];
        D=[D;fd];
    end
elseif mode==2 %VA
    for i=1:1/epsilon
        fu=load([path,'\',num2str(i),'u_va-it',num2str(iter),'.txt']);
        fd=load([path,'\',num2str(i),'d_va-it',num2str(iter),'.txt']);
        U=[U;fu];
        D=[D;fd];
    end
else
    disp('ERROR, invalid model')
end

param_list=[U(:,[2,4]),D(:,[2,4]),0.5*(U(:,[6,7])+D(:,[6,7]))]';
end