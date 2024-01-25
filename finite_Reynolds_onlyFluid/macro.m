function out=macro(path,mode,tensors,epsilon,ReL,alfa,iter)
% to try out: out=macro(pwd,0,["0.05";"0";"0";"0.01";"-0.05";"0";"0";"-0.01"],0.1,100,90,1)
disp(['solving macroscopic model... iter=',num2str(iter),' mode=',num2str(mode)])

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');
ModelUtil.showProgress(true); %to show progress
model.modelPath(path);

if mode==1
    model.label(['macro_CA-',num2str(iter),'.mph']);
elseif mode==2
    model.label(['macro_VA-',num2str(iter),'.mph']);
else
    disp('ERROR, invalid model');return;
end

model.param.set('epsilon', num2str(epsilon));
model.param.set('por', '0.7');
model.param.set('ReL', num2str(ReL));
model.param.set('alfa', strcat(num2str(alfa),'[deg]'));

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').baseSystem('none');

for i=1:2/epsilon
    model.result.table.create(['tbl',num2str(i)], 'Table');
end

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('pos', [-1.5 -1.5]);
model.component('comp1').geom('geom1').feature('r1').set('size', [7 5]);
model.component('comp1').geom('geom1').create('ls1', 'LineSegment');
model.component('comp1').geom('geom1').feature('ls1').set('specify1', 'coord');
model.component('comp1').geom('geom1').feature('ls1').set('coord1', [0 -1.5]);
model.component('comp1').geom('geom1').feature('ls1').set('specify2', 'coord');
model.component('comp1').geom('geom1').feature('ls1').set('coord2', [0 3.5]);
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').create('pt2', 'Point');
model.component('comp1').geom('geom1').feature('pt2').set('p', [0 1]);
model.component('comp1').geom('geom1').create('arr1', 'Array');
model.component('comp1').geom('geom1').feature('arr1').set('type', 'linear');
model.component('comp1').geom('geom1').feature('arr1').set('linearsize', '1/epsilon');
model.component('comp1').geom('geom1').feature('arr1').set('displ', {'0' 'epsilon'});
model.component('comp1').geom('geom1').feature('arr1').selection('input').set({'pt1'});
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('pos', [-0.2 -0.2]);
model.component('comp1').geom('geom1').feature('r2').set('size', [2.5 2.5]);
model.component('comp1').geom('geom1').run;

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('s_1_11', '-p+2/ReL*ux');
model.component('comp1').variable('var1').set('s_1_12', '1/ReL*(uy+vx)');
model.component('comp1').variable('var1').set('s_1_21', '1/ReL*(uy+vx)');
model.component('comp1').variable('var1').set('s_1_22', '-p+2/ReL*vy');
model.component('comp1').variable('var1').set('s_2_11', '-p2+2/ReL*u2x');
model.component('comp1').variable('var1').set('s_2_12', '1/ReL*(u2y+v2x)');
model.component('comp1').variable('var1').set('s_2_21', '1/ReL*(u2y+v2x)');
model.component('comp1').variable('var1').set('s_2_22', '-p2+2/ReL*v2y');
model.component('comp1').variable('var1').set('Mnnn', convertStringsToChars(tensors(1)));
model.component('comp1').variable('var1').set('Mntn', convertStringsToChars(tensors(2)));
model.component('comp1').variable('var1').set('Mtnn', convertStringsToChars(tensors(3)));
model.component('comp1').variable('var1').set('Mttn', convertStringsToChars(tensors(4)));
model.component('comp1').variable('var1').set('Nnnn', convertStringsToChars(tensors(5)));
model.component('comp1').variable('var1').set('Nntn', convertStringsToChars(tensors(6)));
model.component('comp1').variable('var1').set('Ntnn', convertStringsToChars(tensors(7)));
model.component('comp1').variable('var1').set('Nttn', convertStringsToChars(tensors(8)));
model.component('comp1').variable.create('var2');
model.component('comp1').variable('var2').set('u_esj', 'epsilon*ReL*(Mnnn*(s_1_11*nx+s_1_12*ny)+Mntn*(s_1_21*nx+s_1_22*ny)+Nnnn*(s_2_11*nx+s_2_12*ny)+Nntn*(s_2_21*nx+s_2_22*ny))');
model.component('comp1').variable('var2').set('v_esj', 'epsilon*ReL*(Mtnn*(s_1_11*nx+s_1_12*ny)+Mttn*(s_1_21*nx+s_1_22*ny)+Ntnn*(s_2_11*nx+s_2_12*ny)+Nttn*(s_2_21*nx+s_2_22*ny))');

