function p=picaneeg_addnetdata(p)

ftype=p.fname(end-2:end);
switch(ftype)
 case 'edf', p.netname='emotiv_edf';
 case 'bdf', p.netname='biosemi_bdf';
end

% add the channel locations
switch(p.netname)
 case 'emotiv_edf', 
  %load('\\oacres3\rcn\pican\MatlabCode\pupiltoolkit\picaneeg\emotiv_epic_chanlocs.mat');
  load('emotiv_epic_chanlocs.mat');
  p.chanlocs=chanlocs14;
 otherwise
  %load('\\oacres3\rcn\pican\MatlabCode\pupiltoolkit\picaneeg\emotiv_epic_chanlocs.mat');
  load('biosemi128_chanlocs.mat');
  p.chanlocs=chanlocs128;  
end
