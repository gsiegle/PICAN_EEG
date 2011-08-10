function picaneeg_grouptopo_ttest(pall)

groups=unique([pall.group]);
numgroups=length(groups);
if length(groups)~=2
  fprintf('Needs exactly 2 groups\n');
  return;
end

for ct=1:length(pall.chanlocs)
  [t,chanp(ct)]=gttest(pall.EEG(:,ct),[pall.group]');
end
