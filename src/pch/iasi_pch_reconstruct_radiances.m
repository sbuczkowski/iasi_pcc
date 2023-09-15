function [rad, ancillary] = iasi_pch_reconstruct_radiances(pch_file)
% IASI_PCH_RECONSTRUCT_RADIANCES
%
% Reconstruct radiances from EUMETSAT IASI hybrid pc files
%
% INPUTS:
%      pch_file : path to pch hdf5 granule file
%
% OUTPUT:
%      rad       : radiance array
%      ancillary : struct with ancillary data (lat,lon,satzen,etc)
%
% NOTE:: this routine is structured for granule testing purposes and
%      WILL NOT BE EFFICIENT for larger scale work due to internal,
%      repetitive eigenfile reads (An efficient set of routines is
%      being written for larger scale work)
%
% Written 9/14/2023 Steven Buczkowski
    
    pc_eigenvector_path = '/home/sbuczko1/Work/IASI/PCH/global_pc';
    SCALE = 1e5; % scale from Wm-2sr-1(m-1)-1 to mWm-2sr-1(cm-1)-1
    
    %% read ancillary granule data
    ancillary = struct();
    S = h5info(pch_file, '/');
    for i =1:length(S.Datasets)
        ancillary.(S.Datasets(i).Name) = h5read(pch_file, sprintf('/%s',S.Datasets(i).Name));
    end

    rad = struct();
    %% read pc scores and eigenvectors
    for i =1:3  % 3 IASI bands
        % global eigenvectors
        eigenfile = fullfile(pc_eigenvector_path, h5readatt(pch_file, S.Groups(i).Name, 'PCC_BasisFile'));
        global_eigen = iasi_pch_read_band_eigenvectors(eigenfile);

        % local eigenvectors
        local_eigen = struct();
        local_eigen.ro =  h5read(pch_file, sprintf('%s/%s', S.Groups(i).Name, S.Groups(i).Datasets(1).Name));
        
        % global pc scores
        p_global = double(h5read(pch_file, sprintf('%s/%s', S.Groups(i).Name, S.Groups(i).Datasets(4).Name)));
        p_global_scale = h5readatt(pch_file, sprintf('%s/%s', S.Groups(i).Name, 'p'), 'scale_factor');
        
        % local pc scores
        p_local = double(h5read(pch_file, sprintf('%s/%s', S.Groups(i).Name, S.Groups(i).Datasets(5).Name)));
        p_local_scale = h5readatt(pch_file, sprintf('%s/%s', S.Groups(i).Name, 'p_local'), 'scale_factor');


        % compute radiance for band
        band = S.Groups(i).Name(2:end);
        rad.(band) = SCALE .* (pagemtimes(global_eigen.ro, (p_global * p_global_scale)) + ...
                               pagemtimes(local_eigen.ro, (p_local * p_local_scale)));
    end

    
end