model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');
model.component('comp1').physics('spf').selection.set([1 2]);
model.component('comp1').physics('spf').create('inl1', 'InletBoundary', 1);
model.component('comp1').physics('spf').feature('inl1').selection.set([1 2 8]);
model.component('comp1').physics('spf').create('out1', 'OutletBoundary', 1);
model.component('comp1').physics('spf').feature('out1').selection.set([3 24 26]);
model.component('comp1').physics('spf').create('bs1', 'BoundaryStress', 1);
model.component('comp1').physics('spf').feature('bs1').selection.set([7 9 21 22]);
model.component('comp1').physics('spf').create('wallbc2', 'WallBC', 1);
model.component('comp1').physics('spf').feature('wallbc2').selection.set([11 12 13 14 15 16 17 18 19 20]);
model.component('comp1').physics.create('spf2', 'LaminarFlow', 'geom1');
model.component('comp1').physics('spf2').selection.set([3 4]);
model.component('comp1').physics('spf2').create('wallbc2', 'WallBC', 1);
model.component('comp1').physics('spf2').feature('wallbc2').selection.set([7 9 11 12 13 14 15 16 17 18 19 20 21 22]);
model.component('comp1').physics('spf2').create('inl1', 'InletBoundary', 1);
model.component('comp1').physics('spf2').feature('inl1').selection.set([8]);
model.component('comp1').physics('spf2').create('out1', 'OutletBoundary', 1);
model.component('comp1').physics('spf2').feature('out1').selection.set([24 26]);

