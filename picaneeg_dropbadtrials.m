function p=picaneeg_dropbadtrials(p,graphics)
% drops bad trials
% defined as trials with EOG or any microvolts>75

if nargin<2, graphics=1; end

%p.TrialTypesNoDrops=p.TrialTypes;
%dropmatrix = zeros(size(p.EEGTrialData,1),size(p.EEGTrialData,2));
maxmat=squeeze(max(abs(p.EEGTrialData),[],3));
maxmathoriz=reshape(maxmat,1,prod(size(maxmat)));
outliercutoff=prctile(maxmathoriz,75)+1.5.*iqr(maxmathoriz);
fprintf('Dropping trials with voltage above %.2f\n',outliercutoff);
p.dropcutoff=outliercutoff;
p.dropmatrix=maxmat>outliercutoff;
if graphics
  pcolor(double(p.dropmatrix)); shading flat; colormap hot;
  xlabel('Channel');
  ylabel('Trial');
  title(sprintf('Dropped Trials with voltage outside %.2f mV',p.dropcutoff));
end
