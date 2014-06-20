clear classes
% This is a test of running just one molecule
% Remeber that the directory has to always be the qcmatlab
% cd('..');
%%
qmatlab = pwd;
par = {'0.0','10.0','20.0','30.0','40.0','50.0','60.0','70.0','80.0','90.0'};
for imol = 1:length(par)
params.ADD = {{'opt'}, 1};
params.METHOD = {{'cam-b3lyp'}, 1};
params.PAR= {{par{imol}}, 1};

c = Controller(fullfile(qmatlab, 'CRE\'), 'CREtor', params, @Gaussian);
c.runAll();

result{imol} = c.outputs{1};
cd(qmatlab);

end


