function p=picaneegexample_alphatrials_emotiv(lb,ub,graphics,fname)
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
% suppose every 2 seconds represents a new window of interest
p.TrialStarts=1:(p.SampleRate.*2):(35.*p.SampleRate);
p.TrialEnds=[p.TrialStarts(2:end) p.TrialStarts(end)+p.SampleRate.*2];
p.TrialLengths=[p.TrialEnds-p.TrialStarts];
% suppose we'll be mostly comparing 1st half v. 2nd half
p.TrialTypes(1:round(length(p.TrialStarts)./2))=1;
p.TrialTypes(round(length(p.TrialStarts)./2):length(p.TrialStarts))=2;
p.CondLabels={'Early','Late'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segmenting the data into trials and getting Condition-Related averages and stats
p=picansegmenteegtrials(p); % breaks the data into trials 
%pcolor(p.EEGind); shading flat % shows all electrodes
p=picangeteegtimewin(p,200,400); % gets the trial and condition related averages between 200 and 400ms
p.selectedtrialavg=picangetmontavg(p,[3 12],'Mean'); % gets the condition related averages for certain electrodes, here F3 and F4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  figure(1); picanploteegtimeseries(p); % shows time-seriesp.selectedtrialavg=picangetmontavg(p,[3 12],'Mean'); % gets the condition related averages for certain electrodes, here F3 and F4

  %figure(2); picananimtopo(p); % animate time series
  figure(3); clf; picaneegcondtopo(p); % show the condition means
  figure(4); clf; picanploteegcondmeans(p);
  channum=3; condnum=0; sorttime=.025;
  figure(5); clf; picaneegplotallcondtrials(p,channum,condnum,sorttime);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picanwriteeegstats(p,'Mean');
