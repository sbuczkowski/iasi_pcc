addpath(genpath('/asl/rtp_prod/iasi'))
addpath(genpath('/asl/matlib/'))

IASI_PCC_DIR = '/asl/data/IASI/PCC';

eigendata = iasi_pcc_read_all_eigenvectors();

fprintf(1, '>>> Reading in sample IASI data file\n');
%% read in an IASI data file
% $$$ iasidir = '/asl/data/IASI/L1C/2013/09/10';
% $$$ iasifile = 'IASI_xxx_1C_M01_20130910152653Z_20130910152957Z';
% $$$ iasidir = '/asl/data/IASI/L1C/2013/09/09';
% $$$ iasifile = 'IASI_xxx_1C_M01_20130909104454Z_20130909104757Z';
iasidir = '/asl/data/IASI/L1C/2014/10/24/';
iasifile = 'IASI_xxx_1C_M02_20141024222400Z_20141024222655Z';
% $$$ iasidir = '/asl/data/IASI/L1C/2007/08/15/';
% $$$ iasifile = 'IASI_xxx_1C_M02_20070815152054Z_20070815152358Z';
% $$$ iasidir= '/asl/data/IASI/L1C/2009/02/06/';
% $$$ iasifile = 'IASI_xxx_1C_M02_20090206055052Z_20090206055356Z';

% Read the IASI datafile
data = readl1c_epsflip_all(fullfile(iasidir, iasifile));

% reformat the radiance data and split it into bands
radiances = iasi_split_bands(data);

% create pc scores from radiances eignevectors
fprintf(1, '>>> Create PCscores for radiance file\n');
for band=1:3
    cdata(band).pcscores = iasi_calculate_pcscores(radiances(band).rad, ...
                                                  eigendata(band));
end

% reconstruct radiances
fprintf(1, '>>> Reconstruct radiances\n');
for band=1:3
    rdata(band).rad = iasi_reconstruct_radiances(cdata(band).pcscores, ...
                                                     eigendata(band));
end

mkoutput=false;
if mkoutput
    % test plot of radiances as read in vs reconstructed
    outputdir = '/asl/data/IASI/PCC/testplots';
    [d, nspectra] = size(radiances(1).rad);
    for i=1:5
        spectrum = 1+int32(rand() * nspectra);
        
        %    fprintf(1, '>>> Make verification plot for first spectrum in each band\n');
        scrsz = get(groot, 'ScreenSize');
        fig(i) = figure('Name', 'IASI PCA compression test', 'Position', ...
                        [1 scrsz(4) scrsz(3) scrsz(4)]);
% $$$     set(fig(i), 'Visible', 'off');

% $$$     ax=axes('Units','Normal','Position',[.075 .075 .85 .85], ...
% $$$             'Visible','off');
% $$$     sTitle = 'test';
% $$$     set(get(ax,'Title'),'Visible','on')
% $$$     title(sTitle);
        
        for band=1:3
            subplot(2,3,band);
            fchan = radiances(band).chans;
            rad = radiances(band).rad;
            frad_rec = rdata(band).rad;
            bt = real(rad2bt(fchan, rad(:,spectrum)));
            fbt_rec = real(rad2bt(fchan, frad_rec(:,spectrum)));
            plot(fchan, bt);
            %ylim([-140 140]);
            xlim([min(fchan) max(fchan)]);
            hold on
            plot(fchan, fbt_rec);
            hold off
            sTitle = sprintf('Band %d BT', band);
            title(sTitle);
            ylabel('BT');
            legend('IASI', 'Reconstruct', 'Location', 'Southeast');
            %% difference
            subplot(2,3,band+3);
            plot(fchan, bt-fbt_rec);
            xlim([min(fchan) max(fchan)]);
            ylabel('BT - reconstructed')
            xlabel('Wavenumber (cm^-1)');
        end
        % make pdf version
        set(fig(i), 'PaperOrientation', 'landscape');
        print(fig(i), '-dpdf', fullfile(outputdir, [iasifile '_' num2str(spectrum)]));
    end
end
