function iasi_pcc_compress_granule(infile, outfile)
% IASI_PCC_COMPRESS_GRANULE compress IASI granule by Principal Components
%
% 

addpath(genpath('/asl/rtp_prod/iasi'))

% Read in EUMETSAT eigenvector data
eigendata = iasi_pcc_read_all_eigenvectors();

% Read the IASI datafile
data = readl1c_epsflip_all(infile);

% reformat the radiance data and split it into bands
radiances = iasi_split_bands(data);

% create pc scores from radiances eignevectors
cdata = iasi_pcc_create_all_pcscores(radiances, eigendata);

% write pcc data out to netcdf file
iasi_pcc_to_netcdf(outfile, data, cdata)

%% ****end function iasi_pcc_compress_granule****
