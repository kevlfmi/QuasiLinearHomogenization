function tensors_strings=string_writer(path,mode,epsilon,iter)
% write strings of M_ij,N_ij interpretable in the macroscopic simulation
disp('writing tensor strings...')

if mode==1
    f=load([path,'\MN_ca-it',num2str(iter),'.txt']);
elseif mode==2
    f=load([path,'\MN_va-it',num2str(iter),'.txt']);
else
    disp('ERROR, invalid model');return;
end

Mnn=f(:,1);
Mnt=f(:,2);
Mtn=f(:,3);
Mtt=f(:,4);
Nnn=f(:,5);
Nnt=f(:,6);
Ntn=f(:,7);
Ntt=f(:,8);

txt_Mnn=[];txt_Mnt=[];txt_Mtn=[];txt_Mtt=[];
txt_Nnn=[];txt_Nnt=[];txt_Ntn=[];txt_Ntt=[];

for i=1:1/epsilon
    if i==1/epsilon %start
        str_Mnn=strcat("(",num2str(Mnn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Mnt=strcat("(",num2str(Mnt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Mtn=strcat("(",num2str(Mtn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Mtt=strcat("(",num2str(Mtt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Nnn=strcat("(",num2str(Nnn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Nnt=strcat("(",num2str(Nnt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Ntn=strcat("(",num2str(Ntn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_Ntt=strcat("(",num2str(Ntt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        
        
    else %until end
        str_Mnn=strcat("(",num2str(Mnn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Mnt=strcat("(",num2str(Mnt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Mtn=strcat("(",num2str(Mtn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Mtt=strcat("(",num2str(Mtt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Nnn=strcat("(",num2str(Nnn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Nnt=strcat("(",num2str(Nnt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Ntn=strcat("(",num2str(Ntn(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_Ntt=strcat("(",num2str(Ntt(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
    end
    
    txt_Mnn=strcat(txt_Mnn,str_Mnn);
    txt_Mnt=strcat(txt_Mnt,str_Mnt);
    txt_Mtn=strcat(txt_Mtn,str_Mtn);
    txt_Mtt=strcat(txt_Mtt,str_Mtt);
    txt_Nnn=strcat(txt_Nnn,str_Nnn);
    txt_Nnt=strcat(txt_Nnt,str_Nnt);
    txt_Ntn=strcat(txt_Ntn,str_Ntn);
    txt_Ntt=strcat(txt_Ntt,str_Ntt);
end
tensors_strings=[txt_Mnn;txt_Mnt;txt_Mtn;txt_Mtt;txt_Nnn;txt_Nnt;txt_Ntn;txt_Ntt]; %this is passed directly to the main, without reading the txt
end