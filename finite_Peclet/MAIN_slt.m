%**************************************************************************
% K. Wittkowski, A. Ponte, P.G. Ledda and G.A. Zampogna
% Quasi-linear homogenization for large-inertia laminar transport 
% across permeable membranes, 2024
% LFMI, EPF Lausanne
% DICCA, Università di Genova
% DICAAR, Università di Cagliari
%**************************************************************************
% Main script for the cases at ReL=0, PeL finite
% It can run macroscopic cases with Stokes (iteration zero), constant adv
% (mode=1) and variable adv (mode=2) models. Please refer to "FS.mph" for
% the corresponding full scale simulation and use results_reader.m to plot
% the values of u,v,c on the membrane.

clear all;close all;clc;
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultAxesFontSize',22);
set(0,'DefaultLineMarkerSize',15);
set(0,'DefaultContourLineWidth',1.5);
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
set(0,'defaulttextInterpreter','latex')

%**************************** MAIN ****************************************
PeL=1000; %Péclet number
epsilon=0.1; %scale separation parameter

maxiter=10; %max number of iterations
threshold=0.01; % threshold on the mean error for convergence
path=pwd; %work in the current directory

% MODE 1=constant advection, 2=variable advection
mode=2;

%--------------------------------------------------------------------------
%initialize
error=1; 
iter=0;

%run stokes case
if mode==1
    out_micro=micro_slt_CA(path,[0;0;0;0;0;0],PeL,epsilon,iter);
elseif mode==2
    out_micro=micro_slt_VA(path,[0;0;0;0;0;0],PeL,epsilon,iter);
else
    disp('ERROR, invalid model');
end
tensors=string_writer_slt(path,mode,epsilon,iter); 

tic
while error>=threshold && iter<=maxiter
    % outer problem
    out_macro=macro_slt(path,mode,tensors,epsilon,PeL,iter); %RUN MACRO
    iter=iter+1;
    if iter>1
        error=rel_error_slt(path,mode,iter-1,iter-2);
        if error<=threshold
            break;
        end
    end
    % inner problem
    param_list=[];tensors=[];% clear sigma list and tensor strings
    param_list=cellwise_reader_slt(path,mode,epsilon,iter-1); %READ STRESSES FROM MACRO SECTORWISE
    if mode==1
        out_micro = micro_slt_CA(path,param_list,PeL,epsilon,iter); 
    elseif mode==2
        out_micro = micro_slt_VA(path,param_list,PeL,epsilon,iter); 
    else
        disp('ERROR, invalid model')
    end
    
    tensors=string_writer_slt(path,mode,epsilon,iter);
end
toc