function pall=picaneegexample_group_continuousalpha_emotiv()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find the datafiles we want
cd('C:\greg\papers\emotiv\data\williameeg\Music Data 2 EDF');
group1files=dir('6*.edf');
group2files=dir('No*.edf');

pall.GroupLabels={'Music','No Music'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% use 1 subject to get a bunch of parameters we may want to 
%  know about the dataset. These will be constant across all
%  participants
p=picaneegexample_continuousalpha_emotiv(-1,-1,0,char(group1files(1).name));
pall.SampleRate=p.SampleRate;
pall.ChanLabels=p.ChanLabels;
pall.chanlocs=p.chanlocs;
pall.netname=p.netname;
pall.winstart=p.winstart;
pall.winend=p.winend;
pall.freqlb=8; pall.frequb=12;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read each participant's data and store the one value of interest
%  per channel in pall.EEG
sub=1;
for ct=1:length(group1files)
  p=picaneegexample_continuousalpha_emotiv(-1,-1,0,char(group1files(ct).name));
  pall.EEGsummary(sub,:)=p.CondStats.CondMean;
  pall.EEG(sub,:,:)=squeeze(p.CondMeans);
  pall.group(sub)=1;
  sub=sub+1;
end
for ct=1:length(group2files)
  p=picaneegexample_continuousalpha_emotiv(-1,-1,0,char(group2files(ct).name));
  pall.EEGsummary(sub,:)=p.CondStats.CondMean;
  pall.EEG(sub,:,:)=squeeze(p.CondMeans);
  pall.group(sub)=2;
  sub=sub+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Graphics
%% Plot the mean alpha per group across the head

figure(1); clf;
pall=picaneeg_groupdiff(pall,0); % 0=do not treat tests as paired

figure(2); clf;
picaneeg_groupdiffwaveform(pall,{'F3','F4','T7','T8'})