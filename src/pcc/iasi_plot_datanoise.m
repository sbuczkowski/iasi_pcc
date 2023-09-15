% plot eigenspace noise term as brightness temp to compare against
% change in noise seen in radiance reconstruction

% assumes that iasi_pcc_single_granule has been run and its
% variables are still available

figure
for i=1:3
    chans = radiances(i).chans;

    bt = rad2bt(chans, radiances(i).rad);
    bt_rec = rad2bt(chans, rdata(i).rad);

    sigma = std(bt,1,2);
    sigma_rec = std(bt_rec,1,2);

    hLine1 = plot(chans, sigma, 'b-');
    hold on;
    hLine2 = plot(chans, sigma_rec, 'r-');

end
legend([hLine1,hLine2], 'Raw', 'Reconstructed', 'Location', 'NorthWest');
title('');
xlabel('wavenumber (cm^{-1})');
ylabel('K');

    