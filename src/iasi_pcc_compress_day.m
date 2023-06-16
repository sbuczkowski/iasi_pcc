function iasi_pcc_compress_day(indir)
% IASI_PCC_COMPRESS_DAY compress all granules for given day
%
% 

% uncompressed data comes from /asl/data/IASI/L1C/... and the
% compressed files will go to /asl/data/IASI/PCC/... so, edit the
% directory for output then create the directory 
outdir = strrep(indir, 'L1C', 'PCC');
mkdir(outdir);

% There are, in some cases, granule files for two separate IASI
% platforms (M01 and M02). Here, we will treat them separately for
% the purposes of maintaining summaries
platform={'M01','M02'};

for i=1:2  % loop over platforms
    % get list of granule files for given day
    granules = dir([indir '/IASI_*_' platform{i} '_*']);

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
                infile = fullfile(indir, name);
                outfile = fullfile(outdir, [name '.pcc']);
                [mean_bias, bias_std, fchan] = iasi_pcc_compress_granule(infile, outfile);

                % store granule stats in summary data arrays
                granule_means(j,:) = mean_bias;
                granule_sigmas(j,:) = bias_std; 

                % whether infile was compressed to start or, not, compress
                % it now (no need to wait for the process to finish)
                system(['gzip ' infile]);
                
        end  % end for loop over granule files
             % save summary stats for current platform
            summaryfile = fullfile(outdir, ...
                                   [platform{i} '_recon_summary.mat']);
            save(summaryfile, 'fchan', 'granule_means','granule_sigmas');
    end  % end if length(granules)
end  % end for loop over platforms
    
%% ****end function iasi_pcc_compress_day****