function p=picaneegexample_N2flanker_biosemi(fname,graphics)
% example of working with PICAN eeg functions
% for N2 from a flanker task for the BioSemi system
% usage: p=picaneegexample_alphatrials_emotiv;

if nargin<1, fname='C:\greg\papers\cidar\data\erp\eeg\2265_03flanker.bdf'; end
if nargin<2, graphics=1; end

minfilterfreq=.01; maxfilterfreq=30; % hz filters for ERP analyses
starttime=100; endtime=300; peaktime=200; % time offsets for N2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading the data
p=picanproceeg(fname,0,0); % 0,0 means no frequency data processed
p=picaneegaddnetdata(p); % add electrode placement
p=biosemi_procevents(p); % find event codes
p=picaneegnoisefilter(p,minfilterfreq,maxfilterfreq); % filter from .01 to 30Hz - only for ERP analyses

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Design Specific Code - MODIFY THIS
% suppose every 2 seconds represents a new window of interest

p.TrialStarts=p.EventTicks(1:2:end);
p.TrialEnds=[p.TrialStarts(2:end) size(p.OtherData,2)];
p.TrialLengths=[p.TrialEnds-p.TrialStarts];
p.TrialTypes=p.EventCodes(1:2:end);
p.CondLabels={'Congruent','Incongruent'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segmenting the data into trials and getting Condition-Related averages and stats
p=picansegmenteegtrials(p); % breaks the data into trials 
%pcolor(p.EEGind); shading flat % shows all electrodes
p=picaneegdropbadtrials(p); % drops bad trials
p=picangeteegtimewin(p,starttime,endtime); % gets the trial and condition related averages between 100 and 300ms
p.selectedtrialavg=picangetmontavg(p,[3 12],'Min'); % gets the condition related averages for certain electrodes, here F3 and F4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  %figure(1); picanploteegtimeseries(p); % shows time-seriesp.selectedtrialavg=picangetmontavg(p,[3 12],'Mean'); % gets the condition related averages for certain electrodes, here F3 and F4
  %figure(2); picananimtopo(p); % animate time series
  figure(3); clf; picaneegcondtopo(p); % show the condition means on a topographic scalp
  figure(4); clf; picanploteegcondmeans(p); % shows condition-related means for all conditions

  % alternately can show just one condition using eeglab native functions
  figure(5); clf; plottopo(squeeze(p.CondMeans(1,:,:)),p.chanlocs); % condition 1
  figure(6); clf; plottopo(squeeze(p.CondMeans(2,:,:)),p.chanlocs); % condition 2

  figure(7); clf; picanploteegcondmeans(p,{'Fz','Cz','Pz','Oz'});
  condnum=0; sorttime=peaktime; % sorttime in ms
  figure(8); clf; picaneegplotallcondtrials(p,'Fz',condnum,sorttime);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picanwriteeegstats(p,'Min');
