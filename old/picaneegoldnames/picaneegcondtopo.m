function picaneegcondtopo(p)

% shows topographic plot for each condition

lbd=min(min(p.CondStats.CondMean));
ubd=max(max(p.CondStats.CondMean));

numconds=size(p.CondStats.CondMean,1);
for ct=1:numconds
  subplot(1,numconds,ct);
  dattoplot=squeeze(p.CondStats.CondMean(ct,:));
  topoplot(dattoplot',p.chanlocs);
  colorbar;
  caxis([lbd ubd]);
  title(char(p.CondLabels(ct)));
end
