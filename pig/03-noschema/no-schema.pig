daily = load 'NYSE_daily';
# Index starts from 0
calcs = foreach daily generate $7/1000, $3 * 100.0, SUBSTRING($0, 0, 1), $6 - $3;
dump calcs;
# (1344,2176.0,N,-0.05000000000000071)
