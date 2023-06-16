function plot_summaries()
% PLOT_SUMMARIES 
%
% 
% run from /asl/data/IASI/PCC/2009/06/14 for the moment

load('/asl/data/IASI/PCC/2009/06/14/M02_recon_summary.mat');
avgmean = mean(granule_means);
avgstd = mean(granule_sigmas);
sigmameans = std(granule_means);
sigmastds = std(granule_sigmas);

msize = size(granule_means);

% now have fchan plus arrays for granule_means and granule_sigmas
figure(1)
subplot(2,1,1)
plot(fchan, avgmean)
subplot(2,1,2)
plot(fchan, sigmameans)

figure(2)
subplot(2,1,1)
plot(fchan, avgstd)
subplot(2,1,2)
plot(fchan, sigmastds)

% loop over random selection of channels and plot histogram of bias mean
rindices = sort(round(rand(1,20)*msize(2)));
scale=1.2;
figure(3)
for i=1:20
    subplot(5,4,i)
    histogram(granule_means(:,rindices(i)));
    title(sprintf('Channel %d', rindices(i)))
end
print(3, '-dpng', '~/ToTransfer/histograms_mean.png')

% loop over random selection of channels and plot histogram of bias std
% rindices = round(rand(1,20)*msize(2));
scale=1.2;
figure(4)
for i=1:20
    subplot(5,4,i)
    histogram(granule_sigmas(:,rindices(i)));
    title(sprintf('Channel %d', rindices(i)))
end
print(3, '-dpng', '~/ToTransfer/histograms_sigma.png')

% $$$ % loop over random selection of individual granule summaries and
% $$$ % plot mean vs avgmean
% $$$ rindices = round(rand(1,20)*msize(1));
% $$$ onetoone = (-1:1);
% $$$ scale=1.2;
% $$$ figure(3)
% $$$ for i=1:20
% $$$     subplot(5,4,i)
% $$$     plot(avgmean, granule_means(i,:))
% $$$     hold on
% $$$     plot(onetoone, onetoone, 'k-')
% $$$     hold off
% $$$     xlim([min(granule_means(i,:)) max(granule_means(i,:))]*scale)
% $$$     ylim([min(granule_means(i,:)) max(granule_means(i,:))]*scale)
% $$$     title(sprintf('Index %d', rindices(i)))
% $$$ end
% $$$ print(3, '-dpng', '~/ToTransfer/scatterplots_mean.png')

% $$$ figure(4)
% $$$ onetoone = (-2:2);
% $$$ for i=1:20
% $$$     subplot(5,4,i)
% $$$     plot(avgstd, granule_sigmas(i,:))
% $$$     hold on
% $$$     plot(onetoone, onetoone, 'k-')
% $$$     hold off
% $$$     xlim([min(granule_sigmas(i,:)) max(granule_sigmas(i,:))]*scale)
% $$$     ylim([min(granule_sigmas(i,:)) max(granule_sigmas(i,:))]*scale)
% $$$     title(sprintf('Index %d', rindices(i)))
% $$$ end
% $$$ print(4, '-dpng', '~/ToTransfer/scatterplots_sigma.png')



%% ****end function plot_summaries****