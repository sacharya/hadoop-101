daily = load 'NYSE_daily';
fltrd = filter daily by $6 > $3;
dump fltrd;

#(NYSE,CVA,2009-01-05,21.79,22.89,21.49,22.68,981100,22.68)
