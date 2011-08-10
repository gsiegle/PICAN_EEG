function picaneeg_plotallcondtrials(p,channame,condnum,sorttime)
% usage: picaneeg_plotallcondtrials(p,channame,condnum,sorttime)
% if condnum is 0, the mean of all conditions is plotted.
% otherwise trials in only one of the conditions is plotted
% sorttime is in ms
if nargin<4, sorttime=0; end
if nargin<3, condnum=0; end
if nargin<2, 
  channum=1;
else
  [tf,channum]=ismember(channame,p.ChanLabels);
  if ~tf
    fprintf('Channel: %s not found. Not plotting\n',channame);
    return;
  end
end

% plots all trials and the condition mean
clf;
if condnum~=0
  allcondtrials=find(p.TrialTypes==condnum);
else
  allcondtrials=1:length(p.TrialTypes);
end
xax=[1:size(p.CondMeans,3)]./p.SampleRate; 
yax=1:length(allcondtrials);
subplot(2,1,1); 
dat=squeeze(p.EEGTrialData(allcondtrials,channum,:));
if sorttime~=0
  rowdat=dat(:,max(1,round((sorttime./1000).*p.SampleRate)));
  [sortdat,sortinds]=sortrows(rowdat);
else
  sortinds=1:length(allcondtrials);
end
pcolor(xax,yax,dat(sortinds,:)); shading flat; 
ylabel('Trial');
subplot(2,1,2); 
if condnum~=0
  plot(xax,squeeze(p.CondMeans(condnum,channum,:)));
else
  plot(xax,squeeze(mean(p.CondMeans(:,channum,:),1)));
end
axis tight;
xlabel('seconds');