model.component('comp1').mesh('mesh1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').create('size2', 'Size');
model.component('comp1').mesh('mesh1').create('cr1', 'CornerRefinement');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').feature('size1').selection.geom('geom1', 1);
model.component('comp1').mesh('mesh1').feature('size1').selection.set([11 12 13 14 15 16 17 18 19 20]);
model.component('comp1').mesh('mesh1').feature('size2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('size2').selection.set([2 4]);
model.component('comp1').mesh('mesh1').feature('cr1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('cr1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').feature('bl1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('bl1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp1', 'BndLayerProp');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp1').selection.set([7 9 11 12 13 14 15 16 17 18 19 20 21 22]);

for i=1:2/epsilon
    if i<=1/epsilon
        model.result.table(['tbl',num2str(i)]).comments([num2str(i),'u']);
    else
        model.result.table(['tbl',num2str(i)]).comments([num2str(i-1/epsilon),'d']);
    end
end

model.component('comp1').variable('var2').label('ESJ');

model.component('comp1').physics('spf').prop('ShapeProperty').set('order_fluid', 2);
model.component('comp1').physics('spf').prop('ConsistentStabilization').set('StreamlineDiffusion', false);
model.component('comp1').physics('spf').feature('fp1').set('rho_mat', 'userdef');
model.component('comp1').physics('spf').feature('fp1').set('rho', 1);
model.component('comp1').physics('spf').feature('fp1').set('mu_mat', 'userdef');
model.component('comp1').physics('spf').feature('fp1').set('mu', '1/ReL');
model.component('comp1').physics('spf').feature('init1').set('u_init', {'sin(alfa)'; 'cos(alfa)'; '0'});
model.component('comp1').physics('spf').feature('inl1').set('ComponentWise', 'VelocityFieldComponentWise');
model.component('comp1').physics('spf').feature('inl1').set('u0', {'sin(alfa)'; 'cos(alfa)'; '0'});
model.component('comp1').physics('spf').feature('bs1').set('Fbnd', {'-(s_2_11*nx+s_2_12*ny)'; '-(s_2_21*nx+s_2_22*ny)'; '0'});
model.component('comp1').physics('spf').feature('wallbc2').set('BoundaryCondition', 'LeakingWall');
model.component('comp1').physics('spf').feature('wallbc2').set('uleak', {'u_esj'; 'v_esj'; '0'});
model.component('comp1').physics('spf2').prop('ShapeProperty').set('order_fluid', 2);
model.component('comp1').physics('spf2').prop('ConsistentStabilization').set('StreamlineDiffusion', false);
model.component('comp1').physics('spf2').feature('fp1').set('rho_mat', 'userdef');
model.component('comp1').physics('spf2').feature('fp1').set('rho', 1);
model.component('comp1').physics('spf2').feature('fp1').set('mu_mat', 'userdef');
model.component('comp1').physics('spf2').feature('fp1').set('mu', '1/ReL');
model.component('comp1').physics('spf2').feature('init1').set('u_init', {'sin(alfa)'; 'cos(alfa)'; '0'});
model.component('comp1').physics('spf2').feature('wallbc2').set('BoundaryCondition', 'LeakingWall');
model.component('comp1').physics('spf2').feature('wallbc2').set('uleak', {'u'; 'v'; '0'});
model.component('comp1').physics('spf2').feature('inl1').set('ComponentWise', 'VelocityFieldComponentWise');
model.component('comp1').physics('spf2').feature('inl1').set('u0', {'sin(alfa)'; 'cos(alfa)'; '0'});

model.component('comp1').mesh('mesh1').feature('size').set('hauto', 6);
model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 0.06);
model.component('comp1').mesh('mesh1').feature('size').set('hmin', 0.005);
model.component('comp1').mesh('mesh1').feature('size').set('hgrad', 1.2);
model.component('comp1').mesh('mesh1').feature('size1').set('hauto', 4);
model.component('comp1').mesh('mesh1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size1').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size1').set('hmax', 'epsilon*(1-por)/4');
model.component('comp1').mesh('mesh1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size1').set('hmin', 'epsilon/1.5');
model.component('comp1').mesh('mesh1').feature('size1').set('hgrad', 1.1);
model.component('comp1').mesh('mesh1').feature('size1').set('hminactive', false);
model.component('comp1').mesh('mesh1').feature('size1').set('hcurveactive', false);
model.component('comp1').mesh('mesh1').feature('size1').set('hnarrowactive', false);
model.component('comp1').mesh('mesh1').feature('size1').set('hgradactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size2').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size2').set('hmax', 'epsilon/2');
model.component('comp1').mesh('mesh1').feature('size2').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hmin', 0.01);
model.component('comp1').mesh('mesh1').feature('size2').set('hgrad', 1.15);
model.component('comp1').mesh('mesh1').feature('size2').set('hminactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('hcurveactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('hnarrowactive', false);
model.component('comp1').mesh('mesh1').feature('size2').set('hgradactive', false);
model.component('comp1').mesh('mesh1').feature('cr1').selection('boundary').set([1 2 3 7 8 9 11 12 13 14 15 16 17 18 19 20 21 22 24 26]);
model.component('comp1').mesh('mesh1').feature('bl1').set('sharpcorners', 'trim');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp1').set('blnlayers', 2);
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp1').set('blhminfact', 5);
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
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').create('i2', 'Iterative');
model.sol('sol1').feature('s1').create('pDef', 'Parametric');
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

for i=1:2/epsilon
    model.result.dataset.create(['cln',num2str(i)], 'CutLine2D');
end

model.result.dataset.create('dset3', 'Solution');

for i=1:2/epsilon
    model.result.dataset(['cln',num2str(i)]).set('data', 'dset3');
end

model.result.dataset.remove('dset1');

for i=1:2/epsilon
    model.result.numerical.create(['int',num2str(i)], 'IntLine');
    model.result.numerical(['int',num2str(i)]).set('probetag', 'none');
end

model.result.export.create('data1', 'Data');
model.result.export.create('data2', 'Data');
model.result.export.create('data3', 'Data');

model.study('std1').feature('stat').set('useparam', true);
model.study('std1').feature('stat').set('pname', {'ReL'});
model.study('std1').feature('stat').set('plistarr', {['1,',convertStringsToChars(num2str(ReL))]});
model.study('std1').feature('stat').set('punit', {''});
model.study('std1').feature('stat').set('pcontinuationmode', 'no');
model.study('std1').feature('stat').set('preusesol', 'yes');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('v1').set('clistctrl', {'pDef'});
model.sol('sol1').feature('v1').set('cname', {'ReL'});
model.sol('sol1').feature('v1').set('clist', {['1 ',convertStringsToChars(num2str(ReL))]});
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').set('stol', '1e-6');
model.sol('sol1').feature('s1').set('probesel', 'none');
model.sol('sol1').feature('s1').feature('dDef').active(true);
model.sol('sol1').feature('s1').feature('dDef').label('Direct 2');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
model.sol('sol1').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol1').feature('s1').feature('fc1').set('maxiter', 100);
model.sol('sol1').feature('s1').feature('d1').label('Direct, fluid flow variables (spf) (merged)');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('i1').label('Block Navier-Stokes, fluid flow variables (spf2)');
model.sol('sol1').feature('s1').feature('i1').set('nlinnormuse', true);
model.sol('sol1').feature('s1').feature('i1').set('maxlinit', 1000);
model.sol('sol1').feature('s1').feature('i1').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i1').feature('ilDef').label('Incomplete LU 1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').label('Block Navier-Stokes 1.1');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('schurcomplementapproximation', 'abssumf');
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('velocityvars', {'comp1_u2'});
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('pressurevars', {'comp1_p2'});
model.sol('sol1').feature('s1').feature('i1').feature('bns1').set('hybridvar', {'comp1_u2' 'comp1_p2'});
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
model.sol('sol1').feature('s1').feature('i2').label('Block Navier-Stokes, fluid flow variables (spf)');
model.sol('sol1').feature('s1').feature('i2').set('nlinnormuse', true);
model.sol('sol1').feature('s1').feature('i2').set('maxlinit', 1000);
model.sol('sol1').feature('s1').feature('i2').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i2').feature('ilDef').label('Incomplete LU 1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').label('Block Navier-Stokes 1.1');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('schurcomplementapproximation', 'abssumf');
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('velocityvars', {'comp1_u'});
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('pressurevars', {'comp1_p'});
model.sol('sol1').feature('s1').feature('i2').feature('bns1').set('hybridvar', {'comp1_u' 'comp1_p'});
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
model.sol('sol1').feature('s1').feature('pDef').label('Parametric 1');
model.sol('sol1').feature('s1').feature('pDef').set('pname', {'ReL'});
model.sol('sol1').feature('s1').feature('pDef').set('plistarr', {['1,',convertStringsToChars(num2str(ReL))]});
model.sol('sol1').feature('s1').feature('pDef').set('punit', {''});
model.sol('sol1').feature('s1').feature('pDef').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('pDef').set('preusesol', 'yes');
model.sol('sol1').feature('s1').feature('pDef').set('uselsqdata', false);
model.sol('sol1').runAll;


for i=1:2/epsilon
    if i<=1/epsilon
        model.result.dataset(['cln',num2str(i)]).label(num2str(i));
        model.result.dataset(['cln',num2str(i)]).set('genpoints', {'-1e-6' num2str((i-1)*epsilon); '-1e-6' num2str(i*epsilon)});
        model.result.dataset(['cln',num2str(i)]).set('spacevars', {'cln1x'});
        model.result.dataset(['cln',num2str(i)]).set('normal', {'cln1nx' 'cln1ny'});
        model.result.dataset(['cln',num2str(i)]).set('tangent', {'cln1tx' 'cln1ty'});
    else
        model.result.dataset(['cln',num2str(i)]).label(num2str(i));
        model.result.dataset(['cln',num2str(i)]).set('genpoints', {'1e-6' num2str((i-1/epsilon-1)*epsilon); '1e-6' num2str((i-1/epsilon)*epsilon)});
        model.result.dataset(['cln',num2str(i)]).set('spacevars', {'cln1x'});
        model.result.dataset(['cln',num2str(i)]).set('normal', {'cln1nx' 'cln1ny'});
        model.result.dataset(['cln',num2str(i)]).set('tangent', {'cln1tx' 'cln1ty'});
    end
end

for i=1:2/epsilon
    if i<=1/epsilon
        model.result.numerical(['int',num2str(i)]).label([num2str(i),'u']);
        model.result.numerical(['int',num2str(i)]).set('data', ['cln',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('looplevelinput', {'last'});
        model.result.numerical(['int',num2str(i)]).set('table', ['tbl',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('expr', {'s_1_11/epsilon' 's_1_12/epsilon' 's_1_21/epsilon' 's_1_22/epsilon' 'u/epsilon' 'v/epsilon'});
        model.result.numerical(['int',num2str(i)]).set('unit', {'' '' '' '' '' ''});
        model.result.numerical(['int',num2str(i)]).set('descr', {'S_U_11' 'S_U_12' 'S_U_21' 'S_U_22' 'u_U' 'v_U'});
    else
        model.result.numerical(['int',num2str(i)]).label([num2str(i-1/epsilon),'d']);
        model.result.numerical(['int',num2str(i)]).set('data', ['cln',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('looplevelinput', {'last'});
        model.result.numerical(['int',num2str(i)]).set('table', ['tbl',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('expr', {'s_2_11/epsilon' 's_2_12/epsilon' 's_2_21/epsilon' 's_2_22/epsilon' 'u2/epsilon' 'v2/epsilon'});
        model.result.numerical(['int',num2str(i)]).set('unit', {'' '' '' '' '' ''});
        model.result.numerical(['int',num2str(i)]).set('descr', {'S_D_11' 'S_D_12' 'S_D_21' 'S_D_22' 'u_D' 'v_D'});
    end
end

for i=1:2/epsilon
    model.result.numerical(['int',num2str(i)]).setResult;
end

for i=1:2/epsilon
    if i<=1/epsilon
        if mode==1
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i),'u_ca-it',num2str(iter),'.txt']);
        elseif mode==2
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i),'u_va-it',num2str(iter),'.txt']);
        else
            disp('ERROR');
        end
    else
        if mode==1
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i-1/epsilon),'d_ca-it',num2str(iter),'.txt']);
        elseif mode==2
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i-1/epsilon),'d_va-it',num2str(iter),'.txt']);
        else
            disp('ERROR');
        end
    end
