function terminated = runGaus(obj, jobname, tempDir)
    %Run Gaussain with .bat/.sh file and has a timeout built in (when used)
    %Code should be backwards compatible
    %Need to do something about var named terminated

    GausScript = obj.writeGausScript( tempDir );
    startTime = clock;
    timeOut = -1; % seconds
    if ispc
       qmatlab = pwd;
       cd(tempDir)
        obj.launchBat([GausScript,' ', ...
            fullfile(tempDir,jobname), ' &'] );
         cd(qmatlab)
    else
        system(['chmod +x ', GausScript]);
        system( [GausScript, ' ', fullfile(tempDir,jobname), ' &'] );
    end
    terminated = 0;
    while exist( [tempDir, filesep, jobname, '.done'], 'file' ) == 0
        pause( 5 );
        if timeOut ~= -1 && timeCheck( startTime, timeOut )
            if ispc
                system('TASKKILL /IM g09.exe /F');
            else
                system('killall g09');
            end
            terminated = 1;
            break
        end
    end

    delete(GausScript);
end

function bool = timeCheck( start, timeOut )
    %Returns 0 or 1 for if the current time (clock) is more than timeOut 
    %seconds after start
    if timeOut == -1
        bool = 0;
    else
        bool = etime( clock, start ) > timeOut;
    end
end