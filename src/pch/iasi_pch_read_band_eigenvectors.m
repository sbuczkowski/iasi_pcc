function eigendata = iasi_pch_read_band_eigenvectors(Evec_File)
% IASI_PCH_READ_BAND_EIGENVECTORS read an IASI eigenvector file
%
%
% INPUTS:
% Evec_File : path to EUMETSAT eigenvector file
%
% OUTPUTS:
% eigen_ro : reconstruction operator
% noise     : Nedr
%
Eversion = 'v201';

fprintf(1, '>>> Reading in IASI eigenvector file\n');

eigendata.eigenvectors = h5read(Evec_File, '/Eigenvectors');

% IASI stored noise values are scaled 
eigendata.noise = h5read(Evec_File, ...
                     '/Nedr');

% v201 introduces a 'ReconstructionOperator' which is just the product
% of the eigenvector and noise and can be used directly (really, we
% only need to read and use this)
% **NOTE**: matlab reads this in as transpose(R) not, R
eigendata.ro = h5read(Evec_File, '/ReconstructionOperator');

% placeholder for eigenvector limit
eigendata.endoffset = 0;

%% ****end function iasi_pch_read_band_eigenvectors****
