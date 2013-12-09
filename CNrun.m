clear classes
% This is a test of running just one molecule
% cd('..');
%%
qmatlab = pwd;
molecule = {'CN5', 'CN7', 'CN9', 'CN11'};
methods = {'td b3lyp', 'td cam-b3lyp'};
for imet = 1:length(methods)
params.METHOD = {methods{imet}, 1};
params.BASIS = {{'aug-cc-pVTZ'}, 1};
for imol = 1:length(molecule)
c = Controller(fullfile(qmatlab, 'CN\'), molecule{imol}, params, @Gaussian);
c.runAll();

result(imet,imol) = c.outputs{1};
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