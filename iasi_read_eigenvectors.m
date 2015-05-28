function eigendata = iasi_read_eigenvectors(Evec_File)
% IASI_READ_EIGENVECTORS read an IASI eigenvector file
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
% $$$ struct eigendata;

fprintf(1, '>>> Reading in IASI eigenvector file\n');

eigendata.eigenvectors = h5read(Evec_File, '/Eigenvectors');
eigendata.mean = h5read(Evec_File, ...
                    '/Mean');
% IASI stored noise values are scaled 
eigendata.noise = NOISE_SCALE.*h5read(Evec_File, ...
                     '/Nedr');


%% ****end function iasi_read_eigenvectors****