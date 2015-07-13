function [mbias, bias_std, fchan] = iasi_pcc_recon_summary(cdata, rrad, eigendata)
% IASI_PCC_RECON_SUMMARY reconstruction bias statistics
%
% OUTPUTS
% mbias : average bias (by channel)
% bias_std : standard deviation of the bias (by channel)

fchan = (645:0.25:2760);

radsize = size(rrad);

% reconstruct radiances from pcc data
% *** structure design throughout iasi_pcc is getting unwieldy and
%     needs to be restructured ***
for band=1:3
    rdata(band).rad = iasi_reconstruct_radiances(cdata(band).pcscores, ...
                                             eigendata(band));
end
rrad_rec = [rdata(1).rad' rdata(2).rad' rdata(3).rad'];

% build noise figure from eigendata
noise1 = eigendata(1).noise';
noise2 = eigendata(2).noise';
noise3 = eigendata(3).noise';

noise = [noise1 noise2 noise3];

% noise is (1 x nchan) array so, replicate to make work with
% spectra more simply
rnoise = repmat(noise, radsize(1), 1);

% build bias (original radiance - reconstructed radiance normalized
% by EUMETSAT pcc training set noise figure)
bias = (rrad - rrad_rec)./rnoise;

% build channel by channel average bias
mbias = mean(bias);

% build channel by channel standard deviation in the bias
bias_std = std(bias);

%% ****end function iasi_pcc_recon_summary****