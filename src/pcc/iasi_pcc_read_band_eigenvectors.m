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
Eversion = 'v201';

NOISE_SCALE = 1E5;

fprintf(1, '>>> Reading in IASI eigenvector file\n');

eigendata.eigenvectors = h5read(Evec_File, '/Eigenvectors');
eigendata.mean = NaN;

% IASI stored noise values are scaled 
eigendata.noise = NOISE_SCALE.*h5read(Evec_File, ...
                     '/Nedr');

% v201 introduces a 'ReconstructionOperator' which is just the product
% of the eigenvector and noise and can be used directly (really, we
% only need to read and use this)
% **NOTE**: matlab reads this in as transpose(R) not, R
eigendata.ro = NOISE_SCALE .* h5read(Evec_File, '/ReconstructionOperator');

% placeholder for eigenvector limit
eigendata.endoffset = 0;

%% ****end function iasi_pcc_read_band_eigenvectors****
