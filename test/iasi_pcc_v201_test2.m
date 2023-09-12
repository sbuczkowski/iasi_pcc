basedir = '/umbc/xfs2/strow/asl/s1/sbuczko1/Work/IASI/PCH';

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
% NaN out obs with negative radiances
[row,col] = find(yygg<0);
%yygg(:,col) = NaN;
yygg(yygg<0) = NaN;
btgg = real(rad2bt(vchan, yygg));

%% global basis only (from Reconstruction operator)
yg1 = pagemtimes(R1,p1);
yg2 = pagemtimes(R2,p2);
yg3 = pagemtimes(R3,p3);

yg = cat(1, yg1, yg2, yg3);
yyg = reshape(yg, 8461, 120*23)*unit_conversion;
% NaN out obs with negative radiances
[row,col] = find(yyg<0);
%yyg(:,col) = NaN;
yyg(yyg<0) = NaN;
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
% NaN out obs with negative radiances
[row,col] = find(yyl<0);
%yyl(:,col) = NaN;
yyl(yyl<0) = NaN;
btl = real(rad2bt(vchan, yyl));

%% the uncompressed granule
addpath /asl/matlib/aslutil
addpath /home/sbuczko1/git/rtp_prod2/iasi/readers

normalgranfile='/asl/iasi/iasi3/l1c/2023/090/IASI_xxx_1C_M03_20230331114153Z_20230331114456Z';
data = readl1c_epsflip_all(normalgranfile);
fchan = (645:0.25:2760)';
yyr = reshape(data.IASI_Radiances, 690*4, 8461)';
% NaN out obs with negative radiances
[row,col] = find(yyr<0);
%yyr(:,col) = NaN;
yyr(yyr<0) = NaN;
btr = real(rad2bt(fchan, yyr));

%% compute radiance and BT differences and get some stats
dyg = yyr-yyg;  % diff raw to global pc
dyl = yyr-yyl;  % diff raw to global + local pc

dbtg = btr-btg;
dbtl = btr-btl;



%% plots
figure
title('Radiances (raw, global pc, glob+local pc')
tiledlayout(3,1)
nexttile
plot(vchan, nanmean(yyr,2))
nexttile
plot(vchan, nanmean(yyg,2))
nexttile
plot(vchan, nanmean(yyl,2))

figure
title('Radiance diff (raw - pc (global/global-local))')
tiledlayout(1,2)
nexttile
plot(vchan, nanmean(yyr,2)-nanmean(yyg,2))
nexttile
plot(vchan, nanmean(yyr,2)-nanmean(yyl,2))

figure
title('BT (raw, global, glob-local)')
tiledlayout(3,1)
nexttile
plot(vchan, nanmean(btr,2))
nexttile
plot(vchan, nanmean(btg,2))
nexttile
plot(vchan, nanmean(btl,2))

figure
title('\Delta BT (raw-global, raw-local)')
tiledlayout(1,2)
nexttile
plot(vchan, nanmean(btr,2)-nanmean(btg,2))
nexttile
plot(vchan, nanmean(btr,2)-nanmean(btl,2))
