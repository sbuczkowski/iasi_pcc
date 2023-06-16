function pcscores = iasi_calculate_pcscores(radiances, eigendata)
% IASI_CALCULATE_PCSCORES compress IASI radiance data 
%
% Calculate principal component scores of IASI radiance data in the
% EUMETSAT-derived pca eigenspace to alow for data storage
% compression
%
% *** THIS IS A LOSSY COMPRESSION ***
%
% INPUTS:
% radiances -> double array : nchan x nspectra
% eigendata -> struct
%
% OUTPUTS:
% pcscores -> double array : nspectra x neigenvectors

fprintf(1, '>>> Creating PCscores for radiance file\n');


[nchan,nspectra] = size(radiances);

% project spectra into the truncated pca eigenspace with Reconstruction Operator
pcscores = eigendata.ro \ radiances;


%% ****end function iasi_calculate_pcscores****
