classdef Gaussian < Base
    %GAUSSIAN Summary of this class goes here
    %   Detailed explanation goes here

    properties
        config
        Ehf         % Hartree Fock Energy
        Etot        % Total Energy (same as Hf if method = HF)
        mulliken    % Mulliken charges for atoms
        MP2         % MP2 Energy
        Z           % Atom number
        Eorb        % Orbital Energies
        rcart       % cartesian coordinates
        dipole      % Dipole
        densities   % SCF densities
        Nelectrons
        orb
        overlap
        shellTypes
        atom
        type
        subtype
        Ees
        Ef
        Ecomp
        charge
        multiplicity
        keywords
    end
    methods
        function obj = Gaussian(dataPath, template, params)
           obj = obj@Base(dataPath, template, params);
        end
        function run(obj)
            warning('off', 'MATLAB:DELETE:FileNotFound');
            g09exe = 'C:\G09W\g09.exe';
            gaussianPath = 'C:\G09W';

            tpl_file = [obj.dataPath, obj.template,'.tpl'];
            filetext = fileread(tpl_file);

            out_file = [obj.dataPath, obj.filename, '.out'];
            log_file = [obj.dataPath, obj.filename, '.log'];
            gjf_file = [obj.dataPath, obj.filename, '.gjf'];
            fch_file = [obj.dataPath, obj.filename, '.fch'];
            chk_file = [obj.dataPath, obj.filename, '.chk'];

            fid2 = fopen(log_file,'r');
            if (fid2==-1)
                fid2 = fopen(out_file,'r');
            end
            if (fid2 == -1)
                f = fieldnames(obj.params);
                for i=1:length(f)
                    x = f{i};
                    filetext = strrep(filetext, x, obj.params.(x){1});
                end

                fid1 = fopen(gjf_file,'w');
                fwrite(fid1, filetext, 'char');
                fclose(fid1);
                qmatlab = pwd; 
                
                disp(['about to do: ',g09exe,' ',gjf_file,' ',log_file]);
                setenv('GAUSS_EXEDIR',gaussianPath);

                resp1 = 1; resp2 = 1;
                while ( resp1 ~= 0 || resp2 ~= 0 )
  
                    try
                        resp1 = obj.runGaus(obj.filename,obj.dataPath);
                        % convert checkpoint file to a formatted checkpoint file
                         cd(obj.dataPath);
                        try
                            resp2 = system([gaussianPath,'\formchk.exe ',chk_file, ' ', fch_file]);
                        catch
                            resp2 = system([gaussianPath,'\formchk.exe ','temp.chk ', fch_file]);
                        end
                        if( resp2 == 2057 )
                           resp2 = system([gaussianPath,'\formchk.exe ','temp.chk ', fch_file]);
                        end
                        if ( resp1 == 2057 )
                            disp( '  removing temporary files' );
                            delete( 'fort.6', 'gxx.d2e', 'gxx.inp', 'gxx.int', 'gxx.scr', ...
                                'temp.chk', 'temp.fch', 'temp.rwf', chk_file)
                        end
                    catch
                        disp( 'Failed, retrying...' );
                        resp1 = 1; resp2 = 1;
                    end
                    cd(qmatlab);
                end
            end
            parse(obj);
            delete('temp.chk', 'fort.*', chk_file);
            fclose('all');
        end
    end
end

