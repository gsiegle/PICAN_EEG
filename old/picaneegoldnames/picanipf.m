function p=picanipf(fname, enet, channels, dorescaleoutliers)
%Estimates iPF (individualized peak alpha frequency) from .bdf, .dat, or .edf
%Uses wavelet transform (so=7) to estimate highest spectral frequency in the
%6-14Hz range, averaging over specified channels.
%Default .edf channels are F3/4.
%Default .bdf and .dat channels are F3'/4' (C32, D4, C4, C10).
%Provides recommended individualized frequency bands for:
%  pooled alpha: 4Hz band centered on iPF 
%  lower alpha (alpha 1): 1.5Hz band below iPF
%  upper alpha (alpha 2): 2Hz band starting .5Hz above iPF

if nargin<3,
   if strcmp(enet,'emotiv_edf'), channels=[3 12];
   else channels=[68 74 96 100]; %68 and 74 are F4' channels, 96 and 100 are F3' channels
   end
end
if nargin<4, dorescaleoutliers=0; end


%read file according to type
fprintf('Reading %s\n',fname);
switch(enet)
    case 'biosemi_bdf',
        p=pican_eeg_read_bdf_big(fname,'all','n');
        p.EEG=p.EEG(:,1:128);
        p.SampleRate=p.fs;
    case 'besa_dat'
        [p.time,p.data,p.nEpochs] = readBESAsb(fname);
        p.EEG=p.data(1:128,:)';
        fid=fopen([fname(1:end-4),'.generic'],'r');
        if fid==-1
          fid=fopen([fname(1:end-4),'.gen'],'r');        
        end
        fscanf(fid,'BESA Generic Data\n');
        fscanf(fid,'nChannels=%i\n');
        p.SampleRate = fscanf(fid,'sRate=%f\n');
        fclose(fid);
    case 'emotiv_edf'
         [p.hdr] = read_edf(fname);
         numsamps=p.hdr.orig.AS.spb;
         [dat] = read_edf(fname, p.hdr, 1, numsamps);
         p.EEG=dat(3:16,:)';  % time x channels
         p.SampleRate=p.hdr.Fs;
end

%Winsorize outliers
if dorescaleoutliers
  p.EEG=rescaleoutlierstimeseries(p.EEG);
end


for chanind=1:size(channels, 2)
[ps,yax]=waveplot(squeeze(p.EEG(:,channels(chanind))),p.SampleRate,7,0,3,1);
    if chanind==1
      tmp=find(yax<6);
      lowbd=tmp(1)-1;
      tmp=find(yax>14);
      hibd=tmp(end)+1;
      freqrange=hibd:lowbd;
    end
    for freqind=1:size(freqrange,2)
      tmppow(freqind,chanind)=mean(ps(freqrange(freqind),:));
    end
end

tmppowavg=mean(tmppow,2);
tmp=find(tmppowavg==max(tmppowavg)); tmp=tmp(1);
p.ipf=yax(tmp+freqrange(1)-1);

pnew.ipf=p.ipf;
pnew.channels=channels;
%recommended pooled alpha band
tmp=round(10.*p.ipf)./10;
pnew.poolalphalb=tmp-2;
pnew.poolalphaub=tmp+2;
%recommended alpha 1 band (lower alpha)
pnew.lowalphalb=tmp-1.5;
if tmp>p.ipf, pnew.lowalphaub=tmp;
else pnew.lowalphaub=tmp+.1; 
end
%recommended alpha 2 band (upper alpha)
pnew.upalphalb=tmp+.5;
pnew.upalphaub=tmp+2.5;
p=pnew;
