function p=picaneeg_biosemi_procevents(p)
p.EventTicks=find(p.OtherData(end,1:end-1)~=p.OtherData(end,2:end));
p.EventCodes=p.OtherData(end,p.EventTicks);
p.EventCodes=p.EventCodes-min(p.EventCodes);

goodevents=find((p.EventCodes>0) & (p.EventCodes<50));
p.EventTicks=p.EventTicks(goodevents);
p.EventCodes=p.EventCodes(goodevents);
