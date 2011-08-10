function picaneeg_condtopo(p,statname,showhead)
% usage: picaneeg_condtopo(p,statname)
% makes topographic plot of a condition-related statistic
% statname is Mean, Min, or Max

if nargin<2,statname='Mean'; end
if nargin<3, showhead=0; end


if showhead
  switch p.netname
%   case 'emotiv_edf', splname='c:\greg\matlab\picaneeg\emotiv.spl';
%   otherwise splname='c:\greg\matlab\picaneeg\biosemi128.spl';
   case 'emotiv_edf', splname='\\oacres3\rcn\pican\MatlabCode\pupiltoolkit\picaneeg\emotiv.spl';
   otherwise splname='\\oacres3\rcn\pican\MatlabCode\pupiltoolkit\picaneeg\biosemi128.spl';
  end
end


dat=getfield(p.CondStats,sprintf('Cond%s',statname));

% shows topographic plot for each condition

lbd=min(min(dat));
ubd=max(max(dat));

numconds=size(dat,1);
for ct=1:numconds
  subplot(1,numconds,ct);
  dattoplot=squeeze(dat(ct,:));
  if showhead
    headplot(dattoplot',splname); 
  else  
    topoplot(dattoplot',p.chanlocs);
  end
  colorbar;
  caxis([lbd ubd]);
  title(char(p.CondLabels(ct)));
end
