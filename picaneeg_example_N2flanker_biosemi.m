function p=picaneeg_example_N2flanker_biosemi(fname,graphics)
% example of working with PICAN eeg functions
% for N2 from a flanker task for the BioSemi system
% usage: p=picaneegexample_alphatrials_emotiv;

if nargin<1, fname='C:\greg\papers\cidar\data\erp\eeg\2265_03flanker.bdf'; end
if nargin<2, graphics=1; end

minfilterfreq=.01; maxfilterfreq=30; % hz filters for ERP analyses
starttime=100; endtime=300; peaktime=200; % time offsets for N2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading the data
p=picaneeg_loadraw(fname,0,0); % 0,0 means no frequency data processed
p=picaneeg_addnetdata(p); % add electrode placement
p=picaneeg_biosemi_procevents(p); % find event codes
p=picaneeg_noisefilter(p,minfilterfreq,maxfilterfreq); % filter from .01 to 30Hz - only for ERP analyses

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
p=picaneeg_segmenttrials(p); % breaks the data into trials 
%pcolor(p.EEGind); shading flat % shows all electrodes
p=picaneeg_dropbadtrials(p); % drops bad trials
p=picaneeg_condmeans(p,starttime,endtime); % gets the trial and condition related averages between 100 and 300ms
p.selectedtrialavg=picaneeg_getmontageavg(p,[3 12],'Min'); % gets the condition related averages for certain electrodes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  %figure(1); picaneeg_plottimeseries(p); % shows time-series for all electrodes
  %figure(2); picaneeg_animtopo(p); % animate time series
  figure(3); clf; picaneeg_condtopo(p,'Min'); % show the condition means on a topographic scalp
  figure(4); clf; picaneeg_plotcondmeans(p); % shows condition-related means for all conditions

  % alternately can show just one condition using eeglab native functions
  figure(5); clf; plottopo(squeeze(p.CondMeans(1,:,:)),p.chanlocs); % condition 1
  figure(6); clf; plottopo(squeeze(p.CondMeans(2,:,:)),p.chanlocs); % condition 2

  figure(7); clf; picaneeg_plotcondmeans(p,{'Fz','Cz','Pz','Oz'});
  condnum=0; sorttime=peaktime; % sorttime in ms
  figure(8); clf; picaneeg_plotallcondtrials(p,'Fz',condnum,sorttime);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picaneeg_writestats(p,'Min');
