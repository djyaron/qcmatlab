clear clear classes
% This is a test of running just one molecule
% Remeber that the directory has to always be the qcmatlab
% cd('..');
%%
qmatlab = pwd;

molecules = {'to','to_cf3','to_ome','to_1f','to_4f','to_p2f','to_ome_cf3'};
methods = {'cam-b3lyp','pbe1pbe', 'm06hf'};
for imol = 1:length(molecules)
    for imet = 1:length(methods)
params.JOB1 = {{''}, 1};
params.JOB2 = {{'td'}, 1};
params.METHOD = {{methods{imet}}, 1};
params.BASIS = {{'6-311g(d,p)'}, 1};

c = Controller(fullfile(qmatlab, 'TO\'), molecules{imol}, params, @Gaussian);
c.runAll();

result{imol,imet} = c.outputs{1};
exc1(imol,imet) = result{imol,imet}.Ees(1);
cd(qmatlab);
    end
end

%% Exprimental

abs = [502 516 512 509 492 496 526]';
Enm = 1240./exc1;

DiffE(:,1) = Enm(1,1)-Enm(:,1);
DiffE(:,2) = Enm(1,2)-Enm(:,2);
DiffE(:,3) = Enm(1,3)-Enm(:,3);





