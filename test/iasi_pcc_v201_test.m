basedir = '/umbc/xfs2/strow/asl/s1/sbuczko1/Work/iasi';

granfile = fullfile(basedir, 'granules/M03/2023/090/IASI_PCH_1C_M03_20230331114153Z_20230331114456Z_N_O_20230331123048Z.h5');

load(fullfile(basedir, 'iasi_freq'));

PCCBasisFile1 = fullfile(basedir, 'global_pc', h5readatt(granfile, '/band_1', 'PCC_BasisFile'));
PCCBasisFile2 = fullfile(basedir, 'global_pc', h5readatt(granfile, '/band_2', 'PCC_BasisFile'));
PCCBasisFile3 = fullfile(basedir, 'global_pc', h5readatt(granfile, '/band_3', 'PCC_BasisFile'));

E1 = h5read(PCCBasisFile1, '/Eigenvectors');
E2 = h5read(PCCBasisFile2, '/Eigenvectors');
E3 = h5read(PCCBasisFile3, '/Eigenvectors');

N1 = h5read(PCCBasisFile1, '/Nedr');
N2 = h5read(PCCBasisFile2, '/Nedr');
N3 = h5read(PCCBasisFile3, '/Nedr');

R1 = h5read(PCCBasisFile1, '/ReconstructionOperator');
R2 = h5read(PCCBasisFile2, '/ReconstructionOperator');
R3 = h5read(PCCBasisFile3, '/ReconstructionOperator');

scale_factor = 0.5;
p1 = scale_factor * double(h5read(granfile, '/band_1/p'));
p2 = scale_factor * double(h5read(granfile, '/band_2/p'));
p3 = scale_factor * double(h5read(granfile, '/band_3/p'));

unit_conversion = 1e5; % pch is Wm-2sr-1 (m-1)-1, raw files are mWm-2sr-1 (cm-1)-1
%% global basis only (from transpose(NE))
ygg1 = pagemtimes(N1*E1,p1);
ygg2 = pagemtimes(N2*E2,p2);
ygg3 = pagemtimes(N3*E3,p3);

ygg = cat(1, ygg1, ygg2, ygg3);
yygg = reshape(ygg, 8461,120*23)*unit_conversion;
btgg = real(rad2bt(vchan, yygg));

%% global basis only (from Reconstruction operator)
yg1 = pagemtimes(R1,p1);
yg2 = pagemtimes(R2,p2);
yg3 = pagemtimes(R3,p3);

yg = cat(1, yg1, yg2, yg3);
yyg = reshape(yg, 8461, 120*23)*unit_conversion;
btg = real(rad2bt(vchan, yyg));

%% global and local basis
p_local1 = scale_factor * double(h5read(granfile, '/band_1/p_local'));
p_local2 = scale_factor * double(h5read(granfile, '/band_2/p_local'));
p_local3 = scale_factor * double(h5read(granfile, '/band_3/p_local'));

R_local1 = h5read(granfile, '/band_1/R_local');
R_local2 = h5read(granfile, '/band_2/R_local');
R_local3 = h5read(granfile, '/band_3/R_local');

yl1 = pagemtimes(R1,p1) + pagemtimes(R_local1,p_local1);
yl2 = pagemtimes(R2,p2) + pagemtimes(R_local2,p_local2);
yl3 = pagemtimes(R3,p3) + pagemtimes(R_local3,p_local3);

yl = cat(1, yl1,yl2,yl3);
yyl = reshape(yl, 8461, 120*23)*unit_conversion;
btl = real(rad2bt(vchan, yyl));

%% the uncompressed granule
addpath /asl/matlib/aslutil
addpath /home/sbuczko1/git/rtp_prod2/iasi/readers

normalgranfile='/asl/iasi/iasi3/l1c/2023/090/IASI_xxx_1C_M03_20230331114153Z_20230331114456Z';
data = readl1c_epsflip_all(normalgranfile);
fchan = (645:0.25:2760)';
yyr = reshape(data.IASI_Radiances, 690*4, 8461)';
btr = real(rad2bt(fchan, yyr));

%% plots
figure
tiledlayout(2,3)
nexttile
plot(vchan, mean(yyg,2))
title('PC radiance (global)')
ylabel('radiance')
xlabel('channel')

nexttile
plot(vchan, mean(yyl,2))
title('PC radiance (global/local)')
ylabel('radiance')
xlabel('channel')

nexttile
plot(fchan, mean(yyr,2))
title('Raw radiance')
ylabel('radiance')
xlabel('channel')

nexttile
plot(vchan, mean(btg,2))
title('PC BT (global)')
ylabel('BT (K)')
xlabel('channel')

nexttile
plot(vchan, mean(btl,2))
title('PC BT (global/local)')
ylabel('BT (K)')
xlabel('channel')

nexttile       
plot(fchan, mean(btr,2))
title('Raw BT')
ylabel('BT (K)')
xlabel('channel')











