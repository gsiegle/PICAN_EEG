function picaneeg_plotcondmeanbarshoriz(p,chanlist,statname)
% plots bars

if (nargin<2) | (isempty(chanlist))
  channums=1:length(p.ChanLabels); 
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
if nargin<3, statname='Mean'; end

dat=getfield(p.CondStats,sprintf('Cond%s',statname));


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
   barh(dat(:,chan));
   title(char(p.ChanLabels(channums(chan))));
   set(gca,'YTick',1:size(dat,1));
   set(gca,'YTickLabel',p.CondLabels);
   %axis off;
   axis tight; curax=axis;
   axis([min(dat(:,chan)) max(dat(:,chan)) curax(3) curax(4)]);
   ax(chan,:)=axis;
end
%for chan=1:numchans
%  subplot(numhoriz,numvert,chan);
%  axis([min(ax(:,1)) max(ax(:,2)) min(ax(:,3)) max(ax(:,4))]);
%  %if p.frequb==0
%  %  view(0,-90);
%  %end
%end
axis on;
