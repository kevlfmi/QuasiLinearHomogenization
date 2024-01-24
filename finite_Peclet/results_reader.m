clear all;close all;clc;
set(0,'DefaultLineLineWidth',3);
set(0,'DefaultAxesFontSize',30);
set(0,'DefaultLineMarkerSize',25);
set(0,'DefaultContourLineWidth',1.5);
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex')
%-------------------parameters---------------------------------------------
epsilon=0.1;
%------file input----------------------------------------------------------

ca=load('uvc_slt_C_CA-iter2.txt');
va=load('uvc_slt_C_VA-iter2.txt');
sto=load('uvc_slt_C_CA-iter0.txt');
fs=load('dns_C.txt');
%------average FS on the membrane------------------------------------------
fs(isnan(fs))=0;
y=fs(:,2);
u=fs(:,3);
v=fs(:,4);
p=fs(:,6);

pos=0:epsilon:1;

for i=1:length(pos)-1   
    pos_slot=y(y>=pos(i) & y<pos(i+1));
    u_slot=u(y>=pos(i) & y<pos(i+1));
    v_slot=v(y>=pos(i) & y<pos(i+1));
    p_slot=p(y>=pos(i) & y<pos(i+1));

    mean_y(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,pos_slot);
    mean_u(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,u_slot);
    mean_v(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,v_slot);
    mean_p(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,p_slot);
end
%//////////////////////////////////////////////////////////////////////////
figure %u
plot(mean_y,mean_u,'k .','DisplayName','Full Scale avg.');hold on;
plot(sto(:,2),sto(:,3),'g-','DisplayName','Stokes');
plot(ca(:,2),ca(:,3),'b:','DisplayName','CA');
plot(va(:,2),va(:,3),'r-.','DisplayName','VA');
grid on;grid minor;xlabel('$x_2$');ylabel('$u_1$');legend('location','best')
%ylim([0 1.3])
set(gcf,'Position',[10,10,800,700])

saveas(gcf,'u.fig');

%//////////////////////////////////////////////////////////////////////////
figure %v
plot(mean_y,mean_v,'k .','DisplayName','Full Scale avg.');hold on;
plot(sto(:,2),sto(:,4),'g-','DisplayName','Stokes');
plot(ca(:,2),ca(:,4),'b:','DisplayName','CA');
plot(va(:,2),va(:,4),'r-.','DisplayName','VA');
grid on;grid minor;xlabel('$x_2$');ylabel('$u_2$');legend('location','best')
%ylim([-0.2 0.7])
set(gcf,'Position',[10,10,800,700])

saveas(gcf,'v.fig');

%//////////////////////////////////////////////////////////////////////////
figure %c
plot(mean_y,mean_p,'k .','DisplayName','Full Scale avg.');hold on;
plot(sto(:,2),sto(:,5),'g-','DisplayName','Stokes');
plot(ca(:,2),ca(:,5),'b:','DisplayName','CA');
plot(va(:,2),va(:,5),'r-.','DisplayName','VA');
grid on;grid minor;xlabel('$x_2$');ylabel('$c$');legend('location','best')
ylim([0.15 0.5])
set(gcf,'Position',[10,10,800,700])

saveas(gcf,'c.fig');


