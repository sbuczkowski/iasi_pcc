function [cdata, data] = iasi_pcc_compress_granule(infile, eigendata, outfile)
% IASI_PCC_COMPRESS_GRANULE compress IASI granule by Principal Components
%
% INPUTS
% infile : input IASI rganule file
% eigendata : v201 reconstruction operator as read by iasi_pcc_read_all_eigenvectors
% outfile : output IASI pcc granule file (or 'NULL' for CL use/testing)

% OUTPUTS
% data : IASI granule data structure from readl1c_epsflip_all
% cdata : pcscores calculated for radiances in data
%
% REQUIRES
% readl1c_epsflip_all from rtp_prod2/iasi/readers
funcname='iasi_pcc_compress_granule';

% Read the IASI datafile
fprintf(1, '> %s: Read IASI granule %s\n', funcname, infile)
data = readl1c_epsflip_all(infile);

% reformat the radiance data and split it into bands
radiances = iasi_split_bands(data);

% create pc scores from radiances eignevectors
cdata = iasi_pcc_create_all_pcscores(radiances, eigendata);

% if no output is requested, just return 
if strcmp('NULL', outfile)
    return
end

% write pcc data out to netcdf file
fprintf(1, '> %s: Write compressed IASI granule %s\n', funcname, outfile)
iasi_pcc_to_netcdf(outfile, data, cdata)

%% ****end function iasi_pcc_compress_granule****
