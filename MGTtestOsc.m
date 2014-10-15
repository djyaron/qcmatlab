s=dbstatus('-completenames');
save('myBreakpoints.mat', 's');
clear classes;
load('myBreakpoints.mat');
dbstop(s);
% This is a test of running just one molecule
% cd('..');
yfield = 1; % if 0 then it will do xfield instead
mag = 0.4;
qmatlab = pwd;
dataPath = [pwd,'\MGT\'];
% if exist(fullfile(dataPath,'mgt_OSCYfield.mat'),'file')
%     load(fullfile(dataPath,'mgt_OSCYfield.mat'))
% else
    % Ampac
    
  molecules = {'MGester','MGF1','MGF2','MGF3','MGF4'};
%     filename = {'MGT1','MGT2','MGT3','MGT4'};
    params.METHOD = {{'am1'}, 1};
    for j = 1:length(molecules)
        c = Controller(fullfile(qmatlab, 'MGT','MGF\'),molecules{j} , params, @Ampac);
        c.runAll()
        aOut{j} = c.outputs{1};
    end
    % INDO
    config.charge = {{1}};
    config.norbs = {{100}};
    config.nstates = {{25}};

    config.potfile = {{''}};
    
    
    for i = 1:length(molecules)
        if yfield  
        yfield = aOut{i}.r(:,22)-aOut{i}.r(:,11);
        yfu =yfield'/norm(yfield);
        yF = yfu*mag;
        config.field = {{yF}};
        else
        Ns = find(ismember(aOut{i}.element,'N'));
        xfield = aOut{i}.r(:,Ns(1))-aOut{i}.r(:,Ns(2));
        xfu = xfield'/norm(xfield);
        xF = xfu*mag;
        config.field = {{xF}};
        end
%         dataPathEnd = {'MGT1','MGT2','MGT3','MGT4'};
        currentDir = fullfile(dataPath,'MGF\');
        parameterFile = ([currentDir,'parameters.txt']);
        template = aOut{i}.filename;
        c = Controller(currentDir, template,config, @Indo, parameterFile);
        c.runAll;
        IOut{i} = c.outputs;
    end
%     save(fullfile(dataPath,'mgt_OSCYfield.mat'),'aOut','IOut')
% end

%% osc strength
for i = 1: length(IOut)
    mgt = IOut{i}{1};
    et = [1 2; 1 3];
    Ns = find(ismember(aOut{i}.element,'N'));
    xv = aOut{i}.r(:,Ns(1))-aOut{i}.r(:,Ns(2)); % have to doube check to see that the direction is right
    yv = aOut{i}.r(:,9)-aOut{i}.r(:,10);
    ux = xv/norm(xv)';
    uy =yv/norm(yv)';
    for it = 1:length(et)
        my(it,:) = reshape(IOut{i}{1}.r(et(it,1),et(it,2),:),[1 3]);
        myx(it,:) = (dot(my(it,:),ux)*ux)';
        myy(it,:) = (dot(my(it,:),uy)*uy)';
    end
    s1x = norm(myx(1,:));
    s2x = norm(myx(2,:));
    s1y = norm(myy(1,:));
    s2y = norm(myy(2,:));
    osc_s1x = s1x^2* (mgt.esci(2)-mgt.esci(1))
    osc_s2x = s2x^2* (mgt.esci(3)-mgt.esci(1))
    osc_s1y = s1y^2* (mgt.esci(2)-mgt.esci(1))
    osc_s2y = s2y^2* (mgt.esci(3)-mgt.esci(1))
    
    s1 = mgt.esci(2)-mgt.esci(1)
    s2 = mgt.esci(3)-mgt.esci(1)
    figure(1)
    hold on
    plot(i,s1,'rx')
    plot(i,s2,'ro')
    plot(i,s1,'bo','MarkerSize',osc_s1x*10+0.0001)
    plot(i,s2,'bo','MarkerSize',osc_s2x*10+0.0001)
    plot(i,s1,'gs','MarkerSize',osc_s1y*10+0.0001)
    plot(i,s2,'gs','MarkerSize',osc_s2y*10+0.0001)
end
