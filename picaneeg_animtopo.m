function picaneeg_animtopo(p)

% animates eeg data over time

lbd=min(prctile(p.EEGind,2,2));
ubd=max(prctile(p.EEGind,75,2));

for ct=1:size(p.EEGind,2)
  dattoplot=squeeze(p.EEGind(:,ct));
  clf;
  topoplot(dattoplot',p.chanlocs);
  colorbar;
  caxis([lbd ubd]);
  drawnow
end
