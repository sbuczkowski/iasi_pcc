function iasi_pcc_to_netcdf(outfile, data, pcsdata)
% IASI_PCC_TO_NETCDF 
%
% 

% initialize output netcdf file
%ncwriteatt(outfile,'/','creation_date',datestr(now));
nccreate(outfile, 'Creation_Date', 'Format', 'netcdf4');
% break data struct into individual variables and write to output
% file
%********** Current IASI data structure format **********
% $$$              eps_name: 'IASI_xxx_1C_M01_20131227000254Z_20131227000557Z'
% $$$         spacecraft_id: 'M01'
% $$$         instrument_id: 'IASI'
% $$$       process_version: 7
% $$$     state_vector_time: 441410843
% $$$              Time2000: [690x4 double]
% $$$              Latitude: [690x4 double]
% $$$             Longitude: [690x4 double]
% $$$      Satellite_Height: [690x4 double]
% $$$      Satellite_Zenith: [690x4 double]
% $$$     Satellite_Azimuth: [690x4 double]
% $$$          Solar_Zenith: [690x4 double]
% $$$         Solar_Azimuth: [690x4 double]
% $$$        Scan_Direction: [690x4 double]
% $$$             Scan_Line: [690x4 double]
% $$$              AMSU_FOV: [690x4 double]
% $$$              IASI_FOV: [690x4 double]
% $$$          GQisFlagQual: [690x4 double]
% $$$       Avhrr1BLandFrac: [690x4 double]
% $$$        Avhrr1BCldFrac: [690x4 double]
% $$$           Avhrr1BQual: [690x4 double]
% $$$              ImageLat: [690x25 double]
% $$$              ImageLon: [690x25 double]
% $$$            IASI_Image: [690x4096 double]
% $$$        IASI_Radiances: [690x4x8461 double]
%**********
datafields = fieldnames(data);

for i=1:length(datafields)

    % a few elements of the data struct are general attributes so,
    % let's record them as such in the output file
    switch datafields{i}
      case 'IASI_Radiances'
        % should remove this field before calling this routine but,
        % in case it is still here, don't write it out
        continue
      case {'eps_name', 'spacecraft_id', 'instrument_id', ...
            'process_version', 'state_vector_time'}
        % write out to file as netcdf attribute
        ncwriteatt(outfile,'/', datafields{i}, getfield(data, ...
                                                        datafields{i}));
        continue
      case {'ImageLat', 'ImageLon'}
        % This case and next are written as netcdf data
        % variables. This section sets up name attributes for data dimensions
        colnames = {'nscans', 'c'};
        continue
      case {'IASI_Image'}
        colnames = {'nscans', 'width'};
        continue
      otherwise
        colnames = {'nscans', 'nfovs'};
    end

    dtemp = getfield(data, datafields{i});
    dsize = size(dtemp);
    nccreate(outfile, datafields{i}, 'Dimensions', {colnames{1}, dsize(1), ...
                        colnames{2}, dsize(2)}, 'Format', 'netcdf4', ...
             'DeflateLevel', 9);
    ncwrite(outfile, datafields{i}, dtemp);
    clear dtemp;
    
end


% break pcscores struct array into individual variables and write to
% output file
pcsfields = {'Band1', 'Band2', 'Band3'};
for i=1:length(pcsfields)
    dsize = size(pcsdata(i).pcscores);
    dtemp = reshape(pcsdata(i).pcscores, dsize(1)/4, 4, dsize(2));
    nccreate(outfile, ['/Evecs/' pcsfields{i} '/pcscores'], ...
             'Dimensions', {'nobs', dsize(1)/4, 'nfovs', 4, 'nevecs', ...
                        dsize(2)}, 'Format', 'netcdf4', 'DeflateLevel', 9);
    ncwrite(outfile, ['/Evecs/' pcsfields{i} '/pcscores'], dtemp);
end


%% ****end function iasi_pcc_to_netcdf****