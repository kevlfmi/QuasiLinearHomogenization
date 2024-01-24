function tensors_strings=string_writer_slt(path,mode,epsilon,iter)

disp('writing tensor strings...')

if mode==1
    f=load([path,'\TS_ca-it',num2str(iter),'.txt']);
elseif mode==2
    f=load([path,'\TS_va-it',num2str(iter),'.txt']);
else
    disp('ERROR, invalid model');return;
end

T=f(:,1);
S=f(:,2);

txt_T=[];txt_S=[];


for i=1:1/epsilon
    if i==1/epsilon %start
        str_T=strcat("(",num2str(T(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");
        str_S=strcat("(",num2str(S(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<=",num2str(i*epsilon),")");       
    else %until end
        str_T=strcat("(",num2str(T(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
        str_S=strcat("(",num2str(S(i)),")*(y>=",num2str((i-1)*epsilon),")*(y<",num2str(i*epsilon),")+");
    end
    txt_T=strcat(txt_T,str_T);
    txt_S=strcat(txt_S,str_S);
end
tensors_strings=[txt_T;txt_S]; %this is passed directly to the main
end