function out = micro_slt_CA(path,param_list,PeL,epsilon,iter)
% param_list has 6 rows, sigma nn tn U, then D then u,v, and N columns, format double;

if iter>0
    % exclude extremes to enhance stability
    param_list=[param_list(:,2),param_list(:,2:end-1),param_list(:,end-1)];
end
%-------------------------------------
for i=1:length(param_list(1,:))
disp(['solving micro slt CA... cell=',num2str(i),' iter=',num2str(iter)])
import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath(path);
ModelUtil.showProgress(true); %to show progress

model.label(['micro_slt_CA-',num2str(iter),'.mph']);

model.baseSystem('none');

model.param.set('K', '4');
model.param.set('PeL', num2str(PeL));
model.param.set('U', num2str(-param_list(5,i)));
model.param.set('V', num2str(-param_list(6,i)));
model.param.set('delta', '0.01');
model.param.set('epsilon', num2str(epsilon));

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

model.component('comp1').physics('w3').label('T');
model.component('comp1').physics('w3').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w3').feature('wfeq1').set('weak', '-epsilon*PeL*U*Tx*test(T)-epsilon*PeL*V*Ty*test(T)-Tx*test(Tx)-Ty*test(Ty)');
model.component('comp1').physics('w3').feature('src1').set('f', '1/delta');
model.component('comp1').physics('w2').label('S');
model.component('comp1').physics('w2').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w2').feature('wfeq1').set('weak', '-epsilon*PeL*U*Sx*test(S)-epsilon*PeL*V*Sy*test(S)-Sx*test(Sx)-Sy*test(Sy)');
model.component('comp1').physics('w2').feature('src1').set('f', '-1/delta');

model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 0.06);
model.component('comp1').mesh('mesh1').feature('size').set('hmin', '0.00054');
model.component('comp1').mesh('mesh1').feature('size').set('hgrad', 1.12);
model.component('comp1').mesh('mesh1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size1').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size1').set('hmax', 0.0025);
model.component('comp1').mesh('mesh1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hmin', '0.00054');
model.component('comp1').mesh('mesh1').feature('size1').set('hminactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hcurveactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hnarrowactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hgrad', 1.15);
model.component('comp1').mesh('mesh1').feature('size1').set('hgradactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size2').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size2').set('hmax', 'delta/5');
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

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.remove('fcDef');

model.result.dataset.create('dset2', 'Solution');
model.result.dataset.remove('dset1');
model.result.numerical.create('int1', 'IntLine');
model.result.numerical.create('int3', 'IntLine');
model.result.numerical('int1').selection.set([1]);
model.result.numerical('int1').set('probetag', 'none');
model.result.numerical('int3').selection.set([12]);
model.result.numerical('int3').set('probetag', 'none');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').set('stol', '1e-6');
model.sol('sol1').feature('s1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').runAll;

model.result.numerical('int1').label('U');
model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').set('expr', {'T'});
model.result.numerical('int1').set('unit', {''});
model.result.numerical('int1').set('descr', {'T'});
model.result.numerical('int3').label('D');
model.result.numerical('int3').set('table', 'tbl2');
model.result.numerical('int3').set('expr', {'S'});
model.result.numerical('int3').set('unit', {''});
model.result.numerical('int3').set('descr', {'S'});
model.result.numerical('int1').setResult;
model.result.numerical('int3').setResult;

model.result.table('tbl1').save([path,'\T_ca-cell',num2str(i),'-it',num2str(iter),'.txt']);
model.result.table('tbl2').save([path,'\S_ca-cell',num2str(i),'-it',num2str(iter),'.txt']);

out = model;
end

%put together all micro results
if length(param_list(1,:))==1
    T=load([path,'\T_ca-cell',num2str(1),'-it',num2str(iter),'.txt']);
    S=load([path,'\S_ca-cell',num2str(1),'-it',num2str(iter),'.txt']);
    TS=[T,S].*ones([1/epsilon,2]);
    writematrix(TS,[path,'\TS_ca-it',num2str(iter),'.txt']);
elseif length(param_list(1,:))==1/epsilon
    TS=[];
    for i=1:1/epsilon
        T=load([path,'\T_ca-cell',num2str(i),'-it',num2str(iter),'.txt']);
        S=load([path,'\S_ca-cell',num2str(i),'-it',num2str(iter),'.txt']);
        TS=[TS;[T,S]];
    end
    writematrix(TS,[path,'\TS_ca-it',num2str(iter),'.txt']);
else 
    disp('ERROR: parameter list is not of length 1 (Stokes) or 1/epsilon (CA/VA). No MN is written')
end