end

if mode==1
    model.result.export('data1').label('uv membrane');
    model.result.export('data1').set('looplevelinput', {'last'});
    model.result.export('data1').set('expr', {'u' 'v'});
    model.result.export('data1').set('unit', {'' ''});
    model.result.export('data1').set('descr', {'Velocity field, x component' 'Velocity field, y component'});
    model.result.export('data1').set('filename', [path,'\uv_C_CA-iter',num2str(iter),'.txt']);
    model.result.export('data1').set('location', 'grid');
    model.result.export('data1').set('gridx2', '-1e-6');
    model.result.export('data1').set('gridy2', 'range(0,0.001,1)');
    model.result.export('data2').label('field 1');
    model.result.export('data2').set('looplevelinput', {'last'});
    model.result.export('data2').set('expr', {'u' 'v' 'p'});
    model.result.export('data2').set('unit', {'' '' ''});
    model.result.export('data2').set('descr', {'Velocity field, x component' 'Velocity field, y component' 'Pressure'});
    model.result.export('data2').set('filename', [path,'\field_1_CA-iter',num2str(iter),'.txt']);
    model.result.export('data3').label('field 2');
    model.result.export('data3').set('looplevelinput', {'last'});
    model.result.export('data3').set('expr', {'u2' 'v2' 'p2'});
    model.result.export('data3').set('unit', {'' '' ''});
    model.result.export('data3').set('descr', {'Velocity field, x component' 'Velocity field, y component' 'Pressure'});
    model.result.export('data3').set('filename', [path,'\field_2_CA-iter',num2str(iter),'.txt']);
    model.result.export('data1').run;
    model.result.export('data2').run;
    model.result.export('data3').run;
elseif mode==2
    model.result.export('data1').label('uv membrane');
    model.result.export('data1').set('looplevelinput', {'last'});
    model.result.export('data1').set('expr', {'u' 'v'});
    model.result.export('data1').set('unit', {'' ''});
    model.result.export('data1').set('descr', {'Velocity field, x component' 'Velocity field, y component'});
    model.result.export('data1').set('filename', [path,'\uv_C_VA-iter',num2str(iter),'.txt']);
    model.result.export('data1').set('location', 'grid');
    model.result.export('data1').set('gridx2', '-1e-6');
    model.result.export('data1').set('gridy2', 'range(0,0.001,1)');
    model.result.export('data2').label('field 1');
    model.result.export('data2').set('looplevelinput', {'last'});
    model.result.export('data2').set('expr', {'u' 'v' 'p'});
    model.result.export('data2').set('unit', {'' '' ''});
    model.result.export('data2').set('descr', {'Velocity field, x component' 'Velocity field, y component' 'Pressure'});
    model.result.export('data2').set('filename', [path,'\field_1_VA-iter',num2str(iter),'.txt']);
    model.result.export('data3').label('field 2');
    model.result.export('data3').set('looplevelinput', {'last'});
    model.result.export('data3').set('expr', {'u2' 'v2' 'p2'});
    model.result.export('data3').set('unit', {'' '' ''});
    model.result.export('data3').set('descr', {'Velocity field, x component' 'Velocity field, y component' 'Pressure'});
    model.result.export('data3').set('filename', [path,'\field_2_VA-iter',num2str(iter),'.txt']);
    model.result.export('data1').run;
    model.result.export('data2').run;
    model.result.export('data3').run;
else
    disp('ERROR');return;
end

out = model;
