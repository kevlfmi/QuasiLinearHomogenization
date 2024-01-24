function out = micro_slt_VA(path,param_list,PeL,epsilon,iter)
% param_list has 6 rows, sigma nn tn U, then D then u,v, and N columns, format double;
if iter>0
    % exclude extremes to enhance stability
    param_list=[param_list(:,2),param_list(:,2:end-1),param_list(:,end-1)];
end
for i=1:length(param_list(1,:))
disp(['solving micro slt VA... cell=',num2str(i),' iter=',num2str(iter)])
import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(path);

model.label(['micro_slt_VA-',num2str(iter),'.mph']);

model.baseSystem('none');

model.param.set('K', '4');
model.param.set('PeL', num2str(PeL));
model.param.set('delta', '0.01');
model.param.set('epsilon', num2str(epsilon));
model.param.set('S_U_nn', num2str(param_list(1,i)));
model.param.set('S_U_tn', num2str(param_list(2,i)));
model.param.set('S_D_nn', num2str(param_list(3,i)));
model.param.set('S_D_tn', num2str(param_list(4,i)));

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.result.table.create('tbl1', 'Table');
model.result.table.create('tbl2', 'Table');

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').feature('r1').set('size', {'2*K' '1'});
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('base', 'center');
model.component('comp1').geom('geom1').feature('r2').set('size', {'delta' '1'});
model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('c1').set('pos', [0 0]);
model.component('comp1').geom('geom1').feature('c1').set('r', 0.15);
model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'r1' 'r2'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'c1'});
model.component('comp1').geom('geom1').run;

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('Um', 'Mnn*S_U_nn+Mnt*S_U_tn-Mnn*S_D_nn-Mnt*S_D_tn', 'M=-N in stokes flow');
model.component('comp1').variable('var1').set('Vm', 'Mtn*S_U_nn+Mtt*S_U_tn-Mtn*S_D_nn-Mtt*S_D_tn', 'M=-N in stokes flow');

