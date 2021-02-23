addpath(genpath('/asl/rtp_prod/iasi'))
addpath(genpath('/asl/matlib/'))

data = readl1c_epsflip_all('/asl/data/IASI/L1C/2013/02/10/IASI_xxx_1C_M02_20130210030854Z_20130210031157Z');

fchan = (645:0.25:2760)';


orads = reshape(data.IASI_Radiances, [2760,8461]);
obt = rad2bt(fchan, orads');

indices = find(fchan == 2500);

addpath('~/git/iasi_pcc')
pdata = iasi_pcc_from_netcdf('/asl/data/IASI/PCC/2013/02/10/IASI_xxx_1C_M02_20130210030854Z_20130210031157Z.pcc');
prad = pdata.IASI_Radiances;

% $$$ pbt = rad2bt(fchan, prad');
% $$$ max(max(pbt(indices-10:indices+10,:)))
% $$$ min(min(pbt(indices-10:indices+10,:)))
% $$$ 
% $$$ otemps = obt(indices,:);
% $$$ ptemps = pbt(indices,:);
% $$$ histogram(otemps)
% $$$ 
% $$$ title('IASI raw BT (2500cm^{-1})')
% $$$ xlabel('Temperature (K)')
% $$$ print -dpng '~/ToTransfer/iasi-raw-bt-hist.png'
% $$$ histogram(ptemps)
% $$$ title('IASI reconstruct BT (2500cm^{-1})')
% $$$ xlabel('Temperature (K)')
% $$$ print -dpng '~/ToTransfer/iasi-rec-bt-hist.png'
% $$$ histogram(otemps)
% $$$ hold on
% $$$ histogram(ptemps)
