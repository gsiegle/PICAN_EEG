function p=picangeteegtimewin(p,winstart,winend)
% gets some condition- and trial-related average 
% given p generated from picanproceeg and picansegmenteegtrials
% usage: picangeteegtimewin(p,win,efunc)
% where winstart and winend are in ms
% giving all of mean, max, min, meanpersec in a montage

p.winstart=winstart; p.winend=winend;

winstartind=round((winstart./1000).*p.SampleRate);
winendind=round((winend./1000).*p.SampleRate);
win=winstartind:winendind;
if winendind>size(p.EEGTrialData,3)
    fprintf('You idiot, end of window outside trial range. Resetting to trial end\n');
    winend=size(p.EEGTrialData,3);
end
if winstartind<1
    winstartind=1;
end

% first, trial-related indices
p.TrialStats.TrialMean=mean(p.EEGTrialData(:,:,win),3);
p.TrialStats.TrialMax=max(p.EEGTrialData(:,:,win),[],3);
p.TrialStats.TrialMin=min(p.EEGTrialData(:,:,win),[],3);

numsecs=floor(size(p.EEGTrialData,3)./p.SampleRate);
for sec=1:numsecs
    secwin=((sec-1).*p.SampleRate+1):((sec).*p.SampleRate);    
    p.TrialStats.MeanPerSecond(sec,:,:)=mean(p.EEGTrialData(:,:,secwin),3);
end

% now condition-related indices
condstouse=setdiff(unique(p.TrialTypes),-999);
for condnum=1:length(condstouse)
    condtrials=find(p.TrialTypes==condstouse(condnum));
    p.CondMeans(condnum,:,:)=squeeze(mean(p.EEGTrialData(condtrials,:,:),1));
end

% for ERP subtract out baseline at trial onset
% use a 30 ms baseline
if p.frequb==0
    baseendind=round((30./1000).*p.SampleRate);
    basewin=1:baseendind;
    baseline=squeeze(mean(p.CondMeans(:,:,basewin),3));
    baseline=repmat(baseline,[1 1 size(p.CondMeans,3)]);
    p.CondMeans=p.CondMeans-baseline;
end

% make stats
p.CondStats.CondMean=squeeze(mean(p.CondMeans(:,:,win),3));
p.CondStats.CondMax=squeeze(max(p.CondMeans(:,:,win),[],3));
p.CondStats.CondMin=squeeze(min(p.CondMeans(:,:,win),[],3));

for sec=1:numsecs
   secwin=((sec-1).*p.SampleRate+1):((sec).*p.SampleRate);    
   p.CondStats.MeanPerSecond(:,sec,:)=mean(p.CondMeans(:,:,secwin),3);
end

