% plot eigenspace noise term as brightness temp to compare against
% change in noise seen in radiance reconstruction

% assumes that iasi_pcc_single_granule has been run and its
% variables are still available

figure
for i=1:3
    noise = eigendata(i).noise;
    chans = radiances(i).chans;
    bt = rad2bt(chans, noise);

    plot(chans, bt);
    hold on;

end
legend('Band 1', 'Band 2', 'Band 3', 'Location', 'SouthEast');
title('IASI eigenspace noise');
xlabel('wavenumber (cm^{-1})');
ylabel('Brightness Temp. (K)');

    