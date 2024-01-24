function out = macro_slt(path,mode,tensors_slt,epsilon,PeL,iter)

disp(['solving macroscopic model SLT... iter=',num2str(iter),' mode=',num2str(mode)])


import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');
ModelUtil.showProgress(true); %to show progress

model.modelPath(path);

if mode==1
    model.label(['macro_slt_CA-it',num2str(iter),'.mph']);
elseif mode==2
    model.label(['macro_slt_VA-it',num2str(iter),'.mph']);
else
    disp('ERROR, invalid model');return;
end

model.baseSystem('none');

model.param.set('PeL', num2str(PeL));
model.param.set('epsilon', num2str(epsilon));

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

for i=1:2/epsilon
    model.result.table.create(['tbl',num2str(i)], 'Table');
end

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('pos', [-1.5 -1.5]);
model.component('comp1').geom('geom1').feature('r1').set('size', [7 5]);
model.component('comp1').geom('geom1').create('ls2', 'LineSegment');
model.component('comp1').geom('geom1').feature('ls2').set('specify1', 'coord');
model.component('comp1').geom('geom1').feature('ls2').set('coord1', [0 -1.5]);
model.component('comp1').geom('geom1').feature('ls2').set('specify2', 'coord');
model.component('comp1').geom('geom1').feature('ls2').set('coord2', [0 3.5]);
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
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('S_U_11', '-p+2*ux');
model.component('comp1').variable('var1').set('S_U_12', 'uy+vx');
model.component('comp1').variable('var1').set('S_U_21', 'uy+vx');
model.component('comp1').variable('var1').set('S_U_22', '-p+2*vy');
model.component('comp1').variable('var1').set('S_D_11', '-pin+2*uinx');
model.component('comp1').variable('var1').set('S_D_12', 'uiny+vinx');
model.component('comp1').variable('var1').set('S_D_21', 'uiny+vinx');
model.component('comp1').variable('var1').set('S_D_22', '-pin+2*viny');
model.component('comp1').variable('var1').set('Mnnn', '0.050201'); %stokes flow 
model.component('comp1').variable('var1').set('Mttn', '0.010324');
model.component('comp1').variable('var1').set('Nnnn', '-0.050201');
model.component('comp1').variable('var1').set('Nttn', '-0.010324');
model.component('comp1').variable('var1').set('T', convertStringsToChars(tensors_slt(1)));% finite PeL
model.component('comp1').variable('var1').set('S', convertStringsToChars(tensors_slt(2)));

