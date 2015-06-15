function iasi_pcc_compress_granule(infile, outfile)
% IASI_PCC_COMPRESS_GRANULE compress IASI granule by Principal Components
%
% 

addpath(genpath('/asl/rtp_prod/iasi'))
addpath(genpath('/asl/matlib/'))

IASI_DIR = '/asl/data/IASI';
IASI_PCC_DIR = fullfile(IASI_DIR, 'PCC');
EVEC_FILE_BAND = {};


fprintf(1, '>>> Reading in eigenvector files\n');
% $$$ Band 1 channel# 0 to 1996 (1997) Band 1: 645.00 – 1144.00 cm-1
EVEC_FILE_BAND{1} = ...
    'IASI_EV1_xx_M02_20110125000000Z_xxxxxxxxxxxxxxZ_20110119000104Z_xxxx_xxxxxxxxxx';

% $$$ Band 2 channel# 1997 to 5115 (3119) Band 2: 1144.25 - 1923.75 cm-1
EVEC_FILE_BAND{2} = ...
    'IASI_EV2_xx_M02_20110125000000Z_xxxxxxxxxxxxxxZ_20110119000104Z_xxxx_xxxxxxxxxx';

% $$$ Band 3 channel# 5116 to 8460 (3345) Band 3: 1924.00 – 2760.00 cm-1
EVEC_FILE_BAND{3} = ...
    'IASI_EV3_xx_M02_20110125000000Z_xxxxxxxxxxxxxxZ_20110119000104Z_xxxx_xxxxxxxxxx';

for band=1:3
    eigendata(band) = iasi_read_eigenvectors(fullfile(IASI_PCC_DIR, ...
                                                      EVEC_FILE_BAND{band}));
end

% Read the IASI datafile
data = readl1c_epsflip_all(infile);

% reformat the radiance data and split it into bands
radiances = iasi_split_bands(data);

% create pc scores from radiances eignevectors
fprintf(1, '>>> Create PCscores for radiance file\n');
for band=1:3
    cdata(band).pcscores = iasi_calculate_pcscores(radiances(band).rad, ...
                                                  eigendata(band));
end


% write pcc data out tp netcdf file
iasi_pcc_to_netcdf(outfile, data, cdata)

%% ****end function iasi_pcc_compress_granule****
