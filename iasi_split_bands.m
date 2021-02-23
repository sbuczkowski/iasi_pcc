function radiances = iasi_split_bands(data)
% IASI_SPLIT_BANDS split IASI radiance full spectrum into pcc bands 1-3
%
% INPUT:
% data -> struct array (from readl1c_epsflip_all() )
%
% OUTPUT:
% radiances -> struct array :
%                     elements:
%                         BandIndices : double nchans x 1
%                         rad : double nchans x nspectra

NPIXFOV = 4;    % number of IASI "pixels" per FOV (ie 2x2 = 4)
NCHAN   = 8461; % number of IASI channels

% $$$ Band 1 channel# 0 to 1996 (1997) Band 1: 645.00 – 1144.00 cm-1
% $$$ Band 2 channel# 1997 to 5115 (3119) Band 2: 1144.25 - 1923.75 cm-1% $$$ Band 3 channel# 5116 to 8460 (3345) Band 3: 1924.00 – 2760.00 cm-1
BANDSPLIT = [1144.0, 1923.75]; % band wavenumber interior boundaries

% get number of FOVs in IASI data collection
[nax,ii] = size(data.Latitude);

% get number of obs (4 obs per FOV)
nobs = round( nax*NPIXFOV );     % exact integer

% IASI channel info
fchan = (645:0.25:2760)'; %' [8461 x 1]

%*** recast in array form
% $$$ struct radiances;
radiances(1).BandIndices = find(fchan <= BANDSPLIT(1));
radiances(2).BandIndices = find(fchan > BANDSPLIT(1) & fchan <= BANDSPLIT(2));
radiances(3).BandIndices = find(fchan > BANDSPLIT(2));


fprintf(1, '>>> Reformat radiance array\n');
% Pull out IASI radiances and then reformat and transpose
rad = reshape(data.IASI_Radiances,nobs,NCHAN)'; 

for band=1:3
    %*** recast in array form
    radiances(band).rad = rad(radiances(band).BandIndices, :);
    radiances(band).chans = fchan(radiances(band).BandIndices);
end


%% ****end function iasi_split_bands****