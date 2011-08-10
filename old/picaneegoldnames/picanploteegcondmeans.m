function picanploteegcondmeans(p,chanlist);
if nargin<2, 
  channums=1:length(p.chanlocs); 
else
  % get the channel numbers we are interested
  channums=[];
  for ct=1:length(chanlist)
    [tf,chanpos]=ismember(chanlist(ct),p.ChanLabels);
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
xax=(1:size(p.CondMeans,3))./p.SampleRate;
% plot condition related differences for each channel
for chan=1:numchans
   subplot(numhoriz,numvert,chan);
   plot(xax,squeeze(p.CondMeans(:,channums(chan),:))'); % plots condition-related averages for channel chan
   title(char(p.ChanLabels(channums(chan))));
   axis off;
   axis tight;
   ax(chan,:)=axis;
end
for chan=1:numchans
   subplot(numhoriz,numvert,chan);
   axis([ax(1,1) ax(1,2) min(ax(:,3)) max(ax(:,4))]);
   if p.frequb==0
     view(0,-90);
   end
end
axis on;
legend(p.CondLabels);