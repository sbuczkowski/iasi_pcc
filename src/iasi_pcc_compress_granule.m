function [mean_bias, bias_std, fchan] = iasi_pcc_compress_granule(infile, outfile)
% IASI_PCC_COMPRESS_GRANULE compress IASI granule by Principal Components
%
% INPUTS
% infile : input IASI rganule file
% outfile : output IASI pcc granule file
%
% OUTPUTS
% bias : bias between input and reconstructed radiances in the
% principal component eigenspace (radiance / training set noise)
%
% bias_std : channel by channel standard deviation of the
% reconstruction bias
%
% REQUIRES
% readl1c_epsflip_all from rtp_prod2/iasi/readers
funcname='iasi_pcc_compress_granule';

% Read in EUMETSAT eigenvector data
fprintf(1, '> %s: Read eigenvectors\n', funcname)
eigendata = iasi_pcc_read_all_eigenvectors();

% Read the IASI datafile
fprintf(1, '> %s: Read IASI granule %s\n', funcname, infile)
data = readl1c_epsflip_all(infile);

% reformat the radiance data and split it into bands
radiances = iasi_split_bands(data);

% create pc scores from radiances eignevectors
cdata = iasi_pcc_create_all_pcscores(radiances, eigendata);

% write pcc data out to netcdf file
fprintf(1, '> %s: Write compressed IASI granule %s\n', funcname, outfile)
iasi_pcc_to_netcdf(outfile, data, cdata)

%% ****end function iasi_pcc_compress_granule****
