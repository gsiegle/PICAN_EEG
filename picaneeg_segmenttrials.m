function p=picaneeg_segmenttrials(p)
% assumes p came from picaneeg_loadraw and has fields 
%   p.EEGind from picaneeg_loadraw
%   p.TrialStarts,p.TrialEnds - user defined
%   p.TrialTypes - user defined
p.TrialLengths=p.TrialEnds-p.TrialStarts;
mintriallength=min(p.TrialLengths);
p.EEGTrialData=zeros(length(p.TrialStarts),size(p.EEGind,1),mintriallength+1);
for tnum=1:length(p.TrialStarts)
  if mod(tnum,10)==0, fprintf('-'); end
  if p.TrialStarts(tnum)+mintriallength<size(p.EEGind,2)
    p.EEGTrialData(tnum,:,:)=p.EEGind(:,p.TrialStarts(tnum):(p.TrialStarts(tnum)+mintriallength));
  else
    p.EEGTrialData(tnum,:,1:size(p.EEGind(:,p.TrialStarts(tnum):end),2))=p.EEGind(:,p.TrialStarts(tnum):end)
    for indnum=(size(p.EEGind(1,p.TrialStarts(tnum):end),2)):size(p.EEGTrialData,3)
      p.EEGTrialData(tnum,:,indnum)=p.EEGind(:,end);
    end
  end
end
fprintf('\n');
if p.frequb==0
  p.EEGTrialData=p.EEGTrialData-repmat(mean(p.EEGTrialData(:,:,1:10),3),[1 1 size(p.EEGTrialData,3)]);
end
