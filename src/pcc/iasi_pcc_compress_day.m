function iasi_pcc_compress_day(cfg)
% IASI_PCC_COMPRESS_DAY compress all granules for given day
%
% 

% uncompressed data comes from /asl/data/IASI/L1C/... and the
% compressed files will go to /asl/data/IASI/PCC/... so, edit the
% directory for output then create the directory 
outdir = strrep(cfg.indir, 'L1C', 'PCH');
mkdir(cfg.outdir);

% get list of granule files for given day
granules = dir(fullfile(cfg.indir, '/IASI_*'));

if (length(granules) > 0)  % only run if this platform actually
                           % has files
                           % loop over granule files within day
    for j=1:numel(granules)

        % some of the granule files have been gzipped and we need
        % to unzip them (this blocks until the unzip finishes
        % (should this be done externally on large-scale first?))
        [pathstr, name, ext] = fileparts(granules(j).name);
        if strcmp(ext, '.gz')
            gzgranule=fullfile(indir, granules(j).name);
            system(['gunzip ' gzgranule '; wait;']);
        end  % end if strcmp ...
        
        % run compression
        infile = fullfile(cfg.indir, name);
        outfile = fullfile(cfg.outdir, [name '.pcc']);
        [mean_bias, bias_std, fchan] = iasi_pcc_compress_granule(infile, outfile);

        % store granule stats in summary data arrays
        granule_means(j,:) = mean_bias;
        granule_sigmas(j,:) = bias_std; 

        % whether infile was compressed to start or, not, compress
        % it now (no need to wait for the process to finish)
        system(['gzip ' infile]);
        
    end  % end for loop over granule files
end  % end if length(granules)

%% ****end function iasi_pcc_compress_day****
