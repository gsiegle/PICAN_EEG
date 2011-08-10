function picaneeg_writestats(p,statname)
% writes a statistic for each electrode, each condition
if nargin<2, statname='Mean'; end

if p.frequb>0
  fname=sprintf('%s_EEGStats_%s_%d-%dHz_%d-%dms.txt',p.fname(1:end-4),statname,p.freqlb,p.frequb,p.winstart,p.winend);
else
  fname=sprintf('%s_EEGStats_%s_ERP_%d-%dms.txt.txt',p.fname(1:end-4),statname,p.winstart,p.winend);
end

fp=fopen(fname,'w');
fprintf(fp,'fname');
for condnum=1:length(p.CondLabels)
  for channum=1:length(p.ChanLabels)
    fprintf(fp,'\t%s_%s',char(p.ChanLabels(channum)),char(p.CondLabels(condnum)));
  end
end
fprintf(fp,'\n');
fprintf(fp,'%s',p.fname);
dat=getfield(p.CondStats,sprintf('Cond%s',statname));
for condnum=1:length(p.CondLabels)
  for channum=1:length(p.ChanLabels)
    fprintf(fp,'\t%.4f',dat(condnum,channum));
  end
end
fprintf(fp,'\n');
fclose(fp);
fprintf('Output in %s\n',fname);

