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

addpath(genpath('/asl/rtp_prod/iasi'))

% Read in EUMETSAT eigenvector data
eigendata = iasi_pcc_read_all_eigenvectors();

% Read the IASI datafile
data = readl1c_epsflip_all(infile);
rad = data.IASI_Radiances;
radsize = size(rad);
rrad = reshape(rad, radsize(1)*radsize(2), radsize(3));

% reformat the radiance data and split it into bands
% *** At this point we have radiance in two forms (radiance/rrad)
%     which is unneccesary. This should be refactored ***
radiances = iasi_split_bands(data);

% create pc scores from radiances eignevectors
cdata = iasi_pcc_create_all_pcscores(radiances, eigendata);

keyboard
% write pcc data out to netcdf file
iasi_pcc_to_netcdf(outfile, data, cdata)

% calculate reconstruction bias stats and report back to calling
% routine
[mean_bias, bias_std, fchan] = iasi_pcc_recon_summary(cdata, rrad, eigendata);

%% ****end function iasi_pcc_compress_granule****
