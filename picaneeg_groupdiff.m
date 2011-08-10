function pall=picaneeg_groupdiff(pall,doaspaired,showhead,winstart,winend)
if nargin<2, doaspaired=0; end
if nargin<3, showhead=0; end
if nargin<5, winend=0; end

if (winend==0)
  eegtouse=pall.EEGsummary; 
else
  eegtouse=squeeze(mean(pall.EEG(:,:,round((winstart./1000).*pall.SampleRate):round((winend./1000).*pall.SampleRate)),3));
end


clf; 
groups=unique([pall.group]);
numgroups=length(groups);
allvals=reshape(eegtouse,1,prod(size(eegtouse)));
maxax=prctile(allvals,80);
minax=prctile(allvals,20);

if showhead
  switch pall.netname
   case 'emotiv_edf', splname='c:\greg\matlab\picaneeg\emotiv.spl';
   otherwise splname='c:\greg\matlab\picaneeg\biosemi128.spl';
  end
end

for ct=1:numgroups
  subplot(1,numgroups+1,ct);
  grpsubs=find([pall.group]==groups(ct));
  if showhead
    headplot(squeeze(mean(eegtouse(grpsubs,:),1)),splname); 
    colormap hot;
    view(-155,24);
  else
    topoplot(squeeze(mean(eegtouse(grpsubs,:),1)),pall.chanlocs); 
  end
  caxis([minax maxax]); colormap hot; freezeColors;
  h=colorbar; cbfreeze(h);
  title(char(pall.GroupLabels(ct)));
end

if length(unique([pall.group]))~=2
  fprintf('Group diffs only works with 2 groups so far. Group diffs not plotted\n');
  return;
else
  %group difference graph
  subplot(1,numgroups+1,numgroups+1); 
  colormap(flipud(hot)); 
  grp=[pall.group]';
  for channum=1:size(eegtouse,2)
    dat=eegtouse(:,channum);
    s=gttests(eegtouse(:,channum),grp,zeros(size(grp)),0,doaspaired);
    chant(channum)=s.t; chanp(channum)=s.p;
  end
  chanpsig=chanp.*double(chanp<.05)+.06.*(chanp>.05);
  if showhead
    headplot(chanpsig,splname); 
    colormap(flipud(hot)); caxis([0 .05]);
    view(-155,24);
  else
    topoplot(chanpsig,pall.chanlocs); 
  end
  caxis([0 .05]); colorbar;  colormap(flipud(hot)); 
  %colorbar;
  title('Significant Differences');
end

if winend==0
  pall.EEGsummary_grpdiff_t=chant;
  pall.EEGsummary_grpdiff_p=chanp;
else
  pall.grpdiff_t=chant;
  pall.grpdiff_p=chanp;
end
%headplot('setup',pall.chanlocs,'emotiv.spl')

% control type 1 error by seeing how many electrodes we need for significance
% as in Siegle, G. J., Condray, R., Thase, M. E., Keshavan, M., & Steinhauer, S. R. (2010). Sustained gamma-band EEG following negative words in depression and schizophrenia. Int J Psychophysiol, 75(2), 107-118.
