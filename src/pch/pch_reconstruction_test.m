addpath /home/sbuczko1/git/iasi_pcc/src/pch
addpath /home/sbuczko1/git/rtp_prod2/util  % rad2bt

pch_file = '/umbc/xfs2/strow/asl/s1/sbuczko1/Work/IASI/PCH/granules/M03/2023/087/IASI_PCH_1C_M03_20230328231153Z_20230328231457Z_N_O_20230329005341Z.h5'

load('/umbc/xfs2/strow/asl/s1/sbuczko1/Work/IASI/PCH/iasi_freq'); % vchan

[rad, ancillary] = iasi_pch_reconstruct_radiances(pch_file);

radl = cat(1, rad.band_1, rad.band_2, rad.band_3);
rradl = reshape(radl, 8461, 120*23);

rradl(rradl < 0) = NaN;
btl = real(rad2bt(vchan, rradl));

figure
plot(vchan, mean(btl,2))
title('M03 2023/087 PCH reconstructed radiances')
xlabel('wavenumber')
ylabel('BT (K)')
