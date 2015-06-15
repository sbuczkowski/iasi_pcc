function data  = iasi_pcc_from_netcdf(infile)
% IASI_PCC_FROM_NETCDF read IASI principal component radiance data
%
% 

% initialize empty data structure to store values for output
data = struct;

% read in eigenvector data
%********** This is very likely an unnecessary duplication of
%********** effort when processing multiple files. 
IASI_PCC_DIR = '/asl/data/IASI/PCC';
EVEC_FILE_BAND = {};
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

% read attributes from pcc file
dattr = {'eps_name', 'spacecraft_id', 'instrument_id', ...
         'process_version', 'state_vector_time'};
% write out to file as netcdf attribute
for i=1:length(dattr)
    temp = ncreadatt(infile,'/', dattr{i});
    data = setfield(data, dattr{i}, temp);
    clear temp;
end

% read non-radiance data from pcc file
dfname = {'Time2000', 'Latitude', 'Longitude','Satellite_Height', ...
          'Satellite_Zenith','Satellite_Azimuth','Solar_Zenith', ...
          'Solar_Azimuth','Scan_Direction','Scan_Line','AMSU_FOV', ...
          'IASI_FOV','GQisFlagQual','Avhrr1BLandFrac', ...
          'Avhrr1BCldFrac','Avhrr1BQual','ImageLat','ImageLon', ...
          'IASI_Image'};
for i=1:length(dfname)
    temp = ncread(infile, dfname{i});
    data = setfield(data, dfname{i}, temp);
    clear temp;
end

% read pcscores from pcc file
pcsfields = {'Band1' 'Band2', 'Band3'};
for i=1:length(pcsfields)
    temp = ncread(infile, ['/Evecs/' pcsfields{i} '/pcscores']);

    % convert pcscores back to radiance space
    rdata(i).rad = iasi_reconstruct_radiances(temp, eigendata(i));
end

% reformat data for output
data = setfield(data, 'IASI_Radiances', [rdata(1).rad', rdata(2).rad', rdata(3).rad']);

%% ****end function iasi_pcc_from_netcdf****