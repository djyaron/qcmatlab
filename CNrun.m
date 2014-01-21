clear classes
% This is a test of running CN5, CN7, CN9, CN11
% cd('..');b
%%
ic =1;
qmatlab = pwd;
molecule = {'CN5_td','CN7_td', 'CN9_td', 'CN11_td'};
methods = {{'b3lyp'}, {'cam-b3lyp'}, {'M06-HF'}};
basis = {{'6-31g'}, {'6-31g(d)'}, {'6-31g(d,p)'}};
for imet = 1:length(methods)
params.METHOD = {methods{imet}, 1};
for ibas = 1:length(basis)
params.BASIS = {basis{ibas}, 1};
for imol = 1:length(molecule)
c = Controller(fullfile(qmatlab, 'CN\'), molecule{imol}, params, @Gaussian);
c.runAll();
result(ic) = c.outputs{1};
ic = ic+1;
end
end
end
cd(qmatlab);


%% INDO Test
qmatlab = pwd;
template = {'CN5_PBE0_g', 'CN7_PBE0_g', 'CN9_PBE0_g', 'CN11_PBE0_g'};
config.charge = {{1}};
config.norbs = {{100}};
config.nstates = {{25}};
config.field = {{[0,0,0]}};
config.potfile = {{''}};
for itemp = 1:length(template);
parameterFile = fullfile(qmatlab, 'CN\parameters.txt');
c = Controller(fullfile(qmatlab, 'CN\'), template{itemp},config, @Indo, parameterFile);

c.runAll;
indo_result(itemp) = c.outputs{1};
end 
%%
for i = 1:4
indo_result(i).esci(1)-indo_result(i).esci(2)
end