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

% noise and mean are global measures from the EUMETSAT training
% set. Each one dimensional array has to replicated to match the
% number of spectra being processed in order to vectorize processing
mNoise = repmat(eigendata.noise,1,nspectra);
mMean = repmat(eigendata.mean,1,nspectra);

% apply noise correction and mean subtraction to base radiances and
% project spectra into the truncated pca eigenspace
pcscores = (radiances./mNoise - mMean)' * eigendata.eigenvectors;


%% ****end function iasi_calculate_pcscores****