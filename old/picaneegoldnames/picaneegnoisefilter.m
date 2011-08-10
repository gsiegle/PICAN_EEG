function p=picaneegnoisefilter(p,freqlb,frequb)
% filters raw EEG before creating trial-related averages

for channum=1:size(p.EEGind,1)
  p.EEGind(channum,:)=bandpass(p.EEGind(channum,:),freqlb,frequb,1./p.SampleRate);
  fprintf('.');
end
fprintf('\n');
