clear clear classes
% This is a test of running just one molecule
% Remeber that the directory has to always be the qcmatlab
% cd('..');
%%
qmatlab = pwd;
par = {'0','10','20','30','40','50','60','70','80','90'};
for imol = 1:length(par)
params.ADD = {{'opt'}, 1};
params.METHOD = {{'b3lyp'}, 1};
params.PAR= {{par{imol}}, 1};

c = Controller(fullfile(qmatlab, 'CRE\'), 'CREtor', params, @Gaussian);
c.runAll();

result{imol,imet} = c.outputs{1};
exc1(imol,imet) = result{imol,imet}.Ees(1);
cd(qmatlab);

end

%% Exprimental

abs = [502 516 512 509 492 496 526]';
Enm = 1240./exc1;

DiffE(:,1) = Enm(1,1)-Enm(:,1);
DiffE(:,2) = Enm(1,2)-Enm(:,2);
DiffE(:,3) = Enm(1,3)-Enm(:,3);





