function p=picaneeg_example_continuousalpha_emotiv(lb,ub,graphics,fname)
% example of working with PICAN eeg functions
% for alpha examined continuously
% usage: p=picaneeg_example_continuousalpha_emotiv(lb,ub,graphics,fname)
%   by default lb=-1,ub=-1,graphics=1, fname is something on Greg's hard drive

if nargin<1, lb=-1; end
if nargin<2, ub=-1; end
if nargin<3, graphics=1; end
if nargin<4, fname='C:\greg\papers\emotiv\data\williameeg\Music Data EDF\Heaven Day 1 Trial 01.edf'; end

ftype=fname(end-2:end);
switch(ftype)
 case 'edf', netname='emotiv_edf';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get alpha range
if lb<0
  alphastats=picaneeg_indivalphafreq(fname, netname, [3 12]);
  lb=alphastats.poolalphalb;
  ub=alphastats.poolalphaub;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading the data
p=picaneeg_loadraw(fname,lb,ub,netname);
p.alphastats=alphastats;
p=picaneeg_addnetdata(p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Design Specific Code - modify this
% we want continuous alpha as if the data represented one long trial
p.TrialStarts=1;
p.TrialEnds=size(p.EEGind,2);
p.TrialLengths=[p.TrialEnds-p.TrialStarts];
p.TrialTypes=1;
p.CondLabels={'Alpha'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segmenting the data into trials and getting Condition-Related averages and stats
p=picaneeg_segmenttrials(p); % breaks the data into trials 
p=picaneeg_condmeans(p,4,3500); % gets the average over the first 35 seconds
p.selectedtrialavg=picaneeg_getmontageavg(p,[3 12],'Mean'); % gets the condition related averages for certain electrodes, here F3 and F4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  figure(1); clf; picaneeg_plottimeseries(p); % shows time-series
  %figure(2); picaneeg_animtopo(p); % animate time series
  figure(3); clf; picaneeg_condtopo(p); % show the condition means
  figure(4); clf; picaneeg_plotcondmeans(p);
  %channum=3; condnum=0; sorttime=.025;
  %figure(5); clf; picaneeg_plotallcondtrials(p,channum,condnum,sorttime);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picaneeg_writestats(p,'Mean');
