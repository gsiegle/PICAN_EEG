function p=picaneeg_example_alphaeyesopenclosed_emotiv(lb,ub,graphics,fname)
% example of working with PICAN eeg functions
% for alpha breaking a long file up into arbitrary trials
% usage: p=picaneegexample_alphatrials_emotiv;


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
% suppose every 30 seconds represents a new window of interest
p.TrialStarts=1:(p.SampleRate.*30):(118.*p.SampleRate);
p.TrialEnds=[p.TrialStarts(2:end) p.TrialStarts(end)+p.SampleRate.*30];
p.TrialLengths=[p.TrialEnds-p.TrialStarts];
% suppose we'll be mostly comparing 1st half v. 2nd half
p.TrialTypes=[1 2 1 2];
p.CondLabels={'Eyes Open','Eyes Closed'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segmenting the data into trials and getting Condition-Related averages and stats
p=picaneeg_segmenttrials(p); % breaks the data into trials 
%pcolor(p.EEGind); shading flat % shows all electrodes
p=picaneeg_condmeans(p,1000,27.*1000); % gets the trial and condition related averages between 200 and 400ms
p.selectedtrialavg=picaneeg_getmontageavg(p,[3 12],'Mean'); % gets the condition related averages for certain electrodes, here F3 and F4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  figure(1); picaneeg_plottimeseries(p); % shows time-series
  %figure(2); picaneeg_animtopo(p); % animate time series
  figure(3); clf; picaneeg_condtopo(p); % show the condition means
  figure(4); clf; picaneeg_plotcondmeans(p);
  condnum=0; sorttime=.025;
  figure(5); clf; picaneeg_plotallcondtrials(p,'F7',condnum,sorttime);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picaneeg_writestats(p,'Mean');
