function iasi_pcc_rec_noise_test()

addpath(genpath('~/git/matlib'))
addpath(genpath('~/git/rtp_prod/iasi'))
addpath('~/git/iasi_pcc')

% build iasi channel array
fchan = (645:0.25:2760);

IASIROOT='/asl/data/IASI/L1C/2013/02/10';
PCCROOT='/asl/data/IASI/PCC/2013/02/10';



IASIFILE{1}='IASI_xxx_1C_M02_20130210000854Z_20130210001157Z';
IASIFILE{2}='IASI_xxx_1C_M02_20130210011454Z_20130210011757Z';
IASIFILE{3}='IASI_xxx_1C_M02_20130210023558Z_20130210023853Z';

for i=1:numel(IASIFILE)
    % read in raw IASI file
    data = readl1c_epsflip_all(fullfile(IASIROOT, IASIFILE{i}));

    % get and reformat radiances
    rad = data.IASI_Radiances;
    radsize = size(rad);
    rrad = reshape(rad, radsize(1)*radsize(2), radsize(3));

    % square radiances for snr 'power' comparison
    srrad = rrad.^2;

    % calculate variance of the granule by channel
    vrrad = var(rrad);

    % uncompress IASI corresponding pcc file and reconstruct radiances
    [data_rec, eigendata] = iasi_pcc_uncompress_granule(fullfile(PCCROOT, ...
                                                      [IASIFILE{i} '.pcc']));

    % get reconstructed radiances (no reshaping necessary)
    rrad_rec = data_rec.IASI_Radiances;

    % square radiances for snr 'power' comparison
    srrad_rec = rrad_rec.^2;

    % calculate variance of the reconstructed granule by channel
    vrrad_rec = var(rrad_rec);
    
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
    
    % square noise for snr 'power' comparison (this also makes
    % srnoise the noise variance)
    srnoise = rnoise.^2;
    
    % plot noise
    f(i).fig(1) = figure;
    subplot(2,1,1);
    %plot(fchan, noise);
    semilogy(fchan, noise);
    ylabel('noise (mW m-2 sr-1 / cm-1)');
    subplot(2,1,2);
    %plot(fchan,noise.^2);
    semilogy(fchan, noise.^2)
    ylabel('power (noise^2)');
    xlabel('wavenumber');

    % plot spectra
    f(i).fig(2) = figure;
    subplot(2,2,1)
    %plot(fchan, rrad);
    semilogy(fchan, rrad);
    ylabel('radiance (mW m-2 sr-1 / cm-1)');
    subplot(2,2,2)
    %plot(fchan, rrad_rec);
    semilogy(fchan, rrad_rec);
    ylabel('rec. radiance (mW m-2 sr-1 / cm-1)');
    subplot(2,2,3)
    %plot(fchan, srrad);
    semilogy(fchan, srrad);
    ylabel('power (radiance^2)');
    xlabel('wavenumber');
    subplot(2,2,4);
    %plot(fchan, srrad_rec);
    semilogy(fchan, srrad_rec);
    ylabel('rec. power (radiance^2)');
    xlabel('wavenumber');

    % plot SNR (linear and power)
    f(i).fig(3) = figure;
    subplot(2,2,1);
    %plot(fchan, rrad./rnoise);
    semilogy(fchan, rrad./rnoise);
    ylabel('SNR (signal/noise)');
    subplot(2,2,2);
    %plot(fchan, rrad_rec./rnoise);
    semilogy(fchan, rrad_rec./rnoise);
    %    ylabel('SNR (signal/noise)');
    subplot(2,2,3)
    %plot(fchan,srrad./srnoise)
    semilogy(fchan,srrad./srnoise)
    ylabel('SNR (signal^2/noise^2)')
    xlabel('wavenumbers');
    subplot(2,2,4)
    %plot(fchan, srrad_rec./srnoise)
    semilogy(fchan, srrad_rec./srnoise)
    xlabel('wavenumbers');

    % plot SNR based on variances
    f(i).fig(4) = figure;
    subplot(2,1,1)
    semilogy(fchan, vrrad./srnoise(1,:));
    subplot(2,1,2)
    semilogy(fchan, vrrad_rec./srnoise(1,:));
    
end