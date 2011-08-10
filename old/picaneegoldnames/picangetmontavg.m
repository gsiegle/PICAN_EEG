function montavg=picangetmontavg(p,electrodes,fieldname)
dat=getfield(p.CondStats,sprintf('Cond%s',fieldname));
montavg=mean(dat(:,electrodes),2);

