daily = load 'NYSE_daily';
fltrd = filter daily by $6 > $3;
dump fltrd;
