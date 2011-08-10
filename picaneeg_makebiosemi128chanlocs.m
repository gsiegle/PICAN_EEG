function [chanlocs134 chanlocs128]=picaneeg_makebiosemi128chanlocs()

chanlocs254=readlocs('biosemi_254_chanlocs.loc');
for ct=1:length(chanlocs254)
  chanlabels254{ct}=chanlocs254(ct).labels;
end



cd C:\greg\papers\cidar\data\erp\eeg
fname='2008_23_cpt.bdf'
p=picaneeg_read_bdf_big(fname,20,'n');
for ct=1:length(p.labels)
  if member(p.labels(ct),chanlabels254)
    [tf,chanpos]=ismember(p.labels(ct),chanlabels254);
    chanlocs134(ct)=chanlocs254(chanpos);
  else
    fprintf('Position not found for %s\n',char(p.labels(ct)));
  end
end
chanlocs128=chanlocs134(1:128);
cd C:\greg\matlab\picaneeg
save biosemi128_chanlocs.mat chanlocs134 chanlocs128
