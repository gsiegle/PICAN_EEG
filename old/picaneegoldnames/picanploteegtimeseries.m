function picanploteegtimeseries(p,startsamp,endsamp,chanlist)
% plots eeg timeseries acquired via picanproceeg
if nargin < 2, startsamp=1; end
if nargin < 3, endsamp=size(p.EEGind,2); end
if nargin<4, chanlist=1:size(p.EEGind,1); end

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
