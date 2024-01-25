%**************************************************************************
% K. Wittkowski, A. Ponte, P.G. Ledda and G.A. Zampogna
% Quasi-linear homogenization for large-inertia laminar transport 
% across permeable membranes, 2024
% LFMI, EPF Lausanne
% DICCA, Università di Genova
% DICAAR, Università di Cagliari
%**************************************************************************
% Main script for the cases at finite ReL, only fluid flow.
% It can run macroscopic cases with Stokes (iteration zero), constant adv
% (mode=1) and variable adv (mode=2) models. Please refer to "FS.mph" for
% the corresponding full scale simulation and use reader.m to plot
% the values of u,v,c on the membrane.

clear all;close all;clc;
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultAxesFontSize',22);
set(0,'DefaultLineMarkerSize',15);
set(0,'DefaultContourLineWidth',1.5);
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex')

%**************************** MAIN only Fluid *****************************
ReL=400;
alfa=75;
epsilon=0.1;

maxiter=10;
threshold=0.01;
path=pwd;

% MODE 1=constant advection, 2=variable advection
mode=1;

%--------------------------------------------------------------------------
%initialize
error=1; 
iter=0;

%run stokes case
if mode==1
    out_micro=micro_CA(path,[0;0;0;0;0;0],ReL,epsilon,iter);
elseif mode==2
    out_micro=micro_VA(path,[0;0;0;0;0;0],ReL,epsilon,iter);
else
    disp('ERROR, invalid model');
end
tensors=string_writer(path,mode,epsilon,iter); 

tic
while error>=threshold && iter<=maxiter
    % outer problem
    out_macro=macro(path,mode,tensors,epsilon,ReL,alfa,iter); %RUN MACRO
    iter=iter+1;
    if iter>1
        error=rel_error(path,mode,iter-1,iter-2);
        if error<=threshold
            break;
        end
    end
    % inner problem
    param_list=[];tensors=[];% clear sigma list and tensor strings
    param_list=cellwise_reader(path,mode,epsilon,iter-1); %READ STRESSES FROM MACRO SECTORWISE
    if mode==1
        out_micro = micro_CA(path,param_list,ReL,epsilon,iter); 
    elseif mode==2
        out_micro = micro_VA(path,param_list,ReL,epsilon,iter); 
    else
        disp('ERROR, invalid model')
    end
    
    tensors=string_writer(path,mode,epsilon,iter);
end
toc