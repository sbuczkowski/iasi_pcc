function [data, eigendata] = iasi_pcc_uncompress_granule(infile)
% IASI_PCC_UNCOMPRESS_GRANULE read IASI principal component radiance data
%
% 

% initialize empty data structure to store values for output
data = struct;

% read in eigenvector data
eigendata = iasi_pcc_read_all_eigenvectors();

% read attributes from pcc file
dattr = {'eps_name', 'spacecraft_id', 'instrument_id', ...
         'process_version', 'state_vector_time'};

% read from file as netcdf attribute
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

% generate SNR stats for reconstruction
snr = -999;

% reformat data for output
data = setfield(data, 'IASI_Radiances', [rdata(1).rad', rdata(2).rad', rdata(3).rad']);

%% ****end function iasi_pcc_uncompress_granule****