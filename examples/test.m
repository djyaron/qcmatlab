%clear classes
% This is a test of running just one molecule
cd('..');
%%
qmatlab = pwd;

params.METHOD = {{'mp2'}, 1};
params.BASIS = {{'6-21G'}, 1};

c = Controller(fullfile(qmatlab, 'testdat\'), 'h2', params, @Gaussian);
c.runAll();

cd(qmatlab);

%% Ampac Test
qmatlab = pwd;

params.METHOD = {{'sam1'}, 1};
% params.PAR1 = {{1.0000}, 1};
% params.PAR2 = {{1.2000}, 1};

c = Controller(fullfile(qmatlab, 'testdat\'), 'ch4', params, @Ampac);
c.runAll()
aOut = c.outputs{1};

%% INDO Test
qmatlab = pwd;
dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
template = 'CRE_pcm';
config.charge = {{1}};
config.norbs = {{100}};
config.nstates = {{25}};
config.field = {{[0,0,0]}};
config.potfile = {{''}};
parameterFile = 'C:\Users\Matteus\Qmatlab\testdat\parameters.txt';
c = Controller(fullfile(qmatlab, 'testdat\'), template,config, @Indo, parameterFile);

c.runAll; 
 