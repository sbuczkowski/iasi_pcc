% plot eigenspace noise term as brightness temp to compare against
% change in noise seen in radiance reconstruction

% assumes that iasi_pcc_single_granule has been run and its
% variables are still available

figure
for i=1:3
    mean = eigendata(i).mean;
    chans = radiances(i).chans;


    plot(chans, mean);
    hold on;

end
legend('Band 1', 'Band 2', 'Band 3', 'Location', 'SouthEast');
title('IASI eigenspace mean');
xlabel('wavenumber (cm^{-1})');
ylabel('Arb. Units');

    