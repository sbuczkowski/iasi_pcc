function radiances = iasi_reconstruct_radiances(pcscores, eigendata)
% IASI_RECONSTRUCT_RADIANCES uncompress IASI radiance data
% 
% Reconstruct IASI radiance data from the EUMETSAT-derived pca
% eigenspace
%
% INPUTS:
% pcscores -> double array : nspectra x neigenvectors
% eigenvectors -> double array : nchans x neigenvectors
% mean -> double array : nchans x 1
% noise -> double array : nchans x 1
%
% OUTPUTS:
% radiances -> double array : nchan x nspectra

fprintf(1, '>>> Reconstructing radiances from compressed pca scores\n');

[nspectra, nevigenvectors] = size(pcscores);

% noise and mean are global measures from the EUMETSAT training
% set. Each one dimensional array has to replicated to match the
% number of spectra being processed in order to vectorize processing
mNoise = repmat(eigendata.noise, 1, nspectra);
mMean = repmat(eigendata.mean, 1, nspectra);

% project the pcscores back into the radiance space, add back the
% EUMETSAT training set mean and noise normalize
radiances = ((eigendata.eigenvectors * pcscores') + mMean) .* mNoise;


%% ****end function iasi_reconstruct_radiances****