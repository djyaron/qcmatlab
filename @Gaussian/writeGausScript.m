function GausScript = writeGausScript(obj, dir )
    
    newLine = char(10);
    if ispc
        GausScript = fullfile(dir,'runGaus.bat');
        text = ['C:\G09W\g09.exe %1.gjf %1.out', newLine, ...
            'COPY /Y NUL %1.done', newLine, 'EXIT'];
    else
        GausScript = fullfile(dir,'runGaus.sh');
        text = ['#!/bin/bash', newLine, ...
            'g09root=/home/ljn;GAUSS_SCRDIR=$g09root/g09/scratch;', newLine, ...
            'export g09root GAUSS_SCRDIR;. $g09root/g09/bsd/g09.profile;', newLine, ...
            '/home/ljn/g09/g09 $1.gjf $1.out', newLine, ...
            'touch $1.done'];
    end
    fID = fopen( GausScript, 'w' );

    fprintf( fID, '%s', text);
    fclose( fID );
end