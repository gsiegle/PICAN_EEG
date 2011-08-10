function picaneeg_groupdiffwaveform(pall,chanlist);
% plots group or condition related differences in pall.EEG
% assumes pall.EEG is subjects x channels x time
% with pall.group to code group or condition

if nargin<2, 
  channums=1:length(pall.chanlocs); 
else
  % get the channel numbers we are interested
  channums=[];
  for ct=1:length(chanlist)
    [tf,chanpos]=ismember(chanlist(ct),pall.ChanLabels);
    if tf
      channums=[channums chanpos];
    else
      fprintf('Channel: %s not found. Not plotting\n',chanlist(ct));
    end
  end
end

clf;
% figure out how to lay out the channels
numchans=length(channums);
numhoriz=round(sqrt(numchans));
if (numhoriz.*numhoriz)<numchans
  numvert=numhoriz+1;
else
  numvert=numhoriz;
end
xax=(1:size(pall.EEG,3))./pall.SampleRate;

% get groups
groups=unique([pall.group]);
numgroups=length(groups);


% plot condition related differences for each channel
for chan=1:numchans
  subplot(numhoriz,numvert,chan);
  [s,h]=grpdiffwavgraph(squeeze(pall.EEG(:,chan,:)),[pall.group]',pall.SampleRate,pall.SampleRate,.1,zeros(size([pall.group]')),17,0,0,-500);
  %plot(xax,squeeze(pall.CondMeans(:,channums(chan),:))'); % plots condition-related averages for channel chan
  title(char(pall.ChanLabels(channums(chan))));
  axis off;
  axis tight;
  ax(chan,:)=axis;
end
for chan=1:numchans
   subplot(numhoriz,numvert,chan);
   axis([ax(1,1) ax(1,2) min(ax(:,3)) max(ax(:,4))]);
   if pall.frequb==0
     view(0,-90);
   end
end
axis on;
legend(h,pall.GroupLabels);