model.component('comp1').physics.create('spf', 'CreepingFlow', 'geom1');
model.component('comp1').physics('spf').field('velocity').field('Mn');
model.component('comp1').physics('spf').field('velocity').component({'Mnn' 'Mtn' 'Msn'});
model.component('comp1').physics('spf').field('pressure').field('Qn');
model.component('comp1').physics('spf').create('pfc1', 'PeriodicFlowCondition', 1);
model.component('comp1').physics('spf').feature('pfc1').selection.set([2 3 5 7 9 11]);
model.component('comp1').physics('spf').create('vf1', 'VolumeForce', 2);
model.component('comp1').physics('spf').feature('vf1').selection.set([2 3]);
model.component('comp1').physics('spf').create('bs1', 'BoundaryStress', 1);
model.component('comp1').physics('spf').feature('bs1').selection.set([1 12]);
model.component('comp1').physics.create('spf2', 'CreepingFlow', 'geom1');
model.component('comp1').physics('spf2').field('velocity').field('u2');
model.component('comp1').physics('spf2').field('velocity').component({'Mnt' 'Mtt' 'Mst'});
model.component('comp1').physics('spf2').field('pressure').field('Qt');
model.component('comp1').physics('spf2').create('pfc1', 'PeriodicFlowCondition', 1);
model.component('comp1').physics('spf2').feature('pfc1').selection.set([2 3 5 7 9 11]);
model.component('comp1').physics('spf2').create('vf1', 'VolumeForce', 2);
model.component('comp1').physics('spf2').feature('vf1').selection.set([2 3]);
model.component('comp1').physics('spf2').create('bs1', 'BoundaryStress', 1);
model.component('comp1').physics('spf2').feature('bs1').selection.set([1 12]);
model.component('comp1').physics.create('w3', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w3').identifier('w3');
model.component('comp1').physics('w3').field('dimensionless').field('T');
model.component('comp1').physics('w3').field('dimensionless').component({'T'});
model.component('comp1').physics('w3').create('pc1', 'PeriodicCondition', 1);
model.component('comp1').physics('w3').feature('pc1').selection.set([2 3 5 7 9 11]);
model.component('comp1').physics('w3').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w3').feature('dir1').selection.set([13 14 15 16 17 18 19 20]);
model.component('comp1').physics('w3').create('src1', 'SourceTerm', 2);
model.component('comp1').physics('w3').feature('src1').selection.set([2 3]);
model.component('comp1').physics.create('w2', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w2').identifier('w2');
model.component('comp1').physics('w2').field('dimensionless').field('S');
model.component('comp1').physics('w2').field('dimensionless').component({'S'});
model.component('comp1').physics('w2').create('pc1', 'PeriodicCondition', 1);
model.component('comp1').physics('w2').feature('pc1').selection.set([2 3 5 7 9 11]);
model.component('comp1').physics('w2').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w2').feature('dir1').selection.set([13 14 15 16 17 18 19 20]);
model.component('comp1').physics('w2').create('src1', 'SourceTerm', 2);
model.component('comp1').physics('w2').feature('src1').selection.set([2 3]);

model.component('comp1').mesh('mesh1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').create('size2', 'Size');
model.component('comp1').mesh('mesh1').create('cr1', 'CornerRefinement');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').feature('size1').selection.geom('geom1', 1);
model.component('comp1').mesh('mesh1').feature('size1').selection.set([13 14 15 16 17 18 19 20]);
model.component('comp1').mesh('mesh1').feature('size2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('size2').selection.set([2 3]);
model.component('comp1').mesh('mesh1').feature('cr1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('cr1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').feature('bl1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('bl1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp1', 'BndLayerProp');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp1').selection.set([13 14 15 16 17 18 19 20]);

model.result.table('tbl1').comments('U');
model.result.table('tbl2').comments('D');

model.component('comp1').physics('spf').label('stokes Mnn Mnt');
model.component('comp1').physics('spf').prop('ConsistentStabilization').set('StreamlineDiffusion', false);
model.component('comp1').physics('spf').feature('fp1').set('rho_mat', 'userdef');
model.component('comp1').physics('spf').feature('fp1').set('rho', 1);
model.component('comp1').physics('spf').feature('fp1').set('mu_mat', 'userdef');
model.component('comp1').physics('spf').feature('fp1').set('mu', 1);
model.component('comp1').physics('spf').feature('vf1').set('F', {'1/delta'; '0'; '0'});
model.component('comp1').physics('spf2').label('stokes Mtn Mtt');
model.component('comp1').physics('spf2').prop('ConsistentStabilization').set('StreamlineDiffusion', false);
model.component('comp1').physics('spf2').feature('fp1').set('rho_mat', 'userdef');
model.component('comp1').physics('spf2').feature('fp1').set('rho', 1);
model.component('comp1').physics('spf2').feature('fp1').set('mu_mat', 'userdef');
model.component('comp1').physics('spf2').feature('fp1').set('mu', 1);
model.component('comp1').physics('spf2').feature('vf1').set('F', {'0'; '1/delta'; '0'});
model.component('comp1').physics('w3').label('T');
model.component('comp1').physics('w3').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w3').feature('wfeq1').set('weak', '-epsilon^2*PeL*Um*Tx*test(T)-epsilon^2*PeL*Vm*Ty*test(T)-Tx*test(Tx)-Ty*test(Ty)');
model.component('comp1').physics('w3').feature('src1').set('f', '1/delta');
model.component('comp1').physics('w2').label('S');
model.component('comp1').physics('w2').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w2').feature('wfeq1').set('weak', '-epsilon^2*PeL*Um*Sx*test(S)-epsilon^2*PeL*Vm*Sy*test(S)-Sx*test(Sx)-Sy*test(Sy)');
model.component('comp1').physics('w2').feature('src1').set('f', '-1/delta');

model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 0.06);
model.component('comp1').mesh('mesh1').feature('size').set('hmin', '0.00054');
model.component('comp1').mesh('mesh1').feature('size').set('hgrad', 1.12);
model.component('comp1').mesh('mesh1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size1').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size1').set('hmax', 0.002);
model.component('comp1').mesh('mesh1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hmin', '0.00054');
model.component('comp1').mesh('mesh1').feature('size1').set('hminactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hcurveactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hnarrowactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hgrad', 1.15);
model.component('comp1').mesh('mesh1').feature('size1').set('hgradactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size2').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size2').set('hmax', 'delta/8');
model.component('comp1').mesh('mesh1').feature('size2').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hmin', 0.002);
model.component('comp1').mesh('mesh1').feature('size2').set('hgrad', 1.15);
model.component('comp1').mesh('mesh1').feature('size2').set('hminactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('hcurveactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('hnarrowactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('hgradactive', false);
model.component('comp1').mesh('mesh1').feature('cr1').selection('boundary').set([13 14 15 16 17 18 19 20]);
model.component('comp1').mesh('mesh1').feature('bl1').set('sharpcorners', 'trim');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp1').set('blnlayers', 5);
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp1').set('blhminfact', 10);
model.component('comp1').mesh('mesh1').run;

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').create('stat2', 'Stationary');
model.study('std1').feature('stat').set('activate', {'spf' 'on' 'spf2' 'on' 'w3' 'off' 'w2' 'off' 'frame:spatial1' 'on'  ...
'frame:material1' 'on'});
model.study('std1').feature('stat2').set('activate', {'spf' 'off' 'spf2' 'off' 'w3' 'on' 'w2' 'on' 'frame:spatial1' 'on'  ...
'frame:material1' 'on'});

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').create('su1', 'StoreSolution');
model.sol('sol1').create('st2', 'StudyStep');
model.sol('sol1').create('v2', 'Variables');
model.sol('sol1').create('s2', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').create('i2', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').create('bns1', 'BlockNavierStokes');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i2').create('bns1', 'BlockNavierStokes');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').feature('s2').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s2').feature.remove('fcDef');

model.result.numerical.create('int1', 'IntLine');
model.result.numerical.create('int2', 'IntLine');
model.result.numerical('int1').selection.set([1]);
model.result.numerical('int1').set('probetag', 'none');
model.result.numerical('int2').selection.set([12]);
model.result.numerical('int2').set('probetag', 'none');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').set('stol', '1e-6');
model.sol('sol1').feature('s1').feature('dDef').label('Direct 2');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol1').feature('s1').feature('fc1').set('maxiter', 100);
model.sol('sol1').feature('s1').feature('d1').label('Direct, fluid flow variables (spf) (merged)');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('i1').label('Block Navier-Stokes, fluid flow variables (spf)');
model.sol('sol1').feature('s1').feature('i1').set('nlinnormuse', true);
model.sol('sol1').feature('s1').feature('i1').set('maxlinit', 1000);
model.sol('sol1').feature('s1').feature('i1').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i1').feature('ilDef').label('Incomplete LU 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').label('Block Navier-Stokes 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('schurcomplementapproximation', 'abssumf');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('velocityvars', {'comp1_Mn'});
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('pressurevars', {'comp1_Qn'});
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('hybridvar', {'comp1_Mn' 'comp1_Qn'});
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').label('Velocity Solver 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').label('Multigrid 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').set('strconn', 0.02);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').set('saamgcompwise', true);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('pr').label('Presmoother 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('pr').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('pr').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('po').label('Postsmoother 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('po').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('cs').label('Coarse Solver 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('dDef').label('Direct 2');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('d1').label('Direct 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').label('Pressure Solver 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').label('Multigrid 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').set('strconn', 0.02);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('pr').label('Presmoother 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('po').label('Postsmoother 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('po').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('cs').label('Coarse Solver 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('dDef').label('Direct 2');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('d1').label('Direct 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('i2').label('Block Navier-Stokes, fluid flow variables (spf2)');
model.sol('sol1').feature('s1').feature('i2').set('nlinnormuse', true);
model.sol('sol1').feature('s1').feature('i2').set('maxlinit', 1000);
model.sol('sol1').feature('s1').feature('i2').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i2').feature('ilDef').label('Incomplete LU 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').label('Block Navier-Stokes 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('schurcomplementapproximation', 'abssumf');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('velocityvars', {'comp1_u2'});
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('pressurevars', {'comp1_Qt'});
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('hybridvar', {'comp1_u2' 'comp1_Qt'});
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').label('Velocity Solver 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').label('Multigrid 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').set('strconn', 0.02);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').set('saamgcompwise', true);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('pr').label('Presmoother 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('pr').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('pr').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('po').label('Postsmoother 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('po').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('cs').label('Coarse Solver 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('dDef').label('Direct 2');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('d1').label('Direct 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('vs').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').label('Pressure Solver 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').label('Multigrid 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').set('strconn', 0.02);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('pr').label('Presmoother 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('po').label('Postsmoother 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('po').feature('soDef').label('SOR 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('po').feature('sl1').label('SOR Line 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('cs').label('Coarse Solver 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('dDef').label('Direct 2');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('d1').label('Direct 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').feature('ps').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('su1').label('Solution Store 1.1');
model.sol('sol1').feature('st2').label('Compile Equations: Stationary 2');
model.sol('sol1').feature('st2').set('studystep', 'stat2');
model.sol('sol1').feature('v2').label('Dependent Variables 2.1');
model.sol('sol1').feature('v2').set('initmethod', 'sol');
model.sol('sol1').feature('v2').set('initsol', 'sol1');
model.sol('sol1').feature('v2').set('solnum', 'auto');
model.sol('sol1').feature('v2').set('notsolmethod', 'sol');
model.sol('sol1').feature('v2').set('notsol', 'sol1');
model.sol('sol1').feature('v2').set('notsolnum', 'auto');
model.sol('sol1').feature('s2').label('Stationary Solver 2.1');
model.sol('sol1').feature('s2').set('stol', '1e-3');
model.sol('sol1').feature('s2').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s2').feature('dDef').set('linsolver', 'pardiso');
model.sol('sol1').feature('s2').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s2').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').runAll;

model.result.numerical('int1').label('U');
model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').set('expr', {'T'});
model.result.numerical('int1').set('unit', {''});
model.result.numerical('int1').set('descr', {'T'});
model.result.numerical('int2').label('D');
model.result.numerical('int2').set('table', 'tbl2');
model.result.numerical('int2').set('expr', {'S'});
model.result.numerical('int2').set('unit', {''});
model.result.numerical('int2').set('descr', {'S'});
model.result.numerical('int1').setResult;
model.result.numerical('int2').setResult;

model.result.table('tbl1').save([path,'\T_va-cell',num2str(i),'-it',num2str(iter),'.txt']);
model.result.table('tbl2').save([path,'\S_va-cell',num2str(i),'-it',num2str(iter),'.txt']);

out = model;
end

%put together all micro results
if length(param_list(1,:))==1
    T=load([path,'\T_va-cell',num2str(1),'-it',num2str(iter),'.txt']);
    S=load([path,'\S_va-cell',num2str(1),'-it',num2str(iter),'.txt']);
    TS=[T,S].*ones([1/epsilon,2]);
    writematrix(TS,[path,'\TS_va-it',num2str(iter),'.txt']);
elseif length(param_list(1,:))==1/epsilon
    TS=[];
    for i=1:1/epsilon
        T=load([path,'\T_va-cell',num2str(i),'-it',num2str(iter),'.txt']);
        S=load([path,'\S_va-cell',num2str(i),'-it',num2str(iter),'.txt']);
        TS=[TS;[T,S]];
    end
    writematrix(TS,[path,'\TS_va-it',num2str(iter),'.txt']);
else 
    disp('ERROR: parameter list is not of length 1 (Stokes) or 1/epsilon (CA/VA). No MN is written')
end