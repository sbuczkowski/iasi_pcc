function cdata = iasi_pcc_create_all_pcscores(radiances, eigendata)
% IASI_PCC_CREATE_ALL_PCSCORES 
%
% 

fprintf(1, '>>> Create PCscores for radiance \n');
for band=1:3
    cdata(band).pcscores = iasi_calculate_pcscores(radiances(band).rad, ...
                                                  eigendata(band));
end


%% ****end function iasi_pcc_create_all_pcscores****