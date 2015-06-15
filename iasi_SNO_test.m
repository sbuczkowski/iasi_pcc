addpath(genpath('/asl/rtp_prod/iasi'))
addpath(genpath('/asl/matlib/'))

IASI_PCC_DIR = '/asl/data/IASI/PCC';
EVEC_FILE_BAND = {};

% $$$ struct eigendata;    % eigenvector related datastruct
% $$$ struct cdata;        % compressed datastruct
% $$$ struct rdata;        % reconstructed radiance datastruct 

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


fprintf(1, '>>> Reading in sample IASI data file\n');
%% read in an IASI data file
% 2013/12/27
iasidir = '/asl/data/IASI/L1C/2013/12/27/';

iasifiles = dir(fullfile(iasidir, 'IASI_xxx_1C_M0*'));
% $$$ nfiles = numel(iasifiles);
nfiles=1;

for k=1:nfiles

    % Read the IASI datafile
    data = readl1c_epsflip_all(fullfile(iasidir, iasifiles(k).name));
    keyboard
    % reformat the radiance data and split it into bands
    radiances = iasi_split_bands(data);

    % create pc scores from radiances eignevectors
    fprintf(1, '>>> Create PCscores for radiance file\n');
    for band=1:3
        cdata(band).pcscores = iasi_calculate_pcscores(radiances(band).rad, ...
                                                       eigendata(band));
    end
    keyboard
    % loop over range of eigenvectors to drop from reconstruction
    % reconstruct radiances
    fprintf(1, '>>> Reconstruct radiances\n');
    for band=1:3
        rdata(band).rad = iasi_reconstruct_radiances(cdata(band).pcscores, ...
                                                     eigendata(band));

    end

    % concatenate split bands
    rrads = [rdata(1).rad; rdata(2).rad; rdata(3).rad];

    % remove radiance from the IASI data struct
    fields = {'eps_name', 'process_version', 'state_vector_time', 'Satellite_Height', 'Satellite_Zenith', 'Satellite_Azimuth', 'Scan_Direction', 'Scan_Line', 'AMSU_FOV', 'Avhrr1BLandFrac', 'Avhrr1BCldFrac', 'Avhrr1BQual', 'ImageLat', 'ImageLon', 'IASI_Image', 'IASI_Radiances'}

    data = rmfield(data, fields);

    save(fullfile(IASI_PCC_DIR, 'SNO_test', [iasifiles(k).name ...
                        '.mat']), 'rrads', 'data');
end