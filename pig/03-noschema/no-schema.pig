daily = load 'NYSE_daily';
calcs = foreach daily generate $7/1000, $3 * 100.0, SUBSTRING($0, 0, 1), $6 - $3;
dump calcs;
