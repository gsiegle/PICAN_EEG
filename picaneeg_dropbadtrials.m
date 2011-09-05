function p=picaneeg_dropbadtrials(p,graphics,dropthresh)
% drops bad trials
% defined as trials with EOG or any microvolts>75

if nargin<2, graphics=0; end
if nargin<3, dropthresh=.4; end

% maxmat=squeeze(max(abs(p.EEGTrialData),[],3));
% maxmathoriz=reshape(maxmat,1,prod(size(maxmat)));
% outliercutoff=prctile(maxmathoriz,75)+1.5.*iqr(maxmathoriz);
% fprintf('Dropping trials with voltage above %.2f\n',outliercutoff);
% p.dropcutoff=outliercutoff;
% p.dropmatrix=maxmat>outliercutoff;
% if graphics
%   pcolor(double(p.dropmatrix)); shading flat; colormap hot;
%   xlabel('Channel');
%   ylabel('Trial');
%   title(sprintf('Dropped Trials with voltage outside %.2f mV',p.dropcutoff));
% end

% segment the proportion of trials with outliers into trials

for ct=1:length(p.TrialStarts)
  p.propoutlierspertrial(ct)=mean(p.propoutliers(p.TrialStarts(ct):p.TrialEnds(ct)));
end
p.drops=p.propoutlierspertrial>dropthresh;
p.TrialTypesNoDrops=p.TrialTypes;
p.TrialTypes(find(p.drops))=-999;
if graphics
  clf;
  bar(p.propoutlierspertrial);
  hold on;
  bar(p.drops.*p.propoutlierspertrial,'r');
  title('Proportion of dropped samples (red=dropped trial)');
end

