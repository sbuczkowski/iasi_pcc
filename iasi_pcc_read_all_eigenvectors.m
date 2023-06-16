function eigendata = iasi_pcc_read_all_eigenvectors()
% IASI_PCC_READ_ALL_EIGENVECTORS 
%
% 
Eversion = 'v201';  % global eigenvectors are now instrument/platform agnostic

IASI_PCC_DIR = '/asl/iasi/pcc/eigen';
EVEC_FILE_BAND = {};

fprintf(1, '>>> Reading in eigenvector files\n');
% $$$ Band 1 channel# 0 to 1996 (1997) Band 1: 645.00 – 1144.00 cm-1
EVEC_FILE_BAND{1} = ...
    'IASI_EV1_xx_Mxx_20200131000000Z_xxxxxxxxxxxxxxZ_20200131000201Z_xxxx_xxxxxxxxxx';

% $$$ Band 2 channel# 1997 to 5115 (3119) Band 2: 1144.25 - 1923.75 cm-1
EVEC_FILE_BAND{2} = ...
    'IASI_EV2_xx_Mxx_20200131000000Z_xxxxxxxxxxxxxxZ_20200131000201Z_xxxx_xxxxxxxxxx';

% $$$ Band 3 channel# 5116 to 8460 (3345) Band 3: 1924.00 – 2760.00 cm-1
EVEC_FILE_BAND{3} = ...
    'IASI_EV3_xx_Mxx_20200131000000Z_xxxxxxxxxxxxxxZ_20200131000201Z_xxxx_xxxxxxxxxx';

for band=1:3
    eigendata(band) = iasi_pcc_read_band_eigenvectors(fullfile(IASI_PCC_DIR, ...
                                                      EVEC_FILE_BAND{band}));
end


%% ****end function iasi_pcc_read_all_eigenvectors****
