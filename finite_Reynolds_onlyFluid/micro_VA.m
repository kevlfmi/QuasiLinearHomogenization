function out = micro_VA(path,param_list,ReL,epsilon,iter)
% solve the microscopic problem with the variable advection (VA) approach
% param_list has 6 rows, sigma nn tn U, then D then u,v, and N columns, format double;

for z=1:length(param_list(1,:))

disp(['solving micro VA... cell=',num2str(z),' iter=',num2str(iter)])

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(path);
ModelUtil.showProgress(true); %to show progress
model.label(['micro_VA-',num2str(iter),'.mph']);

model.param.set('s_U_nn', num2str(param_list(1,z)));
model.param.set('s_U_tn', num2str(param_list(2,z)));
model.param.set('s_D_nn', num2str(param_list(3,z)));
model.param.set('s_D_tn', num2str(param_list(4,z)));
model.param.set('por', '0.7');
model.param.set('K', '4');
model.param.set('epsilon', num2str(epsilon));
model.param.set('ReL', num2str(ReL));
model.param.set('delta', '0.01');
model.param.set('Uratio', '1');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').baseSystem('none');

model.result.table.create('tbl1', 'Table');
model.result.table.create('tbl2', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').feature('r1').set('size', {'2*K' '1'});
model.component('comp1').geom('geom1').create('e1', 'Ellipse');
model.component('comp1').geom('geom1').feature('e1').set('semiaxes', {'(1-por)/2' '(1-por)/2'});
model.component('comp1').geom('geom1').create('ls1', 'LineSegment');
model.component('comp1').geom('geom1').feature('ls1').set('specify1', 'coord');
model.component('comp1').geom('geom1').feature('ls1').set('coord1', [0 -0.5]);
model.component('comp1').geom('geom1').feature('ls1').set('specify2', 'coord');
model.component('comp1').geom('geom1').feature('ls1').set('coord2', [0 0.5]);
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('base', 'center');
model.component('comp1').geom('geom1').feature('r2').set('size', {'delta' '1'});
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'ls1' 'r1' 'r2'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'e1'});
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').physics.create('w', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w').field('dimensionless').field('Qn');
model.component('comp1').physics('w').field('dimensionless').component({'Qn'});
model.component('comp1').physics.create('w2', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w2').field('dimensionless').field('M_n');
model.component('comp1').physics('w2').field('dimensionless').component({'Mnn' 'Mtn'});
model.component('comp1').physics('w2').create('pc1', 'PeriodicCondition', 1);
model.component('comp1').physics('w2').feature('pc1').selection.set([2 3 5 7 9 11 13 15]);
model.component('comp1').physics('w2').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w2').feature('dir1').selection.set([17 18 19 20 21 22 23 24]);
model.component('comp1').physics('w2').create('src1', 'SourceTerm', 2);
model.component('comp1').physics('w2').feature('src1').selection.set([2 3 4 5]);
model.component('comp1').physics.create('w3', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w3').field('dimensionless').field('Qt');
model.component('comp1').physics('w3').field('dimensionless').component({'Qt'});
model.component('comp1').physics.create('w4', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w4').field('dimensionless').field('M_t');
model.component('comp1').physics('w4').field('dimensionless').component({'Mnt' 'Mtt'});
model.component('comp1').physics('w4').create('pc1', 'PeriodicCondition', 1);
model.component('comp1').physics('w4').feature('pc1').selection.set([2 3 5 7 9 11 13 15]);
model.component('comp1').physics('w4').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w4').feature('dir1').selection.set([17 18 19 20 21 22 23 24]);
model.component('comp1').physics('w4').create('src1', 'SourceTerm', 2);
model.component('comp1').physics('w4').feature('src1').selection.set([2 3 4 5]);
model.component('comp1').physics.create('w9', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w9').identifier('w9');
model.component('comp1').physics('w9').field('dimensionless').field('Rn');
model.component('comp1').physics('w9').field('dimensionless').component({'Rn'});
model.component('comp1').physics.create('w10', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w10').identifier('w10');
model.component('comp1').physics('w10').field('dimensionless').field('N_n');
model.component('comp1').physics('w10').field('dimensionless').component({'Nnn' 'Ntn'});
model.component('comp1').physics('w10').create('pc1', 'PeriodicCondition', 1);
model.component('comp1').physics('w10').feature('pc1').selection.set([2 3 5 7 9 11 13 15]);
model.component('comp1').physics('w10').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w10').feature('dir1').selection.set([17 18 19 20 21 22 23 24]);
model.component('comp1').physics('w10').create('src1', 'SourceTerm', 2);
model.component('comp1').physics('w10').feature('src1').selection.set([2 3 4 5]);
model.component('comp1').physics.create('w11', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w11').identifier('w11');
model.component('comp1').physics('w11').field('dimensionless').field('Rt');
model.component('comp1').physics('w11').field('dimensionless').component({'Rt'});
model.component('comp1').physics.create('w12', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w12').identifier('w12');
model.component('comp1').physics('w12').field('dimensionless').field('N_t');
model.component('comp1').physics('w12').field('dimensionless').component({'Nnt' 'Ntt'});
model.component('comp1').physics('w12').create('pc1', 'PeriodicCondition', 1);
model.component('comp1').physics('w12').feature('pc1').selection.set([2 3 5 7 9 11 13 15]);
model.component('comp1').physics('w12').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w12').feature('dir1').selection.set([17 18 19 20 21 22 23 24]);
model.component('comp1').physics('w12').create('src1', 'SourceTerm', 2);
model.component('comp1').physics('w12').feature('src1').selection.set([2 3 4 5]);

model.component('comp1').mesh('mesh1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').create('size2', 'Size');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').feature('size1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('size1').selection.set([2 3 4 5]);
model.component('comp1').mesh('mesh1').feature('size2').selection.geom('geom1', 1);
model.component('comp1').mesh('mesh1').feature('size2').selection.set([17 18 19 20 21 22 23 24]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp', 'BndLayerProp');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.set([17 18 19 20 21 22 23 24]);

model.result.table('tbl1').comments('U');
model.result.table('tbl2').comments('D');

model.component('comp1').physics('w').label('div Mnn Mtn / Qn');
model.component('comp1').physics('w').prop('ShapeProperty').set('order', 1);
model.component('comp1').physics('w').feature('wfeq1').set('weak', '- test(Qn)*(Mnnx)-test(Qn)*(Mtny)+Qn*test(Qn)*1e-6*0');
model.component('comp1').physics('w2').label('momentum Mnn Mtn / Qn');
model.component('comp1').physics('w2').feature('wfeq1').set('weak', {'epsilon*ReL*d(Mnn,t)*test(Mnn)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Mnnx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Mnny)*test(Mnn)+(Mnnx*test(Mnnx) + Mnny*test(Mnny))-Qn*test(Mnnx)'; 'epsilon*ReL*d(Mtn,t)*test(Mtn)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Mtnx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Mtny)*test(Mtn)+(Mtnx*test(Mtnx) + Mtny*test(Mtny))-Qn*test(Mtny)'});
model.component('comp1').physics('w2').feature('dir1').label('no slip');
model.component('comp1').physics('w2').feature('src1').set('f', {'-1/delta'; '0'});
model.component('comp1').physics('w2').feature('src1').label('dirac');
model.component('comp1').physics('w3').label('div Mnt Mtt / Qt');
model.component('comp1').physics('w3').prop('ShapeProperty').set('order', 1);
model.component('comp1').physics('w3').feature('wfeq1').set('weak', '- test(Qt)*(Mntx)-test(Qt)*(Mtty)+Qt*test(Qt)*1e-6*0');
model.component('comp1').physics('w4').label('momentum Mnt Mtt / Qt');
model.component('comp1').physics('w4').feature('wfeq1').set('weak', {'epsilon*ReL*d(Mnt,t)*test(Mnt)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Mntx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Mnty)*test(Mnt)+(Mntx*test(Mntx) + Mnty*test(Mnty))-Qt*test(Mntx)'; 'epsilon*ReL*d(Mtt,t)*test(Mtt)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Mttx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Mtty)*test(Mtt)+(Mttx*test(Mttx) + Mtty*test(Mtty))-Qt*test(Mtty)'});
model.component('comp1').physics('w4').feature('dir1').label('no slip');
model.component('comp1').physics('w4').feature('src1').set('f', {'0'; '-1/delta'});
model.component('comp1').physics('w4').feature('src1').label('dirac');
model.component('comp1').physics('w9').label('div Nnn Ntn / Rn');
model.component('comp1').physics('w9').prop('ShapeProperty').set('order', 1);
model.component('comp1').physics('w9').feature('wfeq1').set('weak', '- test(Rn)*(Nnnx)-test(Rn)*(Ntny)+Rn*test(Rn)*1e-6*0');
model.component('comp1').physics('w10').label('momentum Nnn Ntn / Rn');
model.component('comp1').physics('w10').feature('wfeq1').set('weak', {'epsilon*ReL*d(Nnn,t)*test(Nnn)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Nnnx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Nnny)*test(Nnn)+(Nnnx*test(Nnnx) + Nnny*test(Nnny))-Rn*test(Nnnx)'; 'epsilon*ReL*d(Ntn,t)*test(Ntn)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Ntnx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Ntny)*test(Ntn)+(Ntnx*test(Ntnx) + Ntny*test(Ntny))-Rn*test(Ntny)'});
model.component('comp1').physics('w10').feature('dir1').label('no slip');
model.component('comp1').physics('w10').feature('src1').set('f', {'1/delta'; '0'});
model.component('comp1').physics('w10').feature('src1').label('dirac');
model.component('comp1').physics('w11').label('div Nnt Ntt / Rt');
model.component('comp1').physics('w11').prop('ShapeProperty').set('order', 1);
model.component('comp1').physics('w11').feature('wfeq1').set('weak', '- test(Rt)*(Nntx)-test(Rt)*(Ntty)+Rt*test(Rt)*1e-6*0');
model.component('comp1').physics('w12').label('momentum Nnt Ntt / Rt');
model.component('comp1').physics('w12').feature('wfeq1').set('weak', {'epsilon*ReL*d(Nnt,t)*test(Nnt)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Nntx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Nnty)*test(Nnt)+(Nntx*test(Nntx) + Nnty*test(Nnty))-Rt*test(Nntx)'; 'epsilon*ReL*d(Ntt,t)*test(Ntt)+epsilon^2*ReL^2*Uratio*((Mnn*s_U_nn+Mnt*s_U_tn+Nnn*s_D_nn+Nnt*s_D_tn)*Nttx+(Mtn*s_U_nn+Mtt*s_U_tn+Ntn*s_D_nn+Ntt*s_D_tn)*Ntty)*test(Ntt)+(Nttx*test(Nttx) + Ntty*test(Ntty))-Rt*test(Ntty)'});
model.component('comp1').physics('w12').feature('dir1').label('no slip');
model.component('comp1').physics('w12').feature('src1').set('f', {'0'; '1/delta'});
model.component('comp1').physics('w12').feature('src1').label('dirac');

model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', '10*delta');
model.component('comp1').mesh('mesh1').feature('size').set('hmin', 0.002);
model.component('comp1').mesh('mesh1').feature('size').set('hgrad', 1.15);
model.component('comp1').mesh('mesh1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size1').set('hmax', 'delta');
model.component('comp1').mesh('mesh1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hmin', 0.003);
model.component('comp1').mesh('mesh1').feature('size1').set('hminactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size2').set('hmax', 'delta*2');
model.component('comp1').mesh('mesh1').feature('size2').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hmin', 0.003);
model.component('comp1').mesh('mesh1').feature('size2').set('hminactive', false);
model.component('comp1').mesh('mesh1').run;

model.study.create('std1');
model.study('std1').create('time', 'Transient');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.result.numerical.create('int1', 'IntLine');
model.result.numerical.create('int2', 'IntLine');
model.result.numerical('int1').selection.set([1]);
model.result.numerical('int1').set('probetag', 'none');
model.result.numerical('int2').selection.set([16]);
model.result.numerical('int2').set('probetag', 'none');

model.study('std1').feature('time').set('tlist', 'range(0,50,1000)');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Time Dependent');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('v1').set('clist', {'range(0,50,1000)' '1.0[s]'});
model.sol('sol1').feature('t1').label('Time-Dependent Solver 1.1');
model.sol('sol1').feature('t1').set('tlist', 'range(0,50,1000)');
model.sol('sol1').feature('t1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('t1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('t1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').runAll;

model.result.numerical('int1').label('U');
model.result.numerical('int1').set('looplevelinput', {'last'});
model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').set('expr', {'Mnn' 'Mnt' 'Mtn' 'Mtt'});
model.result.numerical('int1').set('unit', {'' '' '' ''});
model.result.numerical('int1').set('descr', {'Mnn' 'Mnt' 'Mtn' 'Mtt'});
model.result.numerical('int2').label('D');
model.result.numerical('int2').set('looplevelinput', {'last'});
model.result.numerical('int2').set('table', 'tbl2');
model.result.numerical('int2').set('expr', {'Nnn' 'Nnt' 'Ntn' 'Ntt'});
model.result.numerical('int2').set('unit', {'' '' '' ''});
model.result.numerical('int2').set('descr', {'Nnn' 'Nnt' 'Ntn' 'Ntt'});
model.result.numerical('int1').setResult;
model.result.numerical('int2').setResult;

model.result.table('tbl1').save([path,'\M_va-cell',num2str(z),'-it',num2str(iter),'.txt']);
model.result.table('tbl2').save([path,'\N_va-cell',num2str(z),'-it',num2str(iter),'.txt']);

out = model;
end
%put together all micro results
if length(param_list(1,:))==1
    M=load([path,'\M_va-cell',num2str(1),'-it',num2str(iter),'.txt']);
    N=load([path,'\N_va-cell',num2str(1),'-it',num2str(iter),'.txt']);
    MN=[M(2:end),N(2:end)].*ones([1/epsilon,8]);
    writematrix(MN,[path,'\MN_va-it',num2str(iter),'.txt']);
elseif length(param_list(1,:))==1/epsilon
    MN=[];
    for i=1:1/epsilon
        M(i,:)=load([path,'\M_va-cell',num2str(i),'-it',num2str(iter),'.txt']);
        N(i,:)=load([path,'\N_va-cell',num2str(i),'-it',num2str(iter),'.txt']);
        MN=[MN;[M(i,2:end),N(i,2:end)]];
    end
    writematrix(MN,[path,'\MN_va-it',num2str(iter),'.txt']);
else 
    disp('ERROR: parameter list is not of length 1 (Stokes) or 1/epsilon (CA/VA). No MN is written')
end