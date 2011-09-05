function picaneeg_plottimeseries(p,startsamp,endsamp,chanlist,withtrials,withcondlabels)
% usage picaneeg_plottimeseries(p,startsamp,endsamp,chanlist)
% plots eeg timeseries acquired via picaneeg_loadraw
if (nargin < 2) | startsamp==0, startsamp=1; end
if (nargin < 3) | endsamp==0, endsamp=size(p.EEGind,2); end
if (nargin<4) | chanlist==0, chanlist=1:size(p.EEGind,1); end
if nargin<5, withtrials=0; end
if nargin<6, withcondlabels=0; end

clf;
mattoplot=p.EEGind(chanlist,startsamp:endsamp);

matmax=max(prctile(mattoplot,80));
matmin=min(prctile(mattoplot,20));
matnorm=(mattoplot-matmin)./(matmax-matmin);
matnorm=matnorm-repmat(matnorm(:,1),1,size(matnorm,2)); % start at zero for all channels
offset=repmat([1:length(chanlist)]'./2,1,size(mattoplot,2));
matwithoffset=offset+matnorm;
xax=([1:size(mattoplot,2)]+(startsamp-1))./p.SampleRate;
plot(xax,matwithoffset);
set(gca,'YTick',(1:length(chanlist))./2);
set(gca,'YTickLabel',p.ChanLabels);
ylabel('{\mu}V');
xlabel('Seconds');
%view(0,-90);
zoom xon;
if withtrials
  hold on;
  ax=axis;
  ts=zeros(size(xax))+ax(3);
  ts(p.TrialStarts)=ax(4);
  plot(xax,ts,'k');
end
if withcondlabels
  ax=axis;
  for ct=1:length(p.TrialStarts);
    if isfield(p,'TrialTypesNoDrops')
      text(p.TrialStarts(ct)./p.SampleRate,round(ax(4)-(ax(4)-ax(3))./length(p.ChanLabels)),char(p.CondLabels(p.TrialTypesNoDrops(ct))));
    else
      text(p.TrialStarts(ct)./p.SampleRate,round(ax(4)-(ax(4)-ax(3))./length(p.ChanLabels),char(p.CondLabels(p.TrialTypes(ct)))));
    end
  end
end
