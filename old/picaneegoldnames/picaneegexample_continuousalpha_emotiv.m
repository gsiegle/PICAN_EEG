function p=picaneegexample_continuousalpha_emotiv(lb,ub,graphics,fname)
% example of working with PICAN eeg functions
% for alpha examined continuously
% usage: p=picaneegexample_continuousalpha_emotiv;

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
  alphastats=picanipf(fname, netname, [3 12]);
  lb=alphastats.poolalphalb;
  ub=alphastats.poolalphaub;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading the data
p=picanproceeg(fname,lb,ub,netname);
p.alphastats=alphastats;
p=picaneegaddnetdata(p);

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
p=picansegmenteegtrials(p); % breaks the data into trials 
p=picangeteegtimewin(p,4,3500); % gets the average over the first 35 seconds
p.selectedtrialavg=picangetmontavg(p,[3 12],'Mean'); % gets the condition related averages for certain electrodes, here F3 and F4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  figure(1); clf; picanploteegtimeseries(p); % shows time-series
  %figure(2); picananimtopo(p); % animate time series
  figure(3); clf; picaneegcondtopo(p); % show the condition means
  figure(4); clf; picanploteegcondmeans(p);
  %channum=3; condnum=0; sorttime=.025;
  %figure(5); clf; picaneegplotallcondtrials(p,channum,condnum,sorttime);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picanwriteeegstats(p,'Mean');
