function p=picaneeg_example_alphatrials_iaps_biosemi_besa(lb,ub,graphics,fname)
% example of working with PICAN eeg functions
% for a .bdf (BioSemi) or .dat (BESA processed) IAPS viewing file
% subject views each IAPS picture for 6 seconds, followed by 6 seconds of blank
% screen.  Pictures are Positive (1), Negative (2), or Neutral (3).
% usage: p=picaneeg_example_alphatrials_iaps_biosemi_besa;

if nargin<1, lb=-1; end
if nargin<2, ub=-1; end
if nargin<3, graphics=1; end
if nargin<4, fname='C:\greg\papers\cidar\data\erp\eeg\2030_03_iapsview-export.dat'; end

ftype=fname(end-2:end);
switch(ftype)
 case 'bdf', netname='biosemi_bdf';
 case 'dat', netname='besa_dat';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% get alpha range
if lb<0
  alphastats=picaneeg_indivalphafreq(fname,netname);
  lb=alphastats.poolalphalb;
  ub=alphastats.poolalphaub;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading the data
p=picaneeg_loadraw(fname,lb,ub,netname);
% p=picaneeg_addnetdata(p); % add electrode placement
p.alphastats=alphastats;
p=picaneeg_biosemi_procevents(p); % find event codes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Design Specific Code - modify this
p.TrialStarts=p.EventTicks(find(p.EventCodes==8));
p.TrialEnds=[p.TrialStarts(2:end) size(p.OtherData,2)];
p.TrialLengths=[p.TrialEnds-p.TrialStarts]
p.NumTrials=size(p.TrialStarts,2);
p.TrialTypes=p.EventCodes(2:3:end); %
p.CondLabels={'Positive','Negative','Neutral'}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Segmenting the data into trials and getting Condition-Related averages and stats
p=picaneeg_segmenttrials(p); % breaks the data into trials 
p=picaneeg_dropbadtrials(p); % drops bad trials
p=picaneeg_condmeans(p,200,12200); % looking at 12 second window after picture is shown (after 200ms mask)
p.selectedtrialavg=picaneeg_getmontageavg(p,[68 74 96 100],'Mean'); % gets the condition related averages for certain electrodes, here F3' and F4'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting functions
if graphics
  figure(1); picaneeg_plotcondmeans(p); % which electrodes are of interest?
  % which other plots are appropriate for iaps?

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% writing output
picaneeg_writestats(p,'Mean');
