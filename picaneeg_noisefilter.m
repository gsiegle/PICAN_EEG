function p=picaneeg_noisefilter(p,freqlb,frequb)
% usage: p=picaneeg_noisefilter(p,freqlb,frequb)
% filters raw EEG before creating trial-related averages
% between freqlb and frequb

for channum=1:size(p.EEGind,1)
  p.EEGind(channum,:)=bandpass(p.EEGind(channum,:),freqlb,frequb,1./p.SampleRate);
  fprintf('.');
end
fprintf('\n');
