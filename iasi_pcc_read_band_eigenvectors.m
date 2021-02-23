function eigendata = iasi_pcc_read_band_eigenvectors(Evec_File)
% IASI_PCC_READ_BAND_EIGENVECTORS read an IASI eigenvector file
%
%
% INPUTS:
% Evec_File -> string : path to EUMETSAT eigenvector file
%
% OUTPUTS:
% eigenvectors -> double array : nchans x neigenvectors
% mean -> double array : nchans x 1
% noise -> double array : nchans x 1
%

NOISE_SCALE = 1E5;

fprintf(1, '>>> Reading in IASI eigenvector file\n');

eigendata.eigenvectors = h5read(Evec_File, '/Eigenvectors');
eigendata.mean = h5read(Evec_File, ...
                    '/Mean');
% IASI stored noise values are scaled 
eigendata.noise = NOISE_SCALE.*h5read(Evec_File, ...
                     '/Nedr');

% placeholder for eigenvector limit
eigendata.endoffset = 0;

%% ****end function iasi_pcc_read_band_eigenvectors****