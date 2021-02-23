function iasi_pcc_rec_noise_test()

addpath(genpath('~/git/matlib'))
addpath(genpath('~/git/rtp_prod/iasi'))
addpath('~/git/iasi_pcc')

% $$$ BASEDIR = '~'; % root directory base of laptop data storage
BASEDIR = ''; % root directory base on maya1/2

% build iasi channel array
fchan = (645:0.25:2760);

IASIROOT=[BASEDIR '/asl/data/IASI/L1C/2013/02/10'];
PCCROOT=[BASEDIR '/asl/data/IASI/PCC/2013/02/10'];



IASIFILE{1}='IASI_xxx_1C_M02_20130210000854Z_20130210001157Z';
IASIFILE{2}='IASI_xxx_1C_M02_20130210011454Z_20130210011757Z';
IASIFILE{3}='IASI_xxx_1C_M02_20130210023558Z_20130210023853Z';

imax = numel(IASIFILE);
% $$$ imax = 1;
for i=1:imax
    % read in raw IASI file
    data = readl1c_epsflip_all(fullfile(IASIROOT, IASIFILE{i}));

    % get and reformat radiances
    rad = data.IASI_Radiances;
    radsize = size(rad);
    rrad = reshape(rad, radsize(1)*radsize(2), radsize(3));

    % uncompress IASI corresponding pcc file and reconstruct radiances
    [data_rec, eigendata] = iasi_pcc_uncompress_granule(fullfile(PCCROOT, ...
                                                      [IASIFILE{i} '.pcc']));

    % get reconstructed radiances (no reshaping necessary)
    rrad_rec = data_rec.IASI_Radiances;

    % massage eigensystem noise figure (returned from
    % uncompression)
    % the noise data supplied by EUMETSAT is, presumably, the
    % standard deviation of the training spectra
    noise1 = eigendata(1).noise';
    noise2 = eigendata(2).noise';
    noise3 = eigendata(3).noise';

    noise = [noise1 noise2 noise3];

    % noise is (1 x nchan) array so, replicate to make work with
    % spectra more simply
    rnoise = repmat(noise, radsize(1)*radsize(2), 1);
    
    % massage eigensystem mean (returned from uncompression
    % routine)
    % The mean supplied by EUMETSAT is the mean radiance normalized
    % by the training set noise figure
    mean1 = eigendata(1).mean';
    mean2 = eigendata(2).mean';
    mean3 = eigendata(3).mean';

    amean = [mean1 mean2 mean3];

    % mean is (1 x nchan) array so, replicate to make it work with
    % spectra more simply
    rmean = repmat(amean, radsize(1)*radsize(2), 1);

    % plot noise
    ifig=1
    f(i).fig(ifig) = figure;
    %plot(fchan, noise);
    noise(noise < 0) = NaN;
    semilogy(fchan, noise);
    xlim([fchan(1)-50 fchan(end)]);
    title('Training data noise figure');
    ylabel('(mW m-2 sr-1 / cm-1)');
    xlabel('wavenumber');
    print(f(i).fig(ifig), '~/ToTransfer/iasi_noise.png', ...
          '-dpng');
    ifig = ifig+1;

    % plot mean
    f(i).fig(ifig) = figure;
    subplot(2,1,1);
    plot(fchan, amean);
    xlim([fchan(1)-50 fchan(end)]);
    title('Training data mean');
    ylabel('noise normalized (Arb Units)');
    subplot(2,1,2);
    plot(fchan, amean.*noise);
    xlim([fchan(1)-50 fchan(end)]);
    ylabel('mW m-2 sr-1 / cm-1');
    xlabel('wavenumber');
    print(f(i).fig(ifig), '~/ToTransfer/iasi_mean.png', ...
          '-dpng');
    ifig = ifig+1;
    
% $$$     % plot spectra
% $$$     nsp = [2,1]; % number of subplots (r x c)
% $$$     ip = 1;
% $$$     f(i).fig(3) = figure;
% $$$     subplot(nsp(1), nsp(2), ip)
% $$$     ip=ip+1;
% $$$     %plot(fchan, rrad);
% $$$     rrad(rrad < 0) = NaN;
% $$$     semilogy(fchan, rrad);
% $$$     ylabel('radiance (mW m-2 sr-1 / cm-1)');
% $$$     subplot(nsp(1), nsp(2), ip)
% $$$     ip=ip+1;
% $$$     %plot(fchan, rrad_rec);
% $$$     rrad_rec(rrad_rec < 0) = NaN;
% $$$     semilogy(fchan, rrad_rec);
% $$$     ylabel('rec. radiance (mW m-2 sr-1 / cm-1)');
% $$$     xlabel('wavenumber');

% $$$     % plot bias between original and reconstructed spectra
% $$$     f(i).fig(4) = figure;
% $$$     subplot(2,1,1)
% $$$     bias = rrad - rrad_rec;
% $$$     plot(fchan, bias)
% $$$     title('bias (radiance - reconstruction)')
% $$$     ylabel('mW m-2 sr-1 / cm-1')
% $$$     subplot(2,1,2)
% $$$     plot(fchan, std(bias))
% $$$     ylabel('\sigma');
% $$$     xlabel('wavenumber');
% $$$     print(f(i).fig(4), '~/Desktop/ToTransfer/bias.png', '-dpng');
    
    % plot bias in noise normalized space
    f(i).fig(ifig) = figure;
    subplot(2,1,1)
    nbias = (rrad - rrad_rec)./rnoise;
    plot(fchan, mean(nbias))
    xlim([fchan(1)-10, fchan(end)+10]);
    title('bias (noise normalized)');
    ylabel('granule avg bias');
    subplot(2,1,2)
    plot(fchan, std(nbias));
    xlim([fchan(1)-10, fchan(end)+10]);
    ylabel('\sigma');
    xlabel('wavenumber');
    print(f(i).fig(ifig), ['~/ToTransfer/' IASIFILE{i} '-bias_norm.png'], '-dpng');
    
end