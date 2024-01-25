clear all;close all;clc;
set(0,'DefaultLineLineWidth',3);
set(0,'DefaultAxesFontSize',30);
set(0,'DefaultLineMarkerSize',25);
set(0,'DefaultContourLineWidth',1.5);
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex')
%------------------------
% read the final velocity on the membrane predicted by the Stokes, CA, VA
% and full-scale simulations

%------input files and parameters------------------
epsilon=0.1;

ca=load('uv_C_CA-iter3.txt');
va=load('uv_C_VA-iter3.txt');
sto=load('uv_C_VA-iter0.txt');
dns=load('fs_C.txt');

%------------------------------------------------
dns(isnan(dns))=0;
y=dns(:,2);
u=dns(:,3);
v=dns(:,4);

pos=0:epsilon:1;

for i=1:length(pos)-1   
    pos_slot=y(y>=pos(i) & y<pos(i+1));
    u_slot=u(y>=pos(i) & y<pos(i+1));
    v_slot=v(y>=pos(i) & y<pos(i+1));

    mean_y(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,pos_slot);
    mean_u(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,u_slot);
    mean_v(i)=1/(pos_slot(end)-pos_slot(1))*trapz(pos_slot,v_slot);
end

% plot

figure
subplot(1,2,1)
plot(mean_y,mean_u,'k.','DisplayName','Full Scale avg.');hold on
plot(sto(:,2),sto(:,end-1),'g-','DisplayName','Stokes');
plot(ca(:,2),ca(:,3),'b:','DisplayName','CA');
plot(va(:,2),va(:,3),'r-.','DisplayName','VA');
grid on;grid minor;xlabel('$x_2$','interpreter','latex');ylabel('$u_1$','interpreter','latex');legend('Location','best');

subplot(1,2,2)
plot(mean_y,mean_v,'k.','DisplayName','Full Scale avg.');hold on
plot(sto(:,2),sto(:,end),'g-','DisplayName','Stokes');
plot(ca(:,2),ca(:,4),'b:','DisplayName','CA');
plot(va(:,2),va(:,4),'r-.','DisplayName','VA');
grid on;grid minor;xlabel('$x_2$','interpreter','latex');ylabel('$u_2$','interpreter','latex');legend('Location','best');


saveas(gcf,'uv.fig');


