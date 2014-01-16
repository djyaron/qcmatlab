function terminated = runGaus(obj, jobname, tempDir)
    %Run Gaussain with .bat/.sh file and has a timeout built in (when used)
    %Code should be backwards compatible
    %Need to do something about var named terminated

    GausScript = writeGausScript( tempDir );
    startTime = clock;
    timeOut = obj.config.timeOut; % seconds
    if ispc
        launchBat([GausScript,' ', ...
            fullfile(tempDir,jobname), ' &'] );
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