model.component('comp1').physics.create('w', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w').field('dimensionless').field('p');
model.component('comp1').physics('w').field('dimensionless').component({'p'});
model.component('comp1').physics('w').selection.set([1 2]);
model.component('comp1').physics.create('w2', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w2').field('dimensionless').field('u2');
model.component('comp1').physics('w2').field('dimensionless').component({'u' 'v'});
model.component('comp1').physics('w2').selection.set([1 2]);
model.component('comp1').physics('w2').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w2').feature('dir1').selection.set([1]);
model.component('comp1').physics('w2').create('flux1', 'FluxBoundary', 1);
model.component('comp1').physics('w2').feature('flux1').selection.set([7 9 21 22]);
model.component('comp1').physics('w2').create('dir5', 'DirichletBoundary', 1);
model.component('comp1').physics('w2').feature('dir5').selection.set([11 12 13 14 15 16 17 18 19 20]);
model.component('comp1').physics.create('w3', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w3').field('dimensionless').field('c');
model.component('comp1').physics('w3').field('dimensionless').component({'c'});
model.component('comp1').physics('w3').selection.set([1 2]);
model.component('comp1').physics('w3').create('dir1', 'DirichletBoundary', 1);
model.component('comp1').physics('w3').feature('dir1').selection.set([1]);
model.component('comp1').physics('w3').create('flux1', 'FluxBoundary', 1);
model.component('comp1').physics('w3').feature('flux1').selection.set([7 9 21 22]);
model.component('comp1').physics('w3').create('dir4', 'DirichletBoundary', 1);
model.component('comp1').physics('w3').feature('dir4').selection.set([11 12 13 14 15 16 17 18 19 20]);
model.component('comp1').physics.create('w4', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w4').field('dimensionless').field('u4');
model.component('comp1').physics('w4').field('dimensionless').component({'pin'});
model.component('comp1').physics('w4').selection.set([3 4]);
model.component('comp1').physics.create('w5', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w5').field('dimensionless').field('u5');
model.component('comp1').physics('w5').field('dimensionless').component({'uin' 'vin'});
model.component('comp1').physics('w5').selection.set([3 4]);
model.component('comp1').physics('w5').create('dir2', 'DirichletBoundary', 1);
model.component('comp1').physics('w5').feature('dir2').selection.set([7 9 11 12 13 14 15 16 17 18 19 20 21 22]);
model.component('comp1').physics.create('w6', 'WeakFormPDE', 'geom1');
model.component('comp1').physics('w6').field('dimensionless').field('cin');
model.component('comp1').physics('w6').field('dimensionless').component({'cin'});
model.component('comp1').physics('w6').selection.set([3 4]);
model.component('comp1').physics('w6').create('dir2', 'DirichletBoundary', 1);
model.component('comp1').physics('w6').feature('dir2').selection.set([7 9 11 12 13 14 15 16 17 18 19 20 21 22]);

model.component('comp1').mesh('mesh1').create('size2', 'Size');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').feature('size2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('size2').selection.set([2 4]);
model.component('comp1').mesh('mesh1').feature('ftri1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').selection.geom('geom1', 1);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').selection.set([7 9 11 12 13 14 15 16 17 18 19 20 21 22]);
model.component('comp1').mesh('mesh1').feature('bl1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('bl1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp', 'BndLayerProp');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.set([7 9 11 12 13 14 15 16 17 18 19 20 21 22]);

for i=1:2/epsilon
    if i<=1/epsilon
        model.result.table(['tbl',num2str(i)]).comments([num2str(i),'u']);
    else
        model.result.table(['tbl',num2str(i)]).comments([num2str(i-1/epsilon),'d']);
    end
end

model.component('comp1').physics('w').label('mass');
model.component('comp1').physics('w').prop('ShapeProperty').set('order', 1);
model.component('comp1').physics('w').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w').feature('wfeq1').set('weak', 'test(p)*ux+test(p)*vy');
model.component('comp1').physics('w2').label('momentum');
model.component('comp1').physics('w2').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w2').feature('wfeq1').set('weak', {'test(ux)*p-test(uy)*uy-test(ux)*ux'; 'test(vy)*p-test(vx)*vx-test(vy)*vy'});
model.component('comp1').physics('w2').feature('init1').set('u', 1);
model.component('comp1').physics('w2').feature('dir1').set('r', [1; 0]);
model.component('comp1').physics('w2').feature('dir1').label('inlet');
model.component('comp1').physics('w2').feature('flux1').set('g', {'-nx*(-pin+uinx)'; '-nx*(vinx)'});
model.component('comp1').physics('w2').feature('dir5').set('r', {'epsilon*(Mnnn*((-p+2*ux)*nx)+Nnnn*((-pin+2*uinx)*nx))'; 'epsilon*(Mttn*((uy+vx)*nx)+Nttn*((uiny+vinx)*nx))'});
model.component('comp1').physics('w2').feature('dir5').label('membrane');
model.component('comp1').physics('w3').label('ADE');
model.component('comp1').physics('w3').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w3').feature('wfeq1').set('weak', 'PeL*(u*cx*test(c)+v*cy*test(c))+cx*test(cx)+cy*test(cy)');
model.component('comp1').physics('w3').feature('init1').set('c', 1);
model.component('comp1').physics('w3').feature('dir1').set('r', 1);
model.component('comp1').physics('w3').feature('dir1').label('conc inlet');
model.component('comp1').physics('w3').feature('flux1').set('g', 'cinx*nx+ciny*ny');
model.component('comp1').physics('w3').feature('flux1').label('conc flux continuity');
model.component('comp1').physics('w3').feature('dir4').set('r', '-epsilon*(T*(PeL*u*c-cx)*nx+S*(PeL*uin*cin-cinx)*nx)');
model.component('comp1').physics('w3').feature('dir4').label('membrane');
model.component('comp1').physics('w4').label('mass 2');
model.component('comp1').physics('w4').prop('ShapeProperty').set('order', 1);
model.component('comp1').physics('w4').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w4').feature('wfeq1').set('weak', 'test(pin)*uinx+test(pin)*viny');
model.component('comp1').physics('w5').label('momentum 2');
model.component('comp1').physics('w5').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w5').feature('wfeq1').set('weak', {'test(uinx)*pin-test(uiny)*uiny-test(uinx)*uinx'; 'test(viny)*pin-test(vinx)*vinx-test(viny)*viny'});
model.component('comp1').physics('w5').feature('init1').set('uin', 1);
model.component('comp1').physics('w5').feature('dir2').set('r', {'u'; 'v'});
model.component('comp1').physics('w5').feature('dir2').label('uv continuity');
model.component('comp1').physics('w6').label('ADE 2');
model.component('comp1').physics('w6').prop('Units').set('CustomSourceTermUnit', 1);
model.component('comp1').physics('w6').feature('wfeq1').set('weak', 'PeL*(uin*cinx*test(cin)+vin*ciny*test(cin))+cinx*test(cinx)+ciny*test(ciny)');
model.component('comp1').physics('w6').feature('init1').set('cin', 1);
model.component('comp1').physics('w6').feature('dir2').set('r', 'c');
model.component('comp1').physics('w6').feature('dir2').label('conc contin');

model.component('comp1').mesh('mesh1').feature('size').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 0.05);
model.component('comp1').mesh('mesh1').feature('size').set('hmin', 0.003);
model.component('comp1').mesh('mesh1').feature('size').set('hgrad', 1.1);
model.component('comp1').mesh('mesh1').feature('size2').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('size2').set('hmax', 0.02);
model.component('comp1').mesh('mesh1').feature('size2').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hmin', 0.003);
model.component('comp1').mesh('mesh1').feature('size2').set('hminactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hcurveactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hnarrowactive', true);
model.component('comp1').mesh('mesh1').feature('size2').set('hgrad', 1.1);
model.component('comp1').mesh('mesh1').feature('size2').set('hgradactive', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('custom', 'on');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmax', 0.01);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmin', '0.0001');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hgrad', 1.1);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hgradactive', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hminactive', false);
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

for i=1:2/epsilon
    model.result.dataset.create(['cln',num2str(i)], 'CutLine2D');
    model.result.numerical.create(['int',num2str(i)], 'IntLine');
    model.result.numerical(['int',num2str(i)]).set('probetag', 'none');
end

model.result.export.create('data1', 'Data');
model.result.export.create('data2', 'Data');
model.result.export.create('data3', 'Data');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('st1').label('Compile Equations: Stationary');
model.sol('sol1').feature('v1').label('Dependent Variables 1.1');
model.sol('sol1').feature('s1').label('Stationary Solver 1.1');
model.sol('sol1').feature('s1').set('stol', '1e-6');
model.sol('sol1').feature('s1').feature('dDef').label('Direct 1');
model.sol('sol1').feature('s1').feature('aDef').label('Advanced 1');
model.sol('sol1').feature('s1').feature('fc1').label('Fully Coupled 1.1');
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
        model.result.numerical(['int',num2str(i)]).set('table', ['tbl',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('expr', {'S_U_11/epsilon' 'S_U_12/epsilon' 'S_U_21/epsilon' 'S_U_22/epsilon' 'u/epsilon' 'v/epsilon'});
        model.result.numerical(['int',num2str(i)]).set('unit', {'' '' '' '' '' ''});
        model.result.numerical(['int',num2str(i)]).set('descr', {'S_U_11' 'S_U_12' 'S_U_21' 'S_U_22' 'u_U' 'v_U'});
    else
        model.result.numerical(['int',num2str(i)]).label([num2str(i-1/epsilon),'d']);
        model.result.numerical(['int',num2str(i)]).set('data', ['cln',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('table', ['tbl',num2str(i)]);
        model.result.numerical(['int',num2str(i)]).set('expr', {'S_D_11/epsilon' 'S_D_12/epsilon' 'S_D_21/epsilon' 'S_D_22/epsilon' 'uin/epsilon' 'vin/epsilon'});
        model.result.numerical(['int',num2str(i)]).set('unit', {'' '' '' '' '' ''});
        model.result.numerical(['int',num2str(i)]).set('descr', {'S_D_11' 'S_D_12' 'S_D_21' 'S_D_22' 'u_D' 'v_D'});
    end
end

for i=1:2/epsilon
    model.result.numerical(['int',num2str(i)]).setResult;
    if i<=1/epsilon
        if mode==1
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i),'u_slt_ca-it',num2str(iter),'.txt']);
        elseif mode==2
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i),'u_slt_va-it',num2str(iter),'.txt']);
        end
    else
        if mode==1
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i-1/epsilon),'d_slt_ca-it',num2str(iter),'.txt']);
        elseif mode==2
            model.result.table(['tbl',num2str(i)]).save([path,'\',num2str(i-1/epsilon),'d_slt_va-it',num2str(iter),'.txt']);
        end
    end
end

if mode==1
    model.result.export('data1').label('fields 1');
    model.result.export('data1').set('expr', {'u' 'v' 'p' 'c'});
    model.result.export('data1').set('unit', {'' '' '' ''});
    model.result.export('data1').set('descr', {'' '' '' ''});
    model.result.export('data1').set('filename', [path,'\field1_slt_CA-iter',num2str(iter),'.txt']);
    model.result.export('data2').label('fields 2');
    model.result.export('data2').set('expr', {'uin' 'vin' 'pin' 'cin'});
    model.result.export('data2').set('unit', {'' '' '' ''});
    model.result.export('data2').set('descr', {'' '' '' ''});
    model.result.export('data2').set('filename', [path,'\field2_slt_CA-iter',num2str(iter),'.txt']);
    model.result.export('data3').set('expr', {'u' 'v' 'c'});
    model.result.export('data3').set('unit', {'' '' ''});
    model.result.export('data3').set('descr', {'' '' 'Dependent variable c'});
    model.result.export('data3').set('filename', [path,'\uvc_slt_C_CA-iter',num2str(iter),'.txt']);
    model.result.export('data3').set('location', 'grid');
    model.result.export('data3').set('gridx2', '-1e-6');
    model.result.export('data3').set('gridy2', 'range(0,0.001,1)');
    model.result.export('data1').run;
    model.result.export('data2').run;
    model.result.export('data3').run;
elseif mode==2
    model.result.export('data1').label('fields 1');
    model.result.export('data1').set('expr', {'u' 'v' 'p' 'c'});
    model.result.export('data1').set('unit', {'' '' '' ''});
    model.result.export('data1').set('descr', {'' '' '' ''});
    model.result.export('data1').set('filename', [path,'\field1_slt_VA-iter',num2str(iter),'.txt']);
    model.result.export('data2').label('fields 2');
    model.result.export('data2').set('expr', {'uin' 'vin' 'pin' 'cin'});
    model.result.export('data2').set('unit', {'' '' '' ''});
    model.result.export('data2').set('descr', {'' '' '' ''});
    model.result.export('data2').set('filename', [path,'\field2_slt_VA-iter',num2str(iter),'.txt']);
    model.result.export('data3').set('expr', {'u' 'v' 'c'});
    model.result.export('data3').set('unit', {'' '' ''});
    model.result.export('data3').set('descr', {'' '' 'Dependent variable c'});
    model.result.export('data3').set('filename', [path,'\uvc_slt_C_VA-iter',num2str(iter),'.txt']);
    model.result.export('data3').set('location', 'grid');
    model.result.export('data3').set('gridx2', '-1e-6');
    model.result.export('data3').set('gridy2', 'range(0,0.001,1)');
    model.result.export('data1').run;
    model.result.export('data2').run;
    model.result.export('data3').run;
end




out = model;